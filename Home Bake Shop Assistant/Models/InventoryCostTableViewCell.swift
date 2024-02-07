//
//  InventoryCostTableViewCell.swift
//  Home Bake Shop Assistant
//
//  Created by Brett Buchholz on 2/6/24.
//

import UIKit

class InventoryCostTableViewCell: UITableViewCell {
    
    @IBOutlet weak var ingredientLabel: PaddingLabel!
    @IBOutlet weak var amountUsedLabel: PaddingLabel!
    @IBOutlet weak var unitCostLabel: PaddingLabel!
    @IBOutlet weak var totalCostLabel: PaddingLabel!
    
    
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
        amountUsedLabel.textColor = K.bakeShopChocolate
        unitCostLabel.textColor = K.bakeShopChocolate
        totalCostLabel.textColor = K.bakeShopChocolate
        
        //Style for different interface modes
        if K.interfaceMode == .phone {
            ingredientLabel.font =  UIFont(name: "Times New Roman", size: 22)
            amountUsedLabel.font =  UIFont(name: "Times New Roman", size: 22)
            unitCostLabel.font =  UIFont(name: "Times New Roman", size: 22)
            totalCostLabel.font =  UIFont(name: "Times New Roman", size: 22)
        } else {
            ingredientLabel.font =  UIFont(name: "Times New Roman", size: 30)
            amountUsedLabel.font =  UIFont(name: "Times New Roman", size: 30)
            unitCostLabel.font =  UIFont(name: "Times New Roman", size: 30)
            totalCostLabel.font =  UIFont(name: "Times New Roman", size: 30)
        }
    }
    
}
