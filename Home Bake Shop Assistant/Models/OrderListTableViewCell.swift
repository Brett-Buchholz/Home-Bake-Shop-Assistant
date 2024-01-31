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
        label1.textColor = K.bakeShopBlueberry
        label2.textColor = K.bakeShopBlueberry
        label3.textColor = K.bakeShopBlueberry
        label4.textColor = K.bakeShopBlueberry
        
        //Style for different interface modes
        if K.interfaceMode == .phone {
            label1.font =  UIFont(name: "Times New Roman", size: 22)
            label2.font =  UIFont(name: "Times New Roman", size: 22)
            label3.font =  UIFont(name: "Times New Roman", size: 22)
            label4.font =  UIFont(name: "Times New Roman", size: 22)
        } else {
            label1.font =  UIFont(name: "Times New Roman", size: 30)
            label2.font =  UIFont(name: "Times New Roman", size: 30)
            label3.font =  UIFont(name: "Times New Roman", size: 30)
            label4.font =  UIFont(name: "Times New Roman", size: 30)
        }
    }
}
