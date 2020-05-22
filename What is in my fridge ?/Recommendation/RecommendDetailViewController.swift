//
//  RecommendDetailViewController.swift
//  What is in my fridge ?
//
//  Created by Xell on 21/5/2563 BE.
//  Copyright © 2563 Xell. All rights reserved.
//

import UIKit

class RecommendDetailViewController: UIViewController {
    var current:[Recipe] = []
    var currentRecipe:Recipe? = nil
    @IBOutlet var ingredientTable: UITableView!
//    @IBOutlet var methodTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(currentRecipe?.name)
        
    }
    
}
extension RecommendDetailViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return globalRecipe.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reingredientcell") as! RecomIngredientTableViewCell
        cell.title.text = globalRecipe[indexPath.row].name
        return cell
    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
//        let currentSelected = globalRecipe[indexPath.row]
//        if let vc = self.storyboard?.instantiateViewController(identifier: "recommendDetailView") as? RecommendDetailViewController{
//            vc.currentRecipe = currentSelected
//            vc.current.removeAll()
//            vc.current.append(currentSelected)
//            vc.modalPresentationStyle = .fullScreen
//            navigationController?.pushViewController(vc, animated: true)
//
//        }
//    }
    
    
}




//extension RecommendDetailViewController: UITableViewDataSource, UITableViewDelegate{
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        var count:Int?
//        if tableView == ingredientTable {
//            count = currentRecipe!.ingredient.count
//            return count!
//        }else if tableView == methodTable{
//            count = currentRecipe!.step.count
//            return count!
//        }
//        return count!
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        if tableView == ingredientTable,
//            let cell = tableView.dequeueReusableCell(withIdentifier: "reingredientcell") as? RecomIngredientTableViewCell {
////            let cell = tableView.dequeueReusableCell(withIdentifier: "reingredientcell") as! RecomIngredientTableViewCell
//
//            cell.amount.text = currentRecipe!.ingredient[indexPath.row].quantity
//            cell.name.text = currentRecipe!.ingredient[indexPath.row].name
//            return cell
//        } else if tableView == methodTable,
//            let cell = tableView.dequeueReusableCell(withIdentifier: "remethodcell") as? RecomMethodTableViewCell {
//            cell.method.text = currentRecipe!.step[indexPath.row]
//            return cell
//        }
////        if tableView == ingredientTable{
////            let cell = tableView.dequeueReusableCell(withIdentifier: "reingredientcell") as! RecomIngredientTableViewCell
////            cell.amount.text = currentRecipe?.ingredient[indexPath.row].quantity
////            cell.name.text = currentRecipe?.ingredient[indexPath.row].name
////            return cell
////        }else if tableView == methodTable{
////            let cell = tableView.dequeueReusableCell(withIdentifier: "remethodcell") as! RecomMethodTableViewCell
////            cell.method.text = currentRecipe?.step[indexPath.row]
////            return cell
////        }
//        return UITableViewCell()
//    }
//
//
//}
