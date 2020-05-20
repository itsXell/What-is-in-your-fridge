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
    @IBOutlet var typeSelector: UISegmentedControl!
    var typeOfIngredient:String = "Meats"
    private var datePicker: UIDatePicker = UIDatePicker()
    let toolBar = UIToolbar()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        datePickerView()
        
        
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
            createAlertView(title: "Information Invalid", description: "Please Fill all the information below")
        }
        
    }
    
    @IBAction func typeChange(_ sender: Any) {
        switch typeSelector.selectedSegmentIndex
        {
        case 0:
            typeOfIngredient = "Meats"
        case 1:
            typeOfIngredient = "Vegetables"
        case 2:
            typeOfIngredient = "Spices"
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
        var altMessage = UIAlertController(title: title, message: description, preferredStyle: UIAlertController.Style.alert)
        altMessage.addAction(UIAlertAction(title: "Done", style: UIAlertAction.Style.default, handler: nil))
        self.present(altMessage, animated: true, completion: nil)
        
    }
    
    
    func createData(name:String,type:String,amount:Double, expireDate: Date){
        
        //As we know that container is set up in the AppDelegates so we need to refer that container.
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        //We need to create a context from this container
        let managedContext = appDelegate.persistentContainer.viewContext
        
        //Now let’s create an entity and new user records.
        let ingredientEntity = NSEntityDescription.entity(forEntityName: "IngredientModel", in: managedContext)!
        
        //final, we need to add some data to our newly created record for each keys using
        //here adding 5 data with loop
        
        
        
        let ingredient = NSManagedObject(entity: ingredientEntity, insertInto: managedContext)
        ingredient.setValue(name, forKey: "ingreName")
        ingredient.setValue(type, forKey: "ingreType")
        ingredient.setValue(amount, forKey: "ingreAmount")
        ingredient.setValue(expireDate, forKey: "ingreExpire")
        
        
        
        
        do {
            try managedContext.save()
            createAlertView(title: "Success", description: "Ingredient Save")
            navigationController?.popViewController(animated: true)
            
        } catch let error as NSError {
            createAlertView(title: "Fail", description: "Error Occured!")
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
}