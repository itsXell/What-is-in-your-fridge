//
//  IngredientViewCell.swift
//  What is in my fridge ?
//
//  Created by Xell on 19/5/2563 BE.
//  Copyright © 2563 Xell. All rights reserved.
//

import UIKit

class IngredientViewCell: UITableViewCell {
    
    @IBOutlet var imgView: UIImageView!
    @IBOutlet var ingredient: UILabel!
    @IBOutlet var amount: UILabel!
    @IBOutlet var expireDate: UILabel!


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
