//
//  IngredientTableViewCell.swift
//  Home Bake Shop Assistant
//
//  Created by Brett Buchholz on 11/8/23.
//

import UIKit
import SwipeCellKit

class IngredientTableViewCell: SwipeTableViewCell {

    @IBOutlet weak var ingredientLabel: PaddingLabel!
    @IBOutlet weak var unitsLabel: PaddingLabel!
    @IBOutlet weak var onHandLabel: PaddingLabel!
    @IBOutlet weak var neededLabel: PaddingLabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        cellStyleStup()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func cellStyleStup() {
        //General style of the cell
        ingredientLabel.textColor = K.bakeShopBlack
        unitsLabel.textColor = K.bakeShopBlack
        onHandLabel.textColor = K.bakeShopBlack
        neededLabel.textColor = K.bakeShopBlack
        
        //Style for different interface modes
        if K.interfaceMode == .phone {
            ingredientLabel.font =  UIFont(name: "Times New Roman", size: 16)
            unitsLabel.font =  UIFont(name: "Times New Roman", size: 16)
            onHandLabel.font =  UIFont(name: "Times New Roman", size: 16)
            neededLabel.font =  UIFont(name: "Times New Roman", size: 16)
            unitsLabel.translatesAutoresizingMaskIntoConstraints = false
            let unitsWidth = unitsLabel.widthAnchor.constraint(equalToConstant: 110)
            unitsLabel.addConstraint(unitsWidth)
            onHandLabel.translatesAutoresizingMaskIntoConstraints = false
            let onHandWidth = onHandLabel.widthAnchor.constraint(equalToConstant: 60)
            onHandLabel.addConstraint(onHandWidth)
            neededLabel.translatesAutoresizingMaskIntoConstraints = false
            let neededWidth = neededLabel.widthAnchor.constraint(equalToConstant: 60)
            neededLabel.addConstraint(neededWidth)
        } else {
            ingredientLabel.font =  UIFont(name: "Times New Roman", size: 28)
            unitsLabel.font =  UIFont(name: "Times New Roman", size: 28)
            onHandLabel.font =  UIFont(name: "Times New Roman", size: 28)
            neededLabel.font =  UIFont(name: "Times New Roman", size: 28)
            unitsLabel.translatesAutoresizingMaskIntoConstraints = false
            let unitsWidth = unitsLabel.widthAnchor.constraint(equalToConstant: 160)
            unitsLabel.addConstraint(unitsWidth)
            onHandLabel.translatesAutoresizingMaskIntoConstraints = false
            let onHandWidth = onHandLabel.widthAnchor.constraint(equalToConstant: 125)
            onHandLabel.addConstraint(onHandWidth)
            neededLabel.translatesAutoresizingMaskIntoConstraints = false
            let neededWidth = neededLabel.widthAnchor.constraint(equalToConstant: 125)
            neededLabel.addConstraint(neededWidth)
        }
    }
}
