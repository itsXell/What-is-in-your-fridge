//
//  AddingIngredientController.swift
//  What is in my fridge ?
//
//  Created by Xell on 20/5/2563 BE.
//  Copyright © 2563 Xell. All rights reserved.
//

import UIKit
import CoreData

class AddingIngredientController: UIViewController {
    @IBOutlet var ingredientName: UITextField!
    @IBOutlet var amount: UITextField!
    @IBOutlet var expirationDate: UITextField!
    @IBOutlet var segmentControl: UISegmentedControl!
    var typeOfIngredient:String = "Meat"
    private var datePicker: UIDatePicker = UIDatePicker()
    
    let toolBar = UIToolbar()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        datePickerView()
        setSegmentedColor()
    }
    
    

    
    func datePickerView() {
        datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(AddingIngredientController.dateChanged(datePicker:)), for: .valueChanged)
        
        
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(AddingIngredientController.viewTapped(gestureRecognizer:)))
        
        view.addGestureRecognizer(tapGesture)
        expirationDate.inputView = datePicker
    }
    
    
    @IBAction func saveIngredient(){
        let checkIfEmpty = checkTextfield()
        if !checkIfEmpty {
            let amountOfIngredient = (amount.text! as NSString).doubleValue
            createData(name: String(ingredientName.text!), type: typeOfIngredient, amount: amountOfIngredient, expireDate: datePicker.date)
            
        }else{
            createAlertViewWithoutAction(title: "Information Invalid", description: "Please Fill all the information below")
        }
        
    }
    func setSegmentedColor(){
        segmentControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: UIControl.State.normal)
        segmentControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], for: UIControl.State.selected)
    }
    
    
    
    @IBAction func typeChange(_ sender: Any) {
        switch segmentControl.selectedSegmentIndex
        {
        case 0:
            typeOfIngredient = "Meat"
        case 1:
            typeOfIngredient = "Vegetable"
            
        case 2:
            typeOfIngredient = "Spice"
            
        case 3:
            typeOfIngredient = "Sauce"
            
        case 4:
            typeOfIngredient = "Starch"
            
        default:
            break
        }
    }
    
    
    @objc func viewTapped(gestureRecognizer: UITapGestureRecognizer){
        view.endEditing(true)
    }
    
    @objc func dateChanged(datePicker: UIDatePicker){
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "dd/MM/yy"
        expirationDate.text = dateFormat.string(from: datePicker.date)
        //        view.endEditing(true)
    }
    func checkTextfield() -> Bool {
        if ingredientName.text!.isEmpty || amount.text!.isEmpty || expirationDate.text!.isEmpty  {
            return true
        }else{
            return false
        }
    }
    
    
    
    
    
    
    func createAlertView(title:String,description:String) {
        let altMessage = UIAlertController(title: title, message: description, preferredStyle: UIAlertController.Style.alert)
        altMessage.addAction(UIAlertAction(title: "Done", style: UIAlertAction.Style.default, handler: { action in
            self.navigationController?.popViewController(animated: true)
        }))
        self.present(altMessage, animated: true, completion: nil)
        
    }
    func createAlertViewWithoutAction(title:String,description:String) {
           let altMessage = UIAlertController(title: title, message: description, preferredStyle: UIAlertController.Style.alert)
           altMessage.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: { action in
           }))
           self.present(altMessage, animated: true, completion: nil)
           
       }

    
    
    func createData(name:String,type:String,amount:Double, expireDate: Date){
        
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        

        let ingredientEntity = NSEntityDescription.entity(forEntityName: "IngredientModel", in: managedContext)!
        

        
        
        let ingredient = NSManagedObject(entity: ingredientEntity, insertInto: managedContext)
        ingredient.setValue(name, forKey: "ingreName")
        ingredient.setValue(type, forKey: "ingreType")
        ingredient.setValue(amount, forKey: "ingreAmount")
        ingredient.setValue(expireDate, forKey: "ingreExpire")
        
        
        
        
        do {
            try managedContext.save()
            createAlertView(title: "Success", description: "Ingredient Save")
            
            
        } catch let error as NSError {
            createAlertView(title: "Fail", description: "Error Occured!")
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
}
