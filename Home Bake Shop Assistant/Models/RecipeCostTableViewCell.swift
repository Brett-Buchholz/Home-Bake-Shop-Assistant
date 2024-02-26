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
            ingredientLabel.font =  UIFont(name: "Times New Roman", size: 18)
            costLabel.font =  UIFont(name: "Times New Roman", size: 18)
            
            costLabel.translatesAutoresizingMaskIntoConstraints = false
            let costWidth = costLabel.widthAnchor.constraint(equalToConstant: 100)
            costLabel.addConstraint(costWidth)
            
            costLabel.translatesAutoresizingMaskIntoConstraints = false
            let height = costLabel.heightAnchor.constraint(equalToConstant: 35)
            costLabel.addConstraint(height)
        } else {
            ingredientLabel.font =  UIFont(name: "Times New Roman", size: 30)
            costLabel.font =  UIFont(name: "Times New Roman", size: 30)
            
            costLabel.translatesAutoresizingMaskIntoConstraints = false
            let costWidth = costLabel.widthAnchor.constraint(equalToConstant: 150)
            costLabel.addConstraint(costWidth)
            
            costLabel.translatesAutoresizingMaskIntoConstraints = false
            let height = costLabel.heightAnchor.constraint(equalToConstant: 50)
            costLabel.addConstraint(height)
        }
    }
    
}
