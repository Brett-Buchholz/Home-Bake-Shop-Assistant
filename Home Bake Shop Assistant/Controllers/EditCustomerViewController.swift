//
//  EditCustomerViewController.swift
//  Home Bake Shop Assistant
//
//  Created by Brett Buchholz on 12/28/23.
//

import UIKit

class EditCustomerViewController: UIViewController {
    
    @IBOutlet weak var customerTitleLabel: PaddingLabel!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customerTitleLabel.layer.masksToBounds = true
        customerTitleLabel.layer.borderColor = K.bakeShopBlueberry.cgColor
        customerTitleLabel.layer.borderWidth = 2.0
    }
    
    
    
}
