//
//  CookbookTableViewCell.swift
//  Home Bake Shop Assistant
//
//  Created by Brett Buchholz on 1/19/24.
//

import UIKit

class CookbookTableViewCell: UITableViewCell {

    @IBOutlet weak var cookbookLabel: PaddingLabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        cellStyleStup()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    func cellStyleStup() {
        //General style of the cell
        cookbookLabel.textColor = K.bakeShopMaroon
        
        //Style for different interface modes
        if K.interfaceMode == .pad {
            cookbookLabel.font = UIFont(name: "Times New Roman", size: 32)
        } else {
            cookbookLabel.font = UIFont(name: "Times New Roman", size: 22)
        }
    }
    
}
