//
//  CustomerTableViewCell.swift
//  Home Bake Shop Assistant
//
//  Created by Brett Buchholz on 1/19/24.
//

import UIKit

class CustomerTableViewCell: UITableViewCell {
    
    @IBOutlet weak var customerLabel: PaddingLabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cellStyleStup()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        
    }
    
    func cellStyleStup() {
        //General style of the cell
        customerLabel.textColor = K.bakeShopBlueberry
//        layer.borderWidth = 1
//        layer.borderColor = K.fontColorWhite.cgColor
//        backgroundColor = K.fontColor.withAlphaComponent(0.0)
//        dailyReminderCellLabel.highlightedTextColor = K.fontColor
        
        //Change the Background Color when selected
//        let backgroundView = UIView()
//        backgroundView.backgroundColor = K.fontColorWhite
//        selectedBackgroundView = backgroundView
        
        //Style for different interface modes
        if K.interfaceMode == .pad {
            customerLabel.font = UIFont(name: "Times New Roman", size: 32)
        } else {
            customerLabel.font = UIFont(name: "Times New Roman", size: 24)
        }
    }
}
