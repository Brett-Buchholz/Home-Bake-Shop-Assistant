//
//  RecipeTableViewCell.swift
//  Home Bake Shop Assistant
//
//  Created by Brett Buchholz on 1/19/24.
//

import UIKit
import SwipeCellKit

class RecipeTableViewCell: SwipeTableViewCell {
    
    @IBOutlet weak var recipeIngredientLabel: PaddingLabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        cellStyleStup()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func cellStyleStup() {
        recipeIngredientLabel.textColor = K.bakeShopMaroon
        
        //Style for different interface modes
        if K.interfaceMode == .pad {
            recipeIngredientLabel.font = UIFont(name: "Times New Roman", size: 26)
        } else {
            recipeIngredientLabel.font = UIFont(name: "Times New Roman", size: 18)
        }
    }
    
}
