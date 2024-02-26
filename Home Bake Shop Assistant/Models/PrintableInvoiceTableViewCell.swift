//
//  PrintableInvoiceTableViewCell.swift
//  Home Bake Shop Assistant
//
//  Created by Brett Buchholz on 2/22/24.
//

import UIKit

class PrintableInvoiceTableViewCell: UITableViewCell {

    @IBOutlet weak var qtyLabel: PaddingLabel!
    @IBOutlet weak var itemOrderedLabel: PaddingLabel!
    @IBOutlet weak var batchPriceLabel: PaddingLabel!
    @IBOutlet weak var subtotalLabel: PaddingLabel!
    @IBOutlet weak var itemNoteLabel: PaddingLabel!
    @IBOutlet weak var topStackView: UIStackView!
    @IBOutlet weak var bottomStackView: UIStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        cellStyleStup()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    func cellStyleStup() {
        //General style of the cell
        qtyLabel.textColor = K.bakeShopBlueberry
        itemOrderedLabel.textColor = K.bakeShopBlueberry
        batchPriceLabel.textColor = K.bakeShopBlueberry
        subtotalLabel.textColor = K.bakeShopBlueberry
        itemNoteLabel.textColor = K.bakeShopBlueberry
        
        
        qtyLabel.font           =  UIFont(name: "Times New Roman", size: 32)
        itemOrderedLabel.font   =  UIFont(name: "Times New Roman", size: 32)
        batchPriceLabel.font    =  UIFont(name: "Times New Roman", size: 32)
        subtotalLabel.font      =  UIFont(name: "Times New Roman", size: 32)
        itemNoteLabel.font      =  UIFont(name: "Times New Roman", size: 32)
        
        qtyLabel.translatesAutoresizingMaskIntoConstraints = false
        let qtyWidth = qtyLabel.widthAnchor.constraint(equalToConstant: 70)
        qtyLabel.addConstraint(qtyWidth)
        
        batchPriceLabel.translatesAutoresizingMaskIntoConstraints = false
        let priceWidth = batchPriceLabel.widthAnchor.constraint(equalToConstant: 125)
        batchPriceLabel.addConstraint(priceWidth)
        
        subtotalLabel.translatesAutoresizingMaskIntoConstraints = false
        let subtotalWidth = subtotalLabel.widthAnchor.constraint(equalToConstant: 125)
        subtotalLabel.addConstraint(subtotalWidth)
        
        topStackView.translatesAutoresizingMaskIntoConstraints = false
        let topHeight = topStackView.heightAnchor.constraint(equalToConstant: 45)
        topStackView.addConstraint(topHeight)
        
        bottomStackView.translatesAutoresizingMaskIntoConstraints = false
        let bottomHeight = bottomStackView.heightAnchor.constraint(equalToConstant: 45)
        bottomStackView.addConstraint(bottomHeight)
        
    }
}
