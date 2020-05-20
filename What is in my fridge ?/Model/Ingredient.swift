//
//  Ingredient.swift
//  What is in my fridge ?
//
//  Created by Xell on 20/5/2563 BE.
//  Copyright © 2563 Xell. All rights reserved.
//

import Foundation

class Ingredient{
    var id:NSObject! = nil
    var name:String! = ""
    var type:String! = ""
    var amount:Double! = 0.0
    var expireDate:Date! = nil
    init(id:NSObject,name:String,type:String,amount:Double,expireDate:Date) {
        self.id = id
        self.name = name
        self.type = type
        self.amount = amount
        self.expireDate = expireDate
    }
    
}


