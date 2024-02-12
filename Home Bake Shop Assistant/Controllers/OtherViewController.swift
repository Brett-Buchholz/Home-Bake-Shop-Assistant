//
//  OtherViewController.swift
//  Home Bake Shop Assistant
//
//  Created by Brett Buchholz on 2/7/24.
//

import UIKit

class OtherViewController: UIViewController {
    
    @IBOutlet weak var companyInfoButton: BrettButton!
    @IBOutlet weak var customersButton: BrettButton!
    @IBOutlet weak var unitsConverterButton: BrettButton!
    @IBOutlet weak var subscriptionButton: BrettButton!
    @IBOutlet weak var privacyPolicyButton: BrettButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        companyInfoButton.tintColor = K.systemBackground
        customersButton.tintColor = K.systemBackground
        unitsConverterButton.tintColor = K.systemBackground
        subscriptionButton.tintColor = K.systemBackground
        privacyPolicyButton.tintColor = K.systemBackground
    }
    
    
}
