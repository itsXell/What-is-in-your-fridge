//
//  IngredientViewController.swift
//  What is in my fridge ?
//
//  Created by Xell on 19/5/2563 BE.
//  Copyright © 2563 Xell. All rights reserved.
//

import UIKit
import CoreData




class IngredientViewController: UIViewController {
    
    var ingredientList:[Ingredient] = []
    var titleView: String! = ""
    var datePicker:UIDatePicker = UIDatePicker()
    let toolBar = UIToolbar()
    @IBOutlet var tableView: UITableView!
    let cellSpacingHeight: CGFloat = 5
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        retrieveData()
        tableView.reloadData()
        //        ingredientList.append(Ingredient(name: "Carrot", type: "vegetable", amount: 500, expireDate: "10-10-2020"))
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        ingredientList.removeAll()
        retrieveData()
        tableView.reloadData()
        super.viewWillAppear(animated)
    }
    
    @IBAction func addIngredient(){
        let vc = (self.storyboard?.instantiateViewController(identifier: "addingredienView"))!
        if let vc_secondVC = vc as? AddingIngredientController{
            vc_secondVC.modalPresentationStyle = .fullScreen
            self.present(vc_secondVC,animated: true)
        }
    }
    func retrieveData() {
        
        //As we know that container is set up in the AppDelegates so we need to refer that container.
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        //We need to create a context from this container
        let managedContext = appDelegate.persistentContainer.viewContext
        
        //Prepare the request of type NSFetchRequest  for the entity
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "IngredientModel")
        
        //        fetchRequest.fetchLimit = 1
        //        fetchRequest.predicate = NSPredicate(format: "username = %@", "Ankur")
        //        fetchRequest.sortDescriptors = [NSSortDescriptor.init(key: "email", ascending: false)]
        //
        do {
            let result = try managedContext.fetch(fetchRequest)
            for data in result as! [NSManagedObject] {
                if data.value(forKey: "ingreType") as? String == titleView {
                    print("Object id")
                    print(data.objectID)
                    ingredientList.append((Ingredient(id: data.objectID, name: data.value(forKey: "ingreName") as! String, type: data.value(forKey: "ingreType") as! String, amount: data.value(forKey: "ingreAmount") as! Double, expireDate: data.value(forKey: "ingreExpire") as! Date)))
                    //                    print(data.value(forKey: "ingreName") as! String)
                    //                    print(data.value(forKey: "ingreType") as! String)
                }
            }
            
        } catch {
            
            print("Failed")
        }
    }
    func deleteData(name: String){
        
        //As we know that container is set up in the AppDelegates so we need to refer that container.
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        //We need to create a context from this container
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "IngredientModel")
        fetchRequest.predicate = NSPredicate(format: "ingreName = %@",name)
        //        fetchRequest.predicate = NSPredicate(format: "ingreType = %@", type)
        
        do
        {
            let test = try managedContext.fetch(fetchRequest)
            
            let objectToDelete = test[0] as! NSManagedObject
            managedContext.delete(objectToDelete)
            
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

extension IngredientViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ingredientList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ingredientCell") as! IngredientViewCell
        let image = UIImage(named:"food")
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "dd/MM/yy"
        cell.imageView?.image = image
        cell.ingredient.text = String(ingredientList[indexPath.row].name)
        cell.amount.text = String(ingredientList[indexPath.row].amount)
        cell.expireDate.text = dateFormat.string(from: ingredientList[indexPath.row].expireDate)
        return cell
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let currentSelected = ingredientList[indexPath.row]
        if let vc = self.storyboard?.instantiateViewController(identifier: "editingredienView") as? EditIngredientController{
            vc.selectIngredient = currentSelected
            navigationController?.pushViewController(vc, animated: true)
            
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCell.EditingStyle.delete) {
            let alert = UIAlertController(title: "Delete", message: "Are you sure you want to delete?", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
            let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                UIAlertAction in
                let selectName = self.ingredientList[indexPath.row].name! as String
                self.ingredientList.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                self.deleteData(name:selectName as String)
            }
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    //        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    //            tableView.deselectRow(at: indexPath, animated: true)
    //            let currentSelected = json[indexPath.row]
    //            if let vc = self.storyboard?.instantiateViewController(identifier: "detailViewController") as? DetailViewController{
    //                vc.detailRest = currentSelected
    //                navigationController?.pushViewController(vc, animated: true)
    //
    //            }
    //        }
    
    
}