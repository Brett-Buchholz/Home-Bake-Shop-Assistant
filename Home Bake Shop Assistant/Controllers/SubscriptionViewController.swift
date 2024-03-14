//
//  SubscriptionViewController.swift
//  Home Bake Shop Assistant
//
//  Created by Brett Buchholz on 2/9/24.
//

import UIKit
import StoreKit
import CoreData

class SubscriptionViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: PaddingLabel!
    @IBOutlet weak var promoStackView: UIStackView!
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
        restoreButton.tintColor = K.bakeShopChocolate
        setupSubscribeButton()
        createTOSButton()
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
        var subscriptionPrice = ""
        if K.skm.subscriptions == [] {
            subscriptionPrice = "$19.99"
        } else {
            subscriptionPrice = K.skm.subscriptions[0].displayPrice
        }
        let title = "Subscribe\n(\(subscriptionPrice) Annually)"
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
    
    func createTOSButton() {
        let button = UIButton(type: .system)
        button.backgroundColor = K.systemBackground
        button.setTitle("Terms of Service", for: .normal)
        if K.interfaceMode == .pad {
            button.frame = CGRectMake(100, 100, 165, 50)
            button.titleLabel?.font = UIFont(name: "Times New Roman", size: 22)
        } else {
            button.frame = CGRectMake(100, 100, 90, 35)
            button.titleLabel?.font = UIFont(name: "Times New Roman", size: 12)
        }
        button.setTitleColor(K.bakeShopChocolate, for: .normal)
        AddBorders().addAllBorders(with: K.bakeShopChocolate, andWidth: 2.0, view: button)
        button.layer.cornerRadius = 15
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        //button.addTarget(self, action: "Action:", forControlEvents: UIControlEvents.TouchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
    }
    
    func restore() async -> Bool {
        return ((try? await AppStore.sync()) != nil)
    }
    
    func setSubscriptionInfo() {
        if K.skm.subscriptions == [] {
            statusLabel.text = "Could not retrieve subscription information"
            dateStackView.isHidden = true
        } else {
            let product = K.skm.subscriptions[0]
            Task {
                await K.skm.getSubscriptionStatus(product: product)
                dateStackView.isHidden = true
                
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
    }
    
    @objc func buttonAction(sender: UIButton!) {
        if let url = URL(string: "https://www.apple.com/legal/internet-services/itunes/dev/stdeula/") {
          UIApplication.shared.open(url)
        } else {
          print("url is not correct")
        }
    }
    
    @IBAction func subscribeButtonPressed(_ sender: BrettButton) {
        if K.skm.subscriptions == [] {
            print("Could not retrieve subscriptions")
        } else {
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
