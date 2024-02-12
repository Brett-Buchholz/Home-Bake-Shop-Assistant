//
//  GettingStartedViewController.swift
//  Home Bake Shop Assistant
//
//  Created by Brett Buchholz on 2/9/24.
//

import UIKit

class GettingStartedViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: PaddingLabel!
    @IBOutlet weak var step1Label: PaddingLabel!
    @IBOutlet weak var step1DetailsLabel: PaddingLabel!
    @IBOutlet weak var step2Label: PaddingLabel!
    @IBOutlet weak var step2DetailsLabel: PaddingLabel!
    @IBOutlet weak var step3Label: PaddingLabel!
    @IBOutlet weak var step3DetailsLabel: PaddingLabel!
    @IBOutlet weak var step4Label: PaddingLabel!
    @IBOutlet weak var step4DetailsLabel: PaddingLabel!
    @IBOutlet weak var step5Label: PaddingLabel!
    @IBOutlet weak var step5DetailsLabel: PaddingLabel!
    
    @IBOutlet weak var companyInfoButton: BrettButton!
    @IBOutlet weak var inventoryButton: BrettButton!
    @IBOutlet weak var recipesButton: BrettButton!
    @IBOutlet weak var customersButton: BrettButton!
    @IBOutlet weak var ordersButton: BrettButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Style the view
        titleLabel.clipsToBounds = true
        step1Label.clipsToBounds = true
        step2Label.clipsToBounds = true
        step3Label.clipsToBounds = true
        step4Label.clipsToBounds = true
        step5Label.clipsToBounds = true
        AddBorders().addAllBorders(with: K.bakeShopPink, andWidth: 2.0, view: titleLabel)
        AddBorders().addAllBorders(with: K.bakeShopPink, andWidth: 2.0, view: step1Label)
        AddBorders().addAllBorders(with: K.bakeShopPink, andWidth: 2.0, view: step1DetailsLabel)
        AddBorders().addAllBorders(with: K.bakeShopPink, andWidth: 2.0, view: step2Label)
        AddBorders().addAllBorders(with: K.bakeShopPink, andWidth: 2.0, view: step2DetailsLabel)
        AddBorders().addAllBorders(with: K.bakeShopPink, andWidth: 2.0, view: step3Label)
        AddBorders().addAllBorders(with: K.bakeShopPink, andWidth: 2.0, view: step3DetailsLabel)
        AddBorders().addAllBorders(with: K.bakeShopPink, andWidth: 2.0, view: step4Label)
        AddBorders().addAllBorders(with: K.bakeShopPink, andWidth: 2.0, view: step4DetailsLabel)
        AddBorders().addAllBorders(with: K.bakeShopPink, andWidth: 2.0, view: step5Label)
        AddBorders().addAllBorders(with: K.bakeShopPink, andWidth: 2.0, view: step5DetailsLabel)
        companyInfoButton.tintColor = K.bakeShopPink
        inventoryButton.tintColor = K.bakeShopPink
        recipesButton.tintColor = K.bakeShopPink
        customersButton.tintColor = K.bakeShopPink
        ordersButton.tintColor = K.bakeShopPink
    }
    
    
}
