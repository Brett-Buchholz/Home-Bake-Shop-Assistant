//
//  RecipeCostTableViewCell.swift
//  Home Bake Shop Assistant
//
//  Created by Brett Buchholz on 2/5/24.
//

import UIKit

class RecipeCostTableViewCell: UITableViewCell {
    
    @IBOutlet weak var ingredientLabel: PaddingLabel!
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
        ingredientLabel.textColor = K.bakeShopChocolate
        costLabel.textColor = K.bakeShopChocolate
        
        //Style for different interface modes
        if K.interfaceMode == .phone {
            ingredientLabel.font =  UIFont(name: "Times New Roman", size: 22)
            costLabel.font =  UIFont(name: "Times New Roman", size: 22)
        } else {
            ingredientLabel.font =  UIFont(name: "Times New Roman", size: 30)
            costLabel.font =  UIFont(name: "Times New Roman", size: 30)
        }
    }
    
}
