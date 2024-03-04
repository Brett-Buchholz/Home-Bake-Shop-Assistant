//
//  EditCustomerViewController.swift
//  Home Bake Shop Assistant
//
//  Created by Brett Buchholz on 12/28/23.
//

import UIKit
import CoreData

class EditCustomerViewController: UIViewController {
    
    @IBOutlet weak var customerInfoTitleLabel: PaddingLabel!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var stateTextField: UITextField!
    @IBOutlet weak var zipTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var errorLabel: PaddingLabel!
    @IBOutlet weak var saveInfoButton: BrettButton!
    @IBOutlet weak var deleteCustomerButton: BrettButton!
    
    @IBOutlet weak var firstNameStackView: UIStackView!
    @IBOutlet weak var lastNameStackView: UIStackView!
    @IBOutlet weak var addressStackView: UIStackView!
    @IBOutlet weak var cityStackView: UIStackView!
    @IBOutlet weak var stateStackView: UIStackView!
    @IBOutlet weak var zipStackView: UIStackView!
    @IBOutlet weak var phoneStackView: UIStackView!    
    
    var loadedCustomer: Customer? = nil
    var customerList: [Customer] = []
    var ordersList: [Order] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Style The View
        customerInfoTitleLabel.layer.masksToBounds = true
        AddBorders().addAllBorders(with: K.bakeShopBlueberry, andWidth: 2.0, view: customerInfoTitleLabel)
        AddBorders().addAllBorders(with: K.bakeShopBlueberry, andWidth: 2.0, view: firstNameStackView)
        AddBorders().addAllBorders(with: K.bakeShopBlueberry, andWidth: 2.0, view: lastNameStackView)
        AddBorders().addAllBorders(with: K.bakeShopBlueberry, andWidth: 2.0, view: addressStackView)
        AddBorders().addAllBorders(with: K.bakeShopBlueberry, andWidth: 2.0, view: cityStackView)
        AddBorders().addAllBorders(with: K.bakeShopBlueberry, andWidth: 2.0, view: stateStackView)
        AddBorders().addAllBorders(with: K.bakeShopBlueberry, andWidth: 2.0, view: zipStackView)
        AddBorders().addAllBorders(with: K.bakeShopBlueberry, andWidth: 2.0, view: phoneStackView)
        saveInfoButton.tintColor = K.bakeShopBlueberry
        deleteCustomerButton.tintColor = K.bakeShopDeleteRed
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.tintColor = .systemBackground
        errorLabel.isHidden = true
        if loadedCustomer != nil {
            firstNameTextField.text = loadedCustomer?.firstName
            lastNameTextField.text = loadedCustomer?.lastName
            addressTextField.text = loadedCustomer?.customerAddress
            cityTextField.text = loadedCustomer?.customerCity
            stateTextField.text = loadedCustomer?.customerState
            zipTextField.text = loadedCustomer?.customerZipCode
            phoneTextField.text = loadedCustomer?.customerPhone
            deleteCustomerButton.isHidden = false
        } else {
            deleteCustomerButton.isHidden = true
        }
        loadCustomers()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkAvailability()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.tintColor = .bakeShopBlack
    }
    
    func checkAvailability() {
        if AvailabilityManager().giveFullAccess() == false {
            let alert = UIAlertController(title: "", message: "Unsubscribed users are limited to 2 customers. Subscribed users have full access to all features.", preferredStyle: .alert)
            let action = UIAlertAction(title: "Dismiss", style: .default) { action in
                //Dismiss
            }
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        }
    }
    
    func createUniqueCustomerID() -> Int32 {
        loadCustomers()
        var idSet: Set<Int> = []
        var possibleID: Int
        var newID: Int32 = 0
        for customer in customerList {
            idSet.insert(Int(customer.customerID))
        }
        possibleID = Int.random(in: 10000000...19999999)
        while idSet.contains(possibleID) == true {
            possibleID = Int.random(in: 10000000...19999999)
        }
        newID = Int32(possibleID)

        return newID
    }
    
    @IBAction func saveInfoPressed(_ sender: BrettButton) {
        errorLabel.isHidden = true
        var customer: Customer? = nil
        if firstNameTextField.text == "" {
            errorLabel.isHidden = false
            errorLabel.text = "Please provide a first name"
        } else if lastNameTextField.text == "" {
            errorLabel.isHidden = false
            errorLabel.text = "Please provide a last name"
        } else if AvailabilityManager().giveFullAccess() == false && customerList.count >= 2 && loadedCustomer == nil {
            let alert = UIAlertController(title: "", message: "You cannot add a new customer. Unsubscribed users are limited to 2 customers. Subscribed users have full access to all features.", preferredStyle: .alert)
            let action = UIAlertAction(title: "Dismiss", style: .default) { action in
                //Dismiss
            }
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        } else if loadedCustomer != nil {
            customer = loadedCustomer!
        } else {
            customer = Customer(context: K.customerInfoContext)
            customer!.customerID = createUniqueCustomerID()
        }
        if customer != nil {
            customer!.firstName = firstNameTextField.text
            customer!.lastName = lastNameTextField.text
            customer!.customerAddress = addressTextField.text
            customer!.customerCity = cityTextField.text
            customer!.customerState = stateTextField.text
            customer!.customerZipCode = zipTextField.text
            customer!.customerPhone = phoneTextField.text
            saveCustomerInfo()
            navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func deleteCustomerPressed(_ sender: BrettButton) {
        loadOrders()
        var customerOrders:[Customer] = []
        for order in ordersList {
            if order.toCustomer == loadedCustomer {
                customerOrders.append(order.toCustomer!)
            }
        }
        if customerOrders != [] {
            let customerAlert = UIAlertController(title: "", message: "This customer is used in an existing order and cannot be deleted", preferredStyle: .alert)
            let dismissAction = UIAlertAction(title: "Dismiss", style: .default) { action in
                //alert is dismissed
            }
            customerAlert.addAction(dismissAction)
            present(customerAlert, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Delete Customer?", message: "Are you sure you want to delete this customer?", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: .default) { action in
                //alert is dismissed
            }
            alert.addAction(cancelAction)
            let deleteAction = UIAlertAction(title: "Delete", style: .default) { action in
                if self.loadedCustomer != nil {
                    K.customerInfoContext.delete(self.loadedCustomer!)
                    self.saveCustomerInfo()
                    self.navigationController?.popViewController(animated: true)
                }
            }
            alert.addAction(deleteAction)
            present(alert, animated: true, completion: nil)
        }
    }
    
    //MARK: CoreData CRUD Methods
    
    func saveCustomerInfo() {
        do {
            try K.customerInfoContext.save()
        } catch {
            print("Error saving Recipe: \(error)")
        }
    }
    
    func loadCustomers() {
        let request: NSFetchRequest<Customer> = Customer.fetchRequest()
        do {
            customerList = try K.customerInfoContext.fetch(request)
        } catch {
            print("Error loading Recipe: \(error)")
        }
    }
    
    func loadOrders() {
        let request: NSFetchRequest<Order> = Order.fetchRequest()
        let orderNumberSort = NSSortDescriptor(key:"orderNumber", ascending:true)
        request.sortDescriptors = [orderNumberSort]
        do {
            ordersList = try K.ordersContext.fetch(request)
        } catch {
            print("Error loading Ingredients: \(error)")
        }
    }
}
