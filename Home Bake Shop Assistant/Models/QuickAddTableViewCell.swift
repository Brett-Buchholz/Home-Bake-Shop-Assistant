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
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    
}
