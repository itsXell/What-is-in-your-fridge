//
//  DetailViewController.swift
//  What is in my fridge ?
//
//  Created by Xell on 21/5/2563 BE.
//  Copyright © 2563 Xell. All rights reserved.
//

import UIKit
import PDFKit
import ImageSlideshow
import CoreData


class DetailViewController: UIViewController {
    
    @IBOutlet var slideShow: ImageSlideshow!
    @IBOutlet var ingredientTable: UITableView!
    @IBOutlet var favorite: UIButton!
    @IBOutlet var credit: UILabel!
    
    @IBOutlet var step:UILabel!
    var currentRecipe: Recipe? = nil
    var listOfSaveRecipe:[String] = []
    
    
    
    
    
    @IBOutlet var ingredientHeight: NSLayoutConstraint!
    
    //    @IBOutlet var ingredientHeight: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = currentRecipe?.name
        credit.text = currentRecipe?.credit
        displayMethod()
        setFavoriteButton()
        ImageSlideShow()
        self.ingredientHeight.constant = CGFloat(35 * (currentRecipe?.ingredient.count)!)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    func setFavoriteButton(){
        retrieveSaveRecipe()
        if listOfSaveRecipe.contains((currentRecipe?.name)!) {
            let image = UIImage(systemName: "star.fill")
            favorite.setImage(image, for: .normal)
            favorite.isEnabled = false
        }else{
            favorite.isEnabled = true
        }
    }
    
    func displayMethod(){
        var method = ""
        var steps = 1
        for i in currentRecipe!.step{
            
            method += String(steps) + ". " + i + "\n\n"
            steps += 1
        }
        step.text = method
    }
    
    func checkIngredient(ingredientQuantity: String) -> Double {
        if ingredientQuantity.lowercased().contains("tbs") {
            let result = ingredientQuantity.filter("0123456789.".contains)
            let amountToReduce = Double(result)! * 14.3
            return amountToReduce
        }else{
            let result = ingredientQuantity.filter("0123456789.".contains)
            let amountToReduce = Double(result)!
            return amountToReduce
        }
    }
    
    @IBAction func saveRecipe(){
        let image = UIImage(systemName: "star.fill")
        favorite.setImage(image, for: .normal)
        favorite.isEnabled = false
        createRecipeInCoreData(name: (currentRecipe?.name)!)
    }
    
    func ImageSlideShow(){
        
        let img1 = (currentRecipe?.imageGalley[1])!
        let img2 = currentRecipe?.imageGalley[2]
        let img3 = currentRecipe?.imageGalley[3]
        slideShow.setImageInputs([ImageSource(image: UIImage(named: img1)!),
                                  ImageSource(image: UIImage(named: img2!)!),
                                  ImageSource(image: UIImage(named: img3!)!),])
    }
    
    @IBAction func cook(){
        if checkIfHaveAllIngredient(){
            let alert = UIAlertController(title: "Cook", message: "You don't have enough ingredient. Want to Cook any Way?", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.cancel, handler: nil))
            let okAction = UIAlertAction(title: "Yes", style: UIAlertAction.Style.default) {
                UIAlertAction in
                self.reduceAmountFromFridge()
            }
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }else{
            let alert = UIAlertController(title: "Cook", message: "The amount will automatically reduce from your fridge", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.cancel, handler: nil))
            let okAction = UIAlertAction(title: "Yes", style: UIAlertAction.Style.default) {
                UIAlertAction in
                self.reduceAmountFromFridge()
            }
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
    func reduceAmountFromFridge(){
        for i in globalIngredient{
            for j in currentRecipe!.ingredient{
                
                if (i.name.lowercased().contains(j.name.lowercased()) && i.type.lowercased().contains(j.type.lowercased()))  || j.name.lowercased() == i.name.lowercased() || (j.name.lowercased().contains(i.name.lowercased()) && j.name.lowercased().contains(i.type.lowercased())) {
                    var amountToReduce = checkIngredient(ingredientQuantity: j.quantity)
                    i.amount -= amountToReduce
                    if i.amount <= 0 {
                        deleteData(name: i.name)
                    }else{
                        updateIngredientInFridge(id: i.id, name: i.name, type: i.type, amount: i.amount, expireDate: i.expireDate)
                    }
                    
                }
            }
        }
    }
    func checkIfHaveAllIngredient() -> Bool{
        var temp = 0
        for i in globalIngredient{
            for j in currentRecipe!.ingredient{
                if (i.name.lowercased().contains(j.name.lowercased()) && i.type.lowercased().contains(j.type.lowercased()))  || j.name.lowercased() == i.name.lowercased() || (j.name.lowercased().contains(i.name.lowercased()) && j.name.lowercased().contains(i.type.lowercased())) {
                    temp += 1
                }
            }
        }
        if temp == currentRecipe?.ingredient.count {
            return true
        }else{
            return false
        }
    }
    
