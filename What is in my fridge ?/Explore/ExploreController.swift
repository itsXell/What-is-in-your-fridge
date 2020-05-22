////
////  ExploreController.swift
////  What is in my fridge ?
////
////  Created by Xell on 18/5/2563 BE.
////  Copyright © 2563 Xell. All rights reserved.
////
//
//import UIKit
//
//class ExploreController: UIViewController {
//    
//    @IBOutlet var tableView: UITableView!
//
//    
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//    }
//
//}
//extension ExploreCell: UITableViewDataSource, UITableViewDelegate{
//      func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//          return 0
//      }
//      func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//          return 140.0;
//      }
//      
//      func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//          let cell = tableView.dequeueReusableCell(withIdentifier: "recipeCell") as! RecipeCell
//          let image = UIImage(named:"meat")
//          cell.img.image = image
//          return cell
//      }
//      
//      //    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//      //        tableView.deselectRow(at: indexPath, animated: true)
//      //        let currentSelected = json[indexPath.row]
//      //        if let vc = self.storyboard?.instantiateViewController(identifier: "detailViewController") as? DetailViewController{
//      //            vc.detailRest = currentSelected
//      //            navigationController?.pushViewController(vc, animated: true)
//      //
//      //        }
//      //    }
//      
//      
//  }
