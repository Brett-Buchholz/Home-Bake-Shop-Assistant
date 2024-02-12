//
//  QuickAddTableViewCell.swift
//  Home Bake Shop Assistant
//
//  Created by Brett Buchholz on 1/29/24.
//

import UIKit
import SwipeCellKit

class QuickAddTableViewCell: SwipeTableViewCell {
    
    @IBOutlet weak var ingredientLabel: PaddingLabel!
    @IBOutlet weak var amountAddedLabel: PaddingLabel!
    @IBOutlet weak var costLabel: PaddingLabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        cellStyleStup()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    func cellStyleStup() {
        //General style of the cell
        ingredientLabel.textColor = K.bakeShopBlack
        amountAddedLabel.textColor = K.bakeShopBlack
        costLabel.textColor = K.bakeShopBlack
        
        //Style for different interface modes
        if K.interfaceMode == .phone {
            ingredientLabel.font =  UIFont(name: "Times New Roman", size: 18)
            amountAddedLabel.font =  UIFont(name: "Times New Roman", size: 18)
            costLabel.font =  UIFont(name: "Times New Roman", size: 18)
            
            amountAddedLabel.translatesAutoresizingMaskIntoConstraints = false
            let amountWidth = amountAddedLabel.widthAnchor.constraint(equalToConstant: 150)
            amountAddedLabel.addConstraint(amountWidth)
            
            costLabel.translatesAutoresizingMaskIntoConstraints = false
            let costWidth = costLabel.widthAnchor.constraint(equalToConstant: 90)
            costLabel.addConstraint(costWidth)
        } else {
            ingredientLabel.font =  UIFont(name: "Times New Roman", size: 32)
            amountAddedLabel.font =  UIFont(name: "Times New Roman", size: 32)
            costLabel.font =  UIFont(name: "Times New Roman", size: 32)
            
            amountAddedLabel.translatesAutoresizingMaskIntoConstraints = false
            let amountWidth = amountAddedLabel.widthAnchor.constraint(equalToConstant: 250)
            amountAddedLabel.addConstraint(amountWidth)
            
            costLabel.translatesAutoresizingMaskIntoConstraints = false
            let costWidth = costLabel.widthAnchor.constraint(equalToConstant: 150)
            costLabel.addConstraint(costWidth)
        }
    }
}
