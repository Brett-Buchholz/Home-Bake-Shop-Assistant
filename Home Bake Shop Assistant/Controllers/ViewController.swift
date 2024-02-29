//
//  ViewController.swift
//  Home Bake Shop Assistant
//
//  Created by Brett Buchholz on 10/31/23.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var recipesButton: BrettButton!
    @IBOutlet weak var inventoryButton: BrettButton!
    @IBOutlet weak var ordersButton: BrettButton!
    @IBOutlet weak var financesButton: BrettButton!
    @IBOutlet weak var otherButton: BrettButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createGettingStartedButton()
        recipesButton.tintColor = K.systemBackground
        inventoryButton.tintColor = K.systemBackground
        ordersButton.tintColor = K.systemBackground
        financesButton.tintColor = K.systemBackground
        otherButton.tintColor = K.systemBackground
    }
    
    func createGettingStartedButton() {
        let button = UIButton(type: .system)
        button.backgroundColor = K.systemBackground
        button.setTitle("Getting Started", for: .normal)
        if K.interfaceMode == .pad {
            button.frame = CGRectMake(100, 100, 150, 50)
            button.titleLabel?.font = UIFont(name: "Times New Roman", size: 22)
        } else {
            button.frame = CGRectMake(100, 100, 110, 35)
            button.titleLabel?.font = UIFont(name: "Times New Roman", size: 16)
        }
        button.setTitleColor(K.bakeShopPink, for: .normal)
        AddBorders().addAllBorders(with: K.bakeShopPink, andWidth: 2.0, view: button)
        button.layer.cornerRadius = 15
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        //button.addTarget(self, action: "Action:", forControlEvents: UIControlEvents.TouchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: button)
    }
    
    @objc func buttonAction(sender: UIButton!) {
        performSegue(withIdentifier: K.segueIdentifierToGettingStarted, sender: self)
    }
    
}

