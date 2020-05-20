//
//  CRUD.swift
//  What is in my fridge ?
//
//  Created by Xell on 20/5/2563 BE.
//  Copyright © 2563 Xell. All rights reserved.
//

import Foundation

class CRUD{
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
        
        
        
        //Now we have set all the values. The next step is to save them inside the Core Data
        
        do {
            try managedContext.save()
            createAlertView(title: "Success", description: "Ingredient Save")
            
        } catch let error as NSError {
            createAlertView(title: "Fail", description: "Error Occured!")
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
}
