//
//  OrderTableViewCell.swift
//  Home Bake Shop Assistant
//
//  Created by Brett Buchholz on 1/3/24.
//

import UIKit
import SwipeCellKit

class OrderTableViewCell: SwipeTableViewCell {
    
    @IBOutlet weak var qtyLabel: PaddingLabel!
    @IBOutlet weak var itemOrderedLabel: PaddingLabel!
    @IBOutlet weak var batchPriceLabel: PaddingLabel!
    @IBOutlet weak var subtotalLabel: PaddingLabel!
    @IBOutlet weak var itemNoteLabel: PaddingLabel!
    @IBOutlet weak var bottomStackView: UIStackView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        
    }
    
}
