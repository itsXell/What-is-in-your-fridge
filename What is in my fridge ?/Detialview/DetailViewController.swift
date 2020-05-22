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
    
    @IBOutlet var imageSlide: ImageSlideshow!
    @IBOutlet var ingredientTable: UITableView!
    @IBOutlet var methodTable:UITableView!
    var currentRecipe: Recipe? = nil
    var heightOfCell = 5
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = currentRecipe?.name
        print(currentRecipe?.name)
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
    
    // share text
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
    
    
    func generatePDF(title:String,ingredient:String,step:String){
        let format = UIGraphicsPDFRendererFormat()
        let metaData = [kCGPDFContextTitle:title,
                        kCGPDFOutlineTitle:ingredient,
                        kCGPDFContextAuthor:"Xell"]
        format.documentInfo = metaData as [String: Any]
        let pageRect = CGRect(x: 0, y: 0, width: 595, height: 842)
        let renderer = UIGraphicsPDFRenderer(bounds: pageRect,
                                             format: format)
        let url = URL(fileURLWithPath: "/Users/xell/Documents/IOS /What is in my fridge ?/What is in my fridge ?")
        try? renderer.writePDF(to: url) {(context) in
            context.beginPage()
            
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            let attributes = [
                NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14),
                NSAttributedString.Key.paragraphStyle: paragraphStyle
            ]
            let text = "Hello, World!"
            let textRect = CGRect(x: 100, // left margin
                y: 100, // top margin
                width: 200,
                height: 20)
            
            text.draw(in: textRect, withAttributes: attributes) }
        //        let data = renderer.pdfData { (context) in
        //          context.beginPage()
        //
        //          let paragraphStyle = NSMutableParagraphStyle()
        //          paragraphStyle.alignment = .center
        //          let attributes = [
        //            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14),
        //            NSAttributedString.Key.paragraphStyle: paragraphStyle
        //          ]
        //          let text = "Hello, World!"
        //          let textRect = CGRect(x: 100, // left margin
        //                                y: 100, // top margin
        //                            width: 200,
        //                           height: 20)
        //
        //          text.draw(in: textRect, withAttributes: attributes)
        //        }
        //        let pdfDocument = PDFDocument(data: data)
        //        pdfDocument?.write(to: path)
    }
    
    
}




