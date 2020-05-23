//
//  ViewController.swift
//  What is in my fridge ?
//
//  Created by Xell on 25/4/2563 BE.
//  Copyright © 2563 Xell. All rights reserved.
//

import UIKit
import ObjectMapper
import CoreData

var globalRecipe:[Recipe] = []
var globalIngredient:[Ingredient] = []

class ViewController: UIViewController {
    @IBOutlet var searchBar: UITextField!
    @IBOutlet var buttonBar: UIView!
    @IBOutlet var recommendation: UIButton!
    @IBOutlet var explore: UIButton!
    @IBOutlet var ownRecipe: UIButton!
    @IBOutlet var tableView: UITableView!
    var tableList: [Recipe] = []
    let json: [Recipe] = Mapper<Recipe>().mapArray(JSONfile: "recipe.json")!
    var ownRecipeList:[Recipe] = []
    var ableDelete = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        retrieveData()
        alignText()
        displayToRecommend()
        //        retrieveData()
        for i in json {
            globalRecipe.append(i)
        }
        
        UserDefaults.standard.set(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
        let searchImage = UIImage(named: "search")!
        tabBarController?.tabBar.tintColor = UIColor(red: 251/255, green: 33/255, blue: 142/255, alpha: 1)
        addLeftImageTo(txtField: searchBar, andImage: searchImage)
        
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
    
    func displayContentController(content: UIViewController) {
        addChild(content)
        self.view.addSubview(content.view)
        content.didMove(toParent: self)
    }
    
    
    func add(_ parent: UIViewController,containerView: UIView) {
        
    }
    
    func remove() {
        guard parent != nil else { return }
        willMove(toParent: nil)
        removeFromParent()
        view.removeFromSuperview()
    }
    
    
    
    @IBAction func recommendationView(){
        ableDelete = false
        tableList.removeAll()
        displayToRecommend()
        retrieveData()
        tableView.reloadData()
        buttonAnimation(mainButton: recommendation, sideButton1: ownRecipe, sideButton2: explore)
    }
    @IBAction func exploreView(){
        ableDelete = false
        tableList.removeAll()
        retrieveData()
        tableList.append(contentsOf: json)
        tableView.reloadData()
        buttonAnimation(mainButton: explore, sideButton1: recommendation, sideButton2: ownRecipe)
    }
    
    @IBAction func ownRecipeView(){
        ableDelete = true
        tableList.removeAll()
        retrieveRecipe()
        tableView.reloadData()
        buttonAnimation(mainButton: ownRecipe, sideButton1: explore, sideButton2: recommendation)
        
    }
    func alignText (){
        explore.setNeedsLayout()
    }
    
    func buttonAnimation(mainButton: UIButton,sideButton1: UIButton,sideButton2:UIButton){
        mainButton.titleLabel?.font = UIFont(name:"HelveticaNeue-Bold",size: 17)
        sideButton1.titleLabel?.font = UIFont(name:"HelveticaNeue-Bold",size: 15)
        sideButton2.titleLabel?.font = UIFont(name:"HelveticaNeue-Bold",size: 15)
        mainButton.setTitleColor(.black, for: .normal)
        sideButton1.setTitleColor(.lightGray, for: .normal)
        sideButton2.setTitleColor(.lightGray, for: .normal)
        let x = mainButton.frame.origin.x-10
        let y = buttonBar.frame.origin.y
        let width = mainButton.frame.width-20
        let height = buttonBar.frame.height
        
        UIView.animate(withDuration: 0.5, animations: {
            
            self.buttonBar.frame = CGRect(x:x,y: y,width: width,height: height)
        },completion: nil)
    }
    
    func addLeftImageTo(txtField: UITextField, andImage img:UIImage){
        let iconWidth = 25.0
        let iconHeight = 25.0
        let imageView = UIImageView()
        imageView.image = img
        imageView.frame = CGRect(x:3,y:3, width: iconWidth,height: iconHeight)
        txtField.leftViewMode = .always
        txtField.addSubview(imageView)
        let paddingView = UIView(frame: CGRect(x: 0,y: 0,width: 25,height: txtField.frame.height))
        txtField.leftView = paddingView
    }
    
    func displayToRecommend()  {
        for i in json{
            var check = 0
            var approveAmount = Int((Double(i.ingredient.count) * 0.7).rounded(.towardZero))
            for j in i.ingredient {
                for k in globalIngredient{
                    if (k.name.lowercased().contains(j.name.lowercased()) && k.type.lowercased() == j.type.lowercased()) || k.name.lowercased() == j.name.lowercased() || ( j.name.lowercased().contains(k.name.lowercased()) &&  k.type.lowercased() == j.type.lowercased() ){
                        check += 1
                        if check >= approveAmount {
                            tableList.append(i)
                        }
                    }
                }
            }
        }
        tableView.reloadData()
    }
    
    
}

extension ViewController{
    
    
    func retrieveRecipe() {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "RecipeModel")
        
        //
        do {
            let result = try managedContext.fetch(fetchRequest)
            for data in result as! [NSManagedObject] {
                for j in json{
                    if data.value(forKey: "recipeName") as? String == j.name  {
                        tableList.append(j)
                    }
                }
            }
        } catch {
            
            print("Failed")
        }
    }
    public func retrieveData() {
        
        //As we know that container is set up in the AppDelegates so we need to refer that container.
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        //We need to create a context from this container
        let managedContext = appDelegate.persistentContainer.viewContext
        
        //Prepare the request of type NSFetchRequest  for the entity
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "IngredientModel")
        
        globalIngredient.removeAll()
        do {
            let result = try managedContext.fetch(fetchRequest)
            for data in result as! [NSManagedObject] {
                globalIngredient.append((Ingredient(id: data.objectID, name: data.value(forKey: "ingreName") as! String, type: data.value(forKey: "ingreType") as! String, amount: data.value(forKey: "ingreAmount") as! Double, expireDate: data.value(forKey: "ingreExpire") as! Date)))
            }
        } catch {
            print("Failed")
        }
    }
    func deleteData(name: String){
        
        //As we know that container is set up in the AppDelegates so we need to refer that container.
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        //We need to create a context from this container
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "RecipeModel")
        fetchRequest.predicate = NSPredicate(format: "recipeName = %@",name)
        //        fetchRequest.predicate = NSPredicate(format: "ingreType = %@", type)
        
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

extension ViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recipeCell") as! RecipeCell
        cell.name.text = tableList[indexPath.row].name
        let image = UIImage(named:tableList[indexPath.row].imageGalley[0])
        cell.img.image = image
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let currentSelected = tableList[indexPath.row]
        if let vc = self.storyboard?.instantiateViewController(identifier: "detailview") as? DetailViewController{
            vc.currentRecipe = currentSelected
            navigationController?.pushViewController(vc, animated: true)
            
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if ableDelete == true{
            if (editingStyle == UITableViewCell.EditingStyle.delete) {
                
                let alert = UIAlertController(title: "Delete", message: "Are you sure you want to delete?", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
                let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                    UIAlertAction in
                    let selectName = self.tableList[indexPath.row].name! as String
                    self.tableList.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .fade)
                    self.deleteData(name:selectName as String)
                }
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
            }
        }else{
            editingStyle == UITableViewCell.EditingStyle.none
        }
    }
    
}


