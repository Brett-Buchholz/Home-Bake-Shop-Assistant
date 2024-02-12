//
//  SubscriptionViewController.swift
//  Home Bake Shop Assistant
//
//  Created by Brett Buchholz on 2/9/24.
//

import UIKit

class SubscriptionViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: PaddingLabel!
    @IBOutlet weak var promoStackView: UIStackView!
    @IBOutlet weak var promoCodeTextField: UITextField!
    @IBOutlet weak var applyCodeButton: BrettButton!
    @IBOutlet weak var subscribeButton: BrettButton!
    @IBOutlet weak var restoreButton: BrettButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Style the view
        titleLabel.clipsToBounds = true
        AddBorders().addAllBorders(with: K.bakeShopChocolate, andWidth: 2.0, view: titleLabel)
        AddBorders().addAllBorders(with: K.bakeShopChocolate, andWidth: 2.0, view: promoStackView)
        applyCodeButton.tintColor = K.bakeShopChocolate
        restoreButton.tintColor = K.bakeShopChocolate
        setupSubscribeButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.tintColor = .systemBackground
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.navigationBar.tintColor = .bakeShopBlack
    }
    
    func setupSubscribeButton() {
        let title = "Subscribe\n($19.99 Annually)"
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .center
        let myAttributes = [ NSAttributedString.Key.foregroundColor: K.systemBackground,
                             NSAttributedString.Key.font: K.fontTNR32,
                             NSAttributedString.Key.paragraphStyle: paragraph
        ]
        let attributedString = NSAttributedString(string: title, attributes: myAttributes as [NSAttributedString.Key : Any])
        subscribeButton.setAttributedTitle(attributedString, for: .normal)
        subscribeButton.tintColor = K.bakeShopChocolate
    }
    
    @IBAction func applyCodePressed(_ sender: BrettButton) {
    }
    
    @IBAction func subscribeButtonPressed(_ sender: BrettButton) {
    }
    
    @IBAction func restoreButtonPressed(_ sender: BrettButton) {
    }
    
}
