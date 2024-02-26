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
    @IBOutlet weak var stackView: UIStackView!
    
    
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
            ingredientLabel.font =  UIFont(name: "Times New Roman", size: 16)
            amountUsedLabel.font =  UIFont(name: "Times New Roman", size: 16)
            unitCostLabel.font =  UIFont(name: "Times New Roman", size: 16)
            totalCostLabel.font =  UIFont(name: "Times New Roman", size: 16)
            
            amountUsedLabel.translatesAutoresizingMaskIntoConstraints = false
            let amountWidth = amountUsedLabel.widthAnchor.constraint(equalToConstant: 100)
            amountUsedLabel.addConstraint(amountWidth)
            
            unitCostLabel.translatesAutoresizingMaskIntoConstraints = false
            let unitWidth = unitCostLabel.widthAnchor.constraint(equalToConstant: 60)
            unitCostLabel.addConstraint(unitWidth)
            
            totalCostLabel.translatesAutoresizingMaskIntoConstraints = false
            let totalWidth = totalCostLabel.widthAnchor.constraint(equalToConstant: 70)
            totalCostLabel.addConstraint(totalWidth)
            
            stackView.translatesAutoresizingMaskIntoConstraints = false
            let height = stackView.heightAnchor.constraint(equalToConstant: 40)
            stackView.addConstraint(height)

        } else {
            ingredientLabel.font =  UIFont(name: "Times New Roman", size: 30)
            amountUsedLabel.font =  UIFont(name: "Times New Roman", size: 30)
            unitCostLabel.font =  UIFont(name: "Times New Roman", size: 30)
            totalCostLabel.font =  UIFont(name: "Times New Roman", size: 30)
            
            amountUsedLabel.translatesAutoresizingMaskIntoConstraints = false
            let amountWidth = amountUsedLabel.widthAnchor.constraint(equalToConstant: 200)
            amountUsedLabel.addConstraint(amountWidth)
            
            unitCostLabel.translatesAutoresizingMaskIntoConstraints = false
            let unitWidth = unitCostLabel.widthAnchor.constraint(equalToConstant: 100)
            unitCostLabel.addConstraint(unitWidth)
            
            totalCostLabel.translatesAutoresizingMaskIntoConstraints = false
            let totalWidth = totalCostLabel.widthAnchor.constraint(equalToConstant: 150)
            totalCostLabel.addConstraint(totalWidth)
            
            stackView.translatesAutoresizingMaskIntoConstraints = false
            let height = stackView.heightAnchor.constraint(equalToConstant: 50)
            stackView.addConstraint(height)
        }
    }
    
}
