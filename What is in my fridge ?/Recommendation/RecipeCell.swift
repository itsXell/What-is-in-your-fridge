//
//  RecipeCell.swift
//  What is in my fridge ?
//
//  Created by Xell on 25/4/2563 BE.
//  Copyright © 2563 Xell. All rights reserved.
//

import UIKit

class RecipeCell: UITableViewCell {
    @IBOutlet var img: UIImageView!
    @IBOutlet var name: UILabel!
    @IBOutlet var time: UILabel!
    @IBOutlet var calories: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
