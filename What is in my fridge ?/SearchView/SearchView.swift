//
//  SearchView.swift
//  What is in my fridge ?
//
//  Created by Xell on 24/5/2563 BE.
//  Copyright © 2563 Xell. All rights reserved.
//

import UIKit

class SearchView: UIViewController {
    var textFromFirstScreen:String = ""
    var recipeSearch:[Recipe] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        findRecipe()
        
        // Do any additional setup after loading the view.
    }
    func findRecipe()  {
        for i in globalRecipe {
            if (i.name?.lowercased().contains(textFromFirstScreen.lowercased()))!{
                recipeSearch.append(i)
            }
        }
    }
    
    
}
extension SearchView: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipeSearch.count
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchcell") as! SearchCell
        cell.name.text = recipeSearch[indexPath.row].name
        let image = UIImage(named:recipeSearch[indexPath.row].imageGalley[0])
        cell.img.image = image
        cell.calories.text = recipeSearch[indexPath.row].calories
        cell.time.text = recipeSearch[indexPath.row].calories
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let currentSelected = recipeSearch[indexPath.row]
        if let vc = self.storyboard?.instantiateViewController(identifier: "detailview") as? DetailViewController{
            vc.currentRecipe = currentSelected
            navigationController?.pushViewController(vc, animated: true)
            
            
        }
        
    }
    
    
}

