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
    var typeOfIngredient:String! = "Meats"
    var selectIngredient:Ingredient? = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        displayToTextField()
        
        
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
    
    @IBAction func updateIngredient(){
        let updateName:String! = ingredientName.text
        let updateAmount:Double! =  (amount.text! as NSString).doubleValue
        updateData(id: selectIngredient!.id, name: updateName , type: typeOfIngredient, amount: updateAmount, expireDate: datePicker.date)
        
    }
    
    
    func displayToTextField(){
        ingredientName.text = selectIngredient?.name
        let currentAmount:String = String(format:"%.1f", (selectIngredient?.amount!)!)
        amount.text = currentAmount
        //        let dateFormat = DateFormatter()
        //        dateFormat.dateFormat = "dd/MM/yy"
        //        expirationDate.text = dateFormat.string(from: selectIngredient!.expireDate)
    }
    
    @objc func dateChanged(datePicker: UIDatePicker){
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "dd/MM/yy"
        expirationDate.text = dateFormat.string(from: datePicker.date)
        //        view.endEditing(true)
    }
    
    
    
    func updateData(id: NSObject,name:String,type:String,amount:Double, expireDate: Date){
        
        //As we know that container is set up in the AppDelegates so we need to refer that container.
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        //We need to create a context from this container
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "User")
        fetchRequest.predicate = NSPredicate(format: "username = %@", "Ankur1")
        do
        {
            let ingredient = try managedContext.existingObject(with: id as! NSManagedObjectID)
            
            ingredient.setValue(name, forKey: "ingreName")
            ingredient.setValue(type, forKey: "ingreType")
            ingredient.setValue(amount, forKey: "ingreAmount")
            ingredient.setValue(expireDate, forKey: "ingreExpire")
            
            do{
                try managedContext.save()
            }
            catch
            {
                print(error)
            }
        }
        catch
        {
            print(error)
        }
        
    }
    
    
    
    
    
    
    
    
}
