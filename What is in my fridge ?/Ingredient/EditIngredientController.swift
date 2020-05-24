//
//  EditIngredientController.swift
//  What is in my fridge ?
//
//  Created by Xell on 21/5/2563 BE.
//  Copyright © 2563 Xell. All rights reserved.
//

import UIKit
import CoreData

class EditIngredientController: UIViewController {
    @IBOutlet var ingredientName: UITextField!
    @IBOutlet var amount: UITextField!
    @IBOutlet var expirationDate: UITextField!
    @IBOutlet var typeSelector: UISegmentedControl!
    private var datePicker: UIDatePicker = UIDatePicker()
    var selectIngredient:Ingredient? = nil
    var typeOfIngredient:String! = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        typeOfIngredient = selectIngredient?.type
        displayToTextField()
        datePickerView()
        setSegmentedColor()
        setSegmentIndex()
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func typeChange(_ sender: Any) {
        switch typeSelector.selectedSegmentIndex
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
    func setSegmentedColor(){
        typeSelector.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: UIControl.State.normal)
        typeSelector.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], for: UIControl.State.selected)
    }
    func setSegmentIndex(){
        switch typeOfIngredient {
        case "Meat":
            typeSelector.selectedSegmentIndex = 0
        case "Vegetable":
            typeSelector.selectedSegmentIndex = 1
        case "Spice":
            typeSelector.selectedSegmentIndex = 2
        case "Sauce":
            typeSelector.selectedSegmentIndex = 3
        case "Starch":
            typeSelector.selectedSegmentIndex = 4
        default:
            break
        }
    }
    
    func datePickerView() {
        datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(AddingIngredientController.dateChanged(datePicker:)), for: .valueChanged)
        
        
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(AddingIngredientController.viewTapped(gestureRecognizer:)))
        
        view.addGestureRecognizer(tapGesture)
        expirationDate.inputView = datePicker
    }
    
    @IBAction func updateIngredient(){
        let updateName:String! = ingredientName.text
        let updateAmount:Double! =  (amount.text! as NSString).doubleValue
        updateData(id: selectIngredient!.id, name: updateName , type: typeOfIngredient, amount: updateAmount, expireDate: datePicker.date)
        
    }
    
    
    func displayToTextField(){
        ingredientName.text = selectIngredient?.name
        let currentAmount:String = String(format:"%.1f", (selectIngredient?.amount!)!)
        amount.text = currentAmount
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "dd/MM/yy"
        datePicker.date = selectIngredient!.expireDate
        expirationDate.text = dateFormat.string(from: selectIngredient!.expireDate)
    }
    
    @objc func dateChanged(datePicker: UIDatePicker){
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "dd/MM/yy"
        expirationDate.text = dateFormat.string(from: datePicker.date)
        view.endEditing(true)
    }
    func createAlertView(title:String,description:String) {
        let altMessage = UIAlertController(title: title, message: description, preferredStyle: UIAlertController.Style.alert)
        altMessage.addAction(UIAlertAction(title: "Done", style: UIAlertAction.Style.default, handler: { action in
            self.navigationController?.popViewController(animated: true)
        }))
        self.present(altMessage, animated: true, completion: nil)
        
    }
    
    
    
    func updateData(id: NSObject,name:String,type:String,amount:Double, expireDate: Date){
       
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        

        let managedContext = appDelegate.persistentContainer.viewContext
        
        do
        {
            let ingredient = try managedContext.existingObject(with: id as! NSManagedObjectID)
            
            ingredient.setValue(name, forKey: "ingreName")
            ingredient.setValue(type, forKey: "ingreType")
            ingredient.setValue(amount, forKey: "ingreAmount")
            ingredient.setValue(expireDate, forKey: "ingreExpire")
            
            do{
                try managedContext.save()
                createAlertView(title: "Success", description: "Ingredient Updated")
            }
            catch
            {
                 createAlertView(title: "Fail", description: "Error Occured!")
                print(error)
            }
        }
        catch
        {
            print(error)
        }
        
    }
    
}