    func createRecipeInCoreData(name:String){
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        
        let ingredientEntity = NSEntityDescription.entity(forEntityName: "RecipeModel", in: managedContext)!
        
        
        
        let ingredient = NSManagedObject(entity: ingredientEntity, insertInto: managedContext)
        ingredient.setValue(name, forKey: "recipeName")
        do {
            try managedContext.save()
            createAlertView(title: "Success", description: "Recipe Save")
            
            
        } catch let error as NSError {
            createAlertView(title: "Fail", description: "Error Occured!")
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func createAlertView(title:String,description:String) {
        let altMessage = UIAlertController(title: title, message: description, preferredStyle: UIAlertController.Style.alert)
        altMessage.addAction(UIAlertAction(title: "Done", style: UIAlertAction.Style.default, handler: { action in
        }))
        self.present(altMessage, animated: true, completion: nil)
        
    }
    
    
    
    func checkIngredient(ingredientName:String, ingredientType:String) -> Double {
        var amount = 0.0
        for i in globalIngredient{
            if (ingredientName.lowercased().contains(i.name.lowercased()) && ingredientType.lowercased().contains(i.type.lowercased()))  || ingredientName.lowercased() == i.name.lowercased() || (i.name.lowercased().contains(ingredientName.lowercased()) && ingredientType.lowercased().contains(i.type.lowercased())) {
                amount = i.amount
                return amount
            }
        }
        return amount
    }
    
    @IBAction func shareTextButton(_ sender: UIButton) {
        
        // text to share
        let text = currentRecipe?.credit
        
        // set up activity view controller
        let textToShare = [ text ]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        
        // exclude some activity types from the list (optional)
        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]
        
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
        
    }
    
    
    
}

extension DetailViewController{
    
    
    func retrieveSaveRecipe() {
        
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "RecipeModel")
        
        //
        do {
            let result = try managedContext.fetch(fetchRequest)
            for data in result as! [NSManagedObject] {
                listOfSaveRecipe.append(data.value(forKey: "recipeName") as! String)
            }
        } catch {
            
            print("Failed")
        }
    }
    func updateIngredientInFridge(id: NSObject,name:String,type:String,amount:Double, expireDate: Date){
        
        //As we know that container is set up in the AppDelegates so we need to refer that container.
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        //We need to create a context from this container
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
    
    func deleteData(name: String){
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "IngredientModel")
        fetchRequest.predicate = NSPredicate(format: "ingreName = %@",name)
        
        
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




extension DetailViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ((currentRecipe?.ingredient.count)!)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ingredientCell") as! IngredientCell
        if indexPath.row == 0{
            cell.name.text = "Name"
            cell.name.font = UIFont.boldSystemFont(ofSize: cell.name.font.pointSize)
            cell.amount.text = "Amount"
            cell.amount.font = UIFont.boldSystemFont(ofSize: cell.amount.font.pointSize)
            cell.infridge.text = "In fridge"
            cell.infridge.font = UIFont.boldSystemFont(ofSize: cell.infridge.font.pointSize)
            return cell
        }else{
            cell.name.text = currentRecipe?.ingredient[indexPath.row].name
            cell.amount.text = currentRecipe?.ingredient[indexPath.row].quantity
            var  amount = checkIngredient(ingredientName: (currentRecipe?.ingredient[indexPath.row].name)!, ingredientType: (currentRecipe?.ingredient[indexPath.row].type)!)
            if amount == 0.0{
                cell.infridge.textColor = UIColor.red
            }
            cell.infridge.text = String(amount) + "g"
            return cell
        }
        
        return UITableViewCell()
        
        
    }
    
}


