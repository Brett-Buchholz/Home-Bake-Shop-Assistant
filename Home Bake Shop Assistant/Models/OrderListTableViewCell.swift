//
//  OrderListTableViewCell.swift
//  Home Bake Shop Assistant
//
//  Created by Brett Buchholz on 1/6/24.
//

import UIKit
import SwipeCellKit

class OrderListTableViewCell: SwipeTableViewCell {
    
    @IBOutlet weak var label1: PaddingLabel!
    @IBOutlet weak var label2: PaddingLabel!
    @IBOutlet weak var label3: PaddingLabel!
    @IBOutlet weak var label4: PaddingLabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        cellStyleStup()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    func cellStyleStup() {
        //General style of the cell
//        layer.borderWidth = 1
//        layer.borderColor = K.fontColorWhite.cgColor
//        backgroundColor = K.fontColor.withAlphaComponent(0.0)
//        dailyReminderCellLabel.highlightedTextColor = K.fontColor
        
        //Change the Background Color when selected
//        let backgroundView = UIView()
//        backgroundView.backgroundColor = K.fontColorWhite
//        selectedBackgroundView = backgroundView
        
        //Style for different interface modes
//        if K.interfaceMode == .phone {
//            dailyReminderCellLabel.font = UIFont(name: "Times New Roman", size: 20.0)
//        } else {
//            dailyReminderCellLabel.font = UIFont(name: "Times New Roman", size: 28.0)
//        }
    }
}
