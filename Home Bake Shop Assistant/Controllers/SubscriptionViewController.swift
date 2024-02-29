//
//  SubscriptionViewController.swift
//  Home Bake Shop Assistant
//
//  Created by Brett Buchholz on 2/9/24.
//

import UIKit
import StoreKit

class SubscriptionViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: PaddingLabel!
    @IBOutlet weak var promoStackView: UIStackView!
    @IBOutlet weak var promoCodeTextField: UITextField!
    @IBOutlet weak var applyCodeButton: BrettButton!
    @IBOutlet weak var subscribeButton: BrettButton!
    @IBOutlet weak var restoreButton: BrettButton!
    @IBOutlet weak var subscriptionStackView: UIStackView!
    @IBOutlet weak var dateStackView: UIStackView!
    @IBOutlet weak var statusLabel: PaddingLabel!
    @IBOutlet weak var renewLabel: PaddingLabel!
    @IBOutlet weak var dateLabel: PaddingLabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Style the view
        titleLabel.clipsToBounds = true
        AddBorders().addAllBorders(with: K.bakeShopChocolate, andWidth: 2.0, view: titleLabel)
        AddBorders().addAllBorders(with: K.bakeShopChocolate, andWidth: 2.0, view: promoStackView)
        AddBorders().addAllBorders(with: K.bakeShopChocolate, andWidth: 2.0, view: subscriptionStackView)
        //AddBorders().addRightBorder(with: K.bakeShopChocolate, andWidth: 2.0, view: subscriptionStackView)
        //AddBorders().addTopBorder(with: K.bakeShopChocolate, andWidth: 2.0, view: subscriptionStackView)
        applyCodeButton.tintColor = K.bakeShopChocolate
        restoreButton.tintColor = K.bakeShopChocolate
        setupSubscribeButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.tintColor = .systemBackground
        setSubscriptionInfo()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.navigationBar.tintColor = .bakeShopBlack
    }
    
    func setupSubscribeButton() {
        let title = "Subscribe\n($19.99 Annually)"
        var font: UIFont = K.fontTNR32!
        if K.interfaceMode == .phone {
            font = K.fontTNR18!
        }
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .center
        let myAttributes = [ NSAttributedString.Key.foregroundColor: K.systemBackground,
                             NSAttributedString.Key.font: font,
                             NSAttributedString.Key.paragraphStyle: paragraph
        ]
        let attributedString = NSAttributedString(string: title, attributes: myAttributes as [NSAttributedString.Key : Any])
        subscribeButton.setAttributedTitle(attributedString, for: .normal)
        subscribeButton.tintColor = K.bakeShopChocolate
    }
    
    func restore() async -> Bool {
        return ((try? await AppStore.sync()) != nil)
    }
    
    func setSubscriptionInfo() {
        dateStackView.isHidden = true
        Task {
            let product = K.skm.subscriptions[0]
            await K.skm.getSubscriptionStatus(product: product)
            statusLabel.text = K.skm.subscriptionGroupStatus?.localizedDescription ?? "Not subscribed"
            
            if K.skm.subscriptionGroupStatus == .subscribed {
                dateStackView.isHidden = false
                let date = K.skm.subscriptionGroupInfo?.renewalDate
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MM-dd-yyyy"
                let stringDate = dateFormatter.string(from: date!)
                dateLabel.text = stringDate
                if K.skm.subscriptionGroupInfo?.willAutoRenew == true {
                    renewLabel.text = "Will renew on: "
                } else {
                    renewLabel.text = "Will expire on: "
                }
            }
        }
    }
    
    @IBAction func applyCodePressed(_ sender: BrettButton) {
    }
    
    @IBAction func subscribeButtonPressed(_ sender: BrettButton) {
        let product = K.skm.subscriptions[0]
        if AppStore.canMakePayments == true {
            Task {
                try? await K.skm.purchase(product)
                setSubscriptionInfo()
            }
        } else {
            print("User can't make payment")
        }
    }
    
    @IBAction func restoreButtonPressed(_ sender: BrettButton) {
        Task {
            if await restore() == true {
                let alert = UIAlertController(title: "", message: "Your purchase was successfully restored", preferredStyle: .alert)
                let action = UIAlertAction(title: "Dismiss", style: .default) { action in
                    //Dismisses
                }
                alert.addAction(action)
                present(alert, animated: true, completion: nil)
            }
        }
    }
    
}
