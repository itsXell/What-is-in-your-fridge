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


class DetailViewController: UIViewController {

    @IBOutlet var imageSlide: UIView!
    @IBOutlet var ingredientTable: UITableView!
    @IBOutlet var methodTable:UITableView!
    @IBOutlet var step:UILabel!
    var currentRecipe: Recipe? = nil
  

    var heightOfCell = 5
  
    var scrollView:UIScrollView!
  

    
  
    
    
//    @IBOutlet var ingredientHeight: NSLayoutConstraint!
    var heightOfEachCell = 0.0

  

   
    
    @IBOutlet var ingredientHeight: NSLayoutConstraint!
    
    //    @IBOutlet var ingredientHeight: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = currentRecipe?.name
        
//        var convertToInt = CGFloat((currentRecipe?.ingredient.count)! as Int)
//              self.ingredientHeight.constant = CGFloat(3000)
        self.ingredientHeight.constant = CGFloat(84 * (currentRecipe?.ingredient.count)!)
//        print(ingredientTable.rowHeight)
//           ingredientTable.estimatedRowHeight = UITableView.automaticDimension
//        step.text = (currentRecipe?.step[0])!+"\n" + (currentRecipe?.step[1])!
//        step.preferredMaxLayoutWidth = 150
//        var contentSize = ingredientTable.contentSize.height * (currentRecipe?.ingredient.count)!
//        self.ingredientHeight.constant = contentSize
//        self.methodHeight.constant = 300
//        var bigRect = view.bounds
//        bigRect.size.width *= CGFloat(300)
//
//        scrollView.contentSize = bigRect.size
     
    
      
        
        print(currentRecipe?.name)
    }
//    override func loadView() {
//        scrollView = UIScrollView(frame: UIScreen.main.bounds)
//           view = scrollView
//       }
    
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
            heightOfEachCell = Double(cell.frame.height)
            print(heightOfEachCell)
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
}
extension UIScrollView {

    func resizeScrollViewContentSize() {

        var contentRect = CGRect.zero

        for view in self.subviews {

            contentRect = contentRect.union(view.frame)

        }

        self.contentSize = contentRect.size

    }

}
