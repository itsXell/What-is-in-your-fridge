////
////  RecommendationController.swift
////  What is in my fridge ?
////
////  Created by Xell on 25/4/2563 BE.
////  Copyright © 2563 Xell. All rights reserved.
////
//
//import UIKit
//
//class RecommendationController: UIViewController {
//    let testing = ["Fried Holly Basil","Spaghetti"]
//    let cellSpacingHeight: CGFloat = 5
//    @IBOutlet var tableView : UITableView!
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//    }
//}
//extension RecommendationController: UITableViewDataSource, UITableViewDelegate{
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return globalRecipe.count
//    }
//    
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "recipeCell") as! RecipeCell
//        let image = UIImage(named:"meat")
//        cell.img.image = image
//        return cell
//    }
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
//    
//    
//}
//
