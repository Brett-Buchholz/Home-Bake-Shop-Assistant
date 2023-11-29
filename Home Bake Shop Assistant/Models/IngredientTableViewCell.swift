//
//  IngredientTableViewCell.swift
//  Home Bake Shop Assistant
//
//  Created by Brett Buchholz on 11/8/23.
//

import UIKit
import SwipeCellKit

class IngredientTableViewCell: SwipeTableViewCell {

    @IBOutlet weak var ingredientCellView: UIView!
    @IBOutlet weak var ingredientCellLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
