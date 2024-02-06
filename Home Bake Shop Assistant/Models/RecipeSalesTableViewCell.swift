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
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        
    }
    
    
}
