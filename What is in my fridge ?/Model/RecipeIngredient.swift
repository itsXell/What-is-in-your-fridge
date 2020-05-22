//
//  RecipeIngredient.swift
//  What is in my fridge ?
//
//  Created by Xell on 21/5/2563 BE.
//  Copyright © 2563 Xell. All rights reserved.
//

import Foundation
import ObjectMapper

class RecipeIngredient: Mappable {
    var quantity:String! = ""
    var name:String! = ""
    var type:String! = ""
    
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        quantity <- map["quantity"]
        name <- map["name"]
        type <- map["type"]
    }
    

}
