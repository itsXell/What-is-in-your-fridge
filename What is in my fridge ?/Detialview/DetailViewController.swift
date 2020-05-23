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
    
    @IBOutlet var imageSlide: ImageSlideshow!
    @IBOutlet var ingredientTable: UITableView!
    @IBOutlet var methodTable:UITableView!
    @IBOutlet var step:UILabel!
    var currentRecipe: Recipe? = nil
    
    
    
    
    @IBOutlet var ingredientHeight: NSLayoutConstraint!
    
    //    @IBOutlet var ingredientHeight: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = currentRecipe?.name
        displayMethod()
        
        self.ingredientHeight.constant = CGFloat(35 * (currentRecipe?.ingredient.count)!)
        for i in currentRecipe!.ingredient {
            checkIngredient(ingredientQuantity: i.quantity)
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
    
    func checkIngredient(ingredientQuantity: String) {
        if ingredientQuantity.lowercased().contains("tbs") {
            let result = ingredientQuantity.filter("0123456789.".contains)
            let amountToReduce = Double(result)!
            print(amountToReduce * 14.3)
        }
        
    }
    
    @IBAction func saveRecipe(){
        createRecipeInCoreData(name: (currentRecipe?.name)!)
    }
    
    func ImageSlideShow(){
        print(currentRecipe?.imageGalley[0])
        let img1 = (currentRecipe?.imageGalley[0])!
        let img2 = currentRecipe?.imageGalley[1]
        let img3 = currentRecipe?.imageGalley[2]
        imageSlide.setImageInputs([ImageSource(image: UIImage(named: "meat")!),
                                   ImageSource(image: UIImage(named: img2!)!),
                                   ImageSource(image: UIImage(named: img3!)!),])
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




extension DetailViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (currentRecipe?.ingredient.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ingredientCell") as! IngredientCell
        cell.name.text = currentRecipe?.ingredient[indexPath.row].name
        cell.amount.text = currentRecipe?.ingredient[indexPath.row].quantity
        
        var  amount = checkIngredient(ingredientName: (currentRecipe?.ingredient[indexPath.row].name)!, ingredientType: (currentRecipe?.ingredient[indexPath.row].type)!)
        return cell
        
    }
    
    //    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    //        tableView.deselectRow(at: indexPath, animated: true)
    //        let currentSelected = tableList[indexPath.row]
    //        if let vc = self.storyboard?.instantiateViewController(identifier: "detailview") as? DetailViewController{
    //            vc.currentRecipe = currentSelected
    //            navigationController?.pushViewController(vc, animated: true)
    //
    //        }
    //    }
    
}


//extension DetailViewController: UITableViewDataSource, UITableViewDelegate{
//    
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        var count = 0
//        if tableView == ingredientTable {
//            count = currentRecipe!.ingredient.count
//            return count
//            
//        }else if tableView == methodTable{
//            count = currentRecipe!.step.count
//            return count
//        }
//        return count
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        if tableView == ingredientTable {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "ingredientCell") as! IngredientCell
//            cell.name.text = currentRecipe?.ingredient[indexPath.row].name
//            cell.amount.text = currentRecipe?.ingredient[indexPath.row].quantity
//            heightOfEachCell = Double(cell.frame.height)
//            print(heightOfEachCell)
//            var  amount = checkIngredient(ingredientName: (currentRecipe?.ingredient[indexPath.row].name)!, ingredientType: (currentRecipe?.ingredient[indexPath.row].type)!)
//            cell.infridge.text = String(amount)
//            return cell
//        }else if tableView == methodTable {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "methodCell") as! StepCell
//            
//            cell.step.text = String(indexPath.row + 1) + ". " + currentRecipe!.step[indexPath.row]
//            
//            //            cell.step.text =
//            return cell
//        }
//        return UITableViewCell()
//        
//    }
//}

