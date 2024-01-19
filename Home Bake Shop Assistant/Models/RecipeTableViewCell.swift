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
        //General style of the cell
        recipeIngredientLabel.textColor = K.bakeShopMaroon
//        layer.borderWidth = 1
//        layer.borderColor = K.fontColorWhite.cgColor
//        backgroundColor = K.fontColor.withAlphaComponent(0.0)
//        dailyReminderCellLabel.highlightedTextColor = K.fontColor
        
        //Change the Background Color when selected
//        let backgroundView = UIView()
//        backgroundView.backgroundColor = K.fontColorWhite
//        selectedBackgroundView = backgroundView
        
        //Style for different interface modes
        if K.interfaceMode == .pad {
            recipeIngredientLabel.font = UIFont(name: "Times New Roman", size: 26)
        } else {
            recipeIngredientLabel.font = UIFont(name: "Times New Roman", size: 18)
        }
    }
    
}
