//
//  RecipeDataTableViewCell.swift
//  Home Bake Shop Assistant
//
//  Created by Brett Buchholz on 2/3/24.
//

import UIKit

class RecipeSalesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var salesLabel: PaddingLabel!
    @IBOutlet weak var nameLabel: PaddingLabel!
    @IBOutlet weak var revenueLabel: PaddingLabel!
    @IBOutlet weak var cogsLabel: PaddingLabel!
    @IBOutlet weak var profitLabel: PaddingLabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        cellStyleStup()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        
    }
    
    func cellStyleStup() {
        //General style of the cell
        nameLabel.textColor = K.bakeShopChocolate
        salesLabel.textColor = K.bakeShopChocolate
        revenueLabel.textColor = K.bakeShopChocolate
        cogsLabel.textColor = K.bakeShopChocolate
        profitLabel.textColor = K.bakeShopChocolate
        
        //Style for different interface modes
        if K.interfaceMode == .phone {
            nameLabel.font = UIFont(name: "Times New Roman", size: 18)
            salesLabel.font = UIFont(name: "Times New Roman", size: 18)
            revenueLabel.font = UIFont(name: "Times New Roman", size: 18)
            cogsLabel.font = UIFont(name: "Times New Roman", size: 18)
            profitLabel.font = UIFont(name: "Times New Roman", size: 18)
            
            salesLabel.translatesAutoresizingMaskIntoConstraints = false
            let salesWidth = salesLabel.widthAnchor.constraint(equalToConstant: 35)
            salesLabel.addConstraint(salesWidth)
            
            revenueLabel.translatesAutoresizingMaskIntoConstraints = false
            let revenueWidth = revenueLabel.widthAnchor.constraint(equalToConstant: 60)
            revenueLabel.addConstraint(revenueWidth)
            
            cogsLabel.translatesAutoresizingMaskIntoConstraints = false
            let cogsWidth = cogsLabel.widthAnchor.constraint(equalToConstant: 60)
            cogsLabel.addConstraint(cogsWidth)
            
            profitLabel.translatesAutoresizingMaskIntoConstraints = false
            let profitWidth = profitLabel.widthAnchor.constraint(equalToConstant: 60)
            profitLabel.addConstraint(profitWidth)
        } else {
            nameLabel.font = UIFont(name: "Times New Roman", size: 26)
            salesLabel.font = UIFont(name: "Times New Roman", size: 26)
            revenueLabel.font = UIFont(name: "Times New Roman", size: 26)
            cogsLabel.font = UIFont(name: "Times New Roman", size: 26)
            profitLabel.font = UIFont(name: "Times New Roman", size: 26)
            
            salesLabel.translatesAutoresizingMaskIntoConstraints = false
            let salesWidth = salesLabel.widthAnchor.constraint(equalToConstant: 75)
            salesLabel.addConstraint(salesWidth)
            
            revenueLabel.translatesAutoresizingMaskIntoConstraints = false
            let revenueWidth = revenueLabel.widthAnchor.constraint(equalToConstant: 125)
            revenueLabel.addConstraint(revenueWidth)
            
            cogsLabel.translatesAutoresizingMaskIntoConstraints = false
            let cogsWidth = cogsLabel.widthAnchor.constraint(equalToConstant: 125)
            cogsLabel.addConstraint(cogsWidth)
            
            profitLabel.translatesAutoresizingMaskIntoConstraints = false
            let profitWidth = profitLabel.widthAnchor.constraint(equalToConstant: 125)
            profitLabel.addConstraint(profitWidth)
        }
    }
}
