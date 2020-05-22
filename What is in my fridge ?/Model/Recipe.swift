//
//  Recipe.swift
//  What is in my fridge ?
//
//  Created by Xell on 21/5/2563 BE.
//  Copyright © 2563 Xell. All rights reserved.
//

import Foundation
import ObjectMapper

class Recipe: Mappable{
    var name:String? = ""
    var ingredient:[RecipeIngredient]! = []
    var step:[String]! = []
    var times:String! = ""
    var imageGalley:[String]! = []
    var credit:String! = ""
    
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        name <- map["name"]
        ingredient <- map["ingredients"]
        step <- map["steps"]
        times <- map["timers"]
        imageGalley <- map["imageGallery"]
        credit <- map["credit"]
    }
    
    
}
