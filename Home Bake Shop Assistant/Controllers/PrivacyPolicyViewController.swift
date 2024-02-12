//
//  PrivacyPolicyViewController.swift
//  Home Bake Shop Assistant
//
//  Created by Brett Buchholz on 2/9/24.
//

import UIKit

class PrivacyPolicyViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: PaddingLabel!
    @IBOutlet weak var policyLabel: PaddingLabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.clipsToBounds = true
        AddBorders().addAllBorders(with: K.bakeShopBlack, andWidth: 2.0, view: titleLabel)
        AddBorders().addAllBorders(with: K.bakeShopBlack, andWidth: 2.0, view: policyLabel)
    }
    
}
