//
//  MyFridgeViewController.swift
//  What is in my fridge ?
//
//  Created by Xell on 19/5/2563 BE.
//  Copyright © 2563 Xell. All rights reserved.
//

import UIKit

class category{
    var name:String! = ""
    var imageName:String! = ""
    var icon:String! = ""
    
    init(name:String, imageName:String,icon:String) {
        self.name = name
        self.imageName = imageName
        self.icon = icon
    }
}


class MyFridgeViewController: UIViewController {
    
    var categoryList:[category] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        categoryList.append(category(name:"Meat", imageName:"meat", icon: "meatIcon"))
        categoryList.append(category(name:"Vegetable", imageName:"vegetable", icon: "vegetableIcon"))
        categoryList.append(category(name:"Spice", imageName:"spices", icon: "spiceIcon"))
        categoryList.append(category(name:"Sauce", imageName:"sauce", icon: "sauceIcon"))
        categoryList.append(category(name:"Starch", imageName:"starch", icon: "flourIcon"))
        
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        self.navigationController?.navigationBar.tintColor = UIColor(red: 251/255, green: 33/255, blue: 142/255, alpha: 1)
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor(red: 251/255, green: 33/255, blue: 142/255, alpha: 1)]
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        super.viewWillDisappear(animated)
    }
}



extension MyFridgeViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell") as! CategoryViewCell
        let image = UIImage(named:categoryList[indexPath.row].imageName)
        cell.img.image = image
        cell.name.text = categoryList[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let currentSelected = categoryList[indexPath.row]
        if let vc = self.storyboard?.instantiateViewController(identifier: "ingredientController") as? IngredientViewController{
            vc.titleView = currentSelected.name
            vc.imageTitle = currentSelected.icon
            navigationController?.pushViewController(vc, animated: true)
            
        }
    }
    
    
}

