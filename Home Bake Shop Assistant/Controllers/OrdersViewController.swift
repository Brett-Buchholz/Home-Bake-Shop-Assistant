//
//  OrdersViewController.swift
//  Home Bake Shop Assistant
//
//  Created by Brett Buchholz on 12/23/23.
//

import UIKit

class OrdersViewController: UIViewController {
    
    @IBOutlet weak var orderSegmentedControl: UISegmentedControl!
    @IBOutlet weak var controlView: UIView!
    @IBOutlet weak var orderTableView: UITableView!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        orderTableView.layer.borderWidth = 2.0
        orderTableView.layer.borderColor = K.bakeShopBlueberry.cgColor
        orderSegmentedControl.setTitleTextAttributes([ NSAttributedString.Key.font: UIFont(name: "Times New Roman Bold", size: 30.0)!, NSAttributedString.Key.foregroundColor: K.bakeShopBlueberry], for: .normal)
        controlView.layer.borderWidth = 2.0
        controlView.layer.borderColor = K.bakeShopBlueberry.cgColor
    }
    
    
    
}
