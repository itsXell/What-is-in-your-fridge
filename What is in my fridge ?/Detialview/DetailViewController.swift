//
//  DetailViewController.swift
//  What is in my fridge ?
//
//  Created by Xell on 21/5/2563 BE.
//  Copyright © 2563 Xell. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    
    @IBOutlet var imageSlide: UIView!
    @IBOutlet var ingredientTable: UITableView!
    @IBOutlet var methodTable:UITableView!
    var currentRecipe: Recipe? = nil
    var heightOfCell = 5
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var size = currentRecipe?.ingredient.count
        ingredientTable.frame = CGRect(x: ingredientTable.frame.origin.x, y: ingredientTable.frame.origin.y, width: ingredientTable.frame.size.width, height: CGFloat(size!*heightOfCell))
        print(currentRecipe?.name)
        
    }
    
    func checkIngredient(ingredientName:String, ingredientType:String) -> Double {
        var amount = 0.0
        for i in globalIngredient{
            if (ingredientName.lowercased().contains(i.name.lowercased()) && ingredientType.lowercased() == i.type.lowercased())  || ingredientName.lowercased() == i.name.lowercased() {
                amount = i.amount
                return amount
            }
        }
        return amount
    }
    
    
}


extension DetailViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 0
        if tableView == ingredientTable {
            count = currentRecipe!.ingredient.count
            return count
            
        }else if tableView == methodTable{
            count = currentRecipe!.step.count
            return count
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == ingredientTable {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ingredientCell") as! IngredientCell
            cell.name.text = currentRecipe?.ingredient[indexPath.row].name
            cell.amount.text = currentRecipe?.ingredient[indexPath.row].quantity
            var  amount = checkIngredient(ingredientName: (currentRecipe?.ingredient[indexPath.row].name)!, ingredientType: (currentRecipe?.ingredient[indexPath.row].type)!)
            cell.infridge.text = String(amount)
            return cell
        }else if tableView == methodTable {
            let cell = tableView.dequeueReusableCell(withIdentifier: "methodCell") as! StepCell

            cell.step.text = String(indexPath.row + 1) + ". " + currentRecipe!.step[indexPath.row]
        
//            cell.step.text =
            return cell
        }
        return UITableViewCell()
        
    }
    
    //    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    //        tableView.deselectRow(at? indexPath, animated: true)
    //        let currentSelected = globalRecipe[indexPath.row]
    //        if let vc = self.storyboard?.instantiateViewController(identifier: "detailview") as? DetailViewController{
    //            vc.currentRecipe = currentSelected
    //            navigationController?.pushViewController(vc, animated: true)
    //
    //        }
    //    }
    
}




//extension DetailViewController: UITableViewDataSource, UITableViewDelegate{
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        var count = 0
//        if tableView == ingredientTable {
//            count = currentRecipe!.ingredient.count
//            return count
//        }else if tableView == methodTable{
//            count = currentRecipe!.step.count
//            return count
//        }
//        return count
//    }
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        var cell:UITableViewCell?
//        if tableView == ingredientTable,
//            let cell = tableView.dequeueReusableCell(withIdentifier: "ingredientCell") as! IngredientCell {
//            cell.name.text = currentRecipe!.ingredient[indexPath.row].name
//            cell.amount.text = currentRecipe!.ingredient[indexPath.row].quantity
//            cell.name.text = currentRecipe!.ingredient[indexPath.row].name
//            return cell
//        } else if tableView == methodTable,
//            let cell = tableView.dequeueReusableCell(withIdentifier: "methocell") as? UITableViewCell {
//            cell.textLabel?.text = String(indexPath.row) + ". " + currentRecipe!.step[indexPath.row]
//            return cell
//        }
//
//        return UITableViewCell()
//    }
//





//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        var cell = UITableViewCell()
//        if tableView == ingredientTable{
//            print("run")
//            let cell = tableView.dequeueReusableCell(withIdentifier: "ingredientCell") as! IngredientCell
//            cell.name.text = currentRecipe!.ingredient[indexPath.row].name
//            cell.amount.text = currentRecipe!.ingredient[indexPath.row].quantity
//            cell.name.text = currentRecipe!.ingredient[indexPath.row].name
//            return cell
//
//
//        }else if tableView == methodTable{
//            let cell = tableView.dequeueReusableCell(withIdentifier: "methocell", for: indexPath)
//            cell.textLabel?.text = String(indexPath.row) + ". " + currentRecipe!.step[indexPath.row]
//            return cell
//
//
//        }
//         return cell
//    }

//}

