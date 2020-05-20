//
//  ViewController.swift
//  What is in my fridge ?
//
//  Created by Xell on 25/4/2563 BE.
//  Copyright © 2563 Xell. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var searchBar: UITextField!
    @IBOutlet var buttonBar: UIView!
    @IBOutlet var recommendation: UIButton!
    @IBOutlet var explore: UIButton!
    @IBOutlet var ownRecipe: UIButton!
    @IBOutlet var recommendationController: UIView!
    @IBOutlet var ownRecipeController: UIView!
    @IBOutlet var exploreController: UIView!
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showRecommendationFirst()
        // Do any additional setup after loading the view.
        UserDefaults.standard.set(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
        let searchImage = UIImage(named: "search")!
        tabBarController?.tabBar.tintColor = UIColor(red: 251/255, green: 33/255, blue: 142/255, alpha: 1)
        addLeftImageTo(txtField: searchBar, andImage: searchImage)
        
    }
    override func prepare(for segue:  UIStoryboardSegue, sender: Any?){
        
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
    //
    
    
    @IBAction func recommendationView(){
        recommendationController.alpha = 1
        exploreController.alpha = 0
        ownRecipeController.alpha = 0
        buttonAnimation(mainButton: recommendation, sideButton1: ownRecipe, sideButton2: explore)
    }
    @IBAction func exploreView(){
        recommendationController.alpha = 0
        exploreController.alpha = 1
        ownRecipeController.alpha = 0
        buttonAnimation(mainButton: explore, sideButton1: recommendation, sideButton2: ownRecipe)
    }
    
    @IBAction func ownRecipeView(){
        recommendationController.alpha = 0
        exploreController.alpha = 0
        ownRecipeController.alpha = 1
        buttonAnimation(mainButton: ownRecipe, sideButton1: explore, sideButton2: recommendation)
        
    }
    
    func buttonAnimation(mainButton: UIButton,sideButton1: UIButton,sideButton2:UIButton){
        mainButton.titleLabel?.font = UIFont(name:"HelveticaNeue-Bold",size: 18)
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
    
    func showRecommendationFirst(){
        let x = recommendation.frame.origin.x-10
        let y = buttonBar.frame.origin.y
        let width = recommendation.frame.width-20
        let height = buttonBar.frame.height
        self.buttonBar.frame = CGRect(x:x,y:y,width: width,height: height)
        recommendationController.alpha = 1
        exploreController.alpha = 0
        ownRecipeController.alpha = 0
    }
    
    
}


//struct GradientBackgroundStyle: ButtonStyle {
//
//       func makeBody(configuration: Self.Configuration) -> some View {
//           configuration.label
//               .frame(minWidth: 0, maxWidth: .infinity)
//               .padding()
//               .foregroundColor(.white)
//               .background(LinearGradient(gradient: Gradient(colors: [Color("DarkGreen"), Color("LightGreen")]), startPoint: .leading, endPoint: .trailing))
//               .cornerRadius(40)
//               .padding(.horizontal, 20)
//       }
//   }
