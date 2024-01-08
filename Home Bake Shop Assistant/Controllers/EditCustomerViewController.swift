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
    @IBOutlet weak var saveInfoButton: BrettButton!
    @IBOutlet weak var deleteCustomerButton: BrettButton!
    
    var loadedCustomer: Customer? = nil
    var customerList: [Customer] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Style The View
        //Register delegates, data sources and Nibs
        
        customerInfoTitleLabel.layer.masksToBounds = true
        customerInfoTitleLabel.layer.borderColor = K.bakeShopBlueberry.cgColor
        customerInfoTitleLabel.layer.borderWidth = 2.0
        saveInfoButton.tintColor = K.bakeShopBlueberry
        deleteCustomerButton.tintColor = K.bakeShopDeleteRed
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.tintColor = .systemBackground
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
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.tintColor = .bakeShopBlack
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
        let customer: Customer
        if loadedCustomer != nil {
            customer = loadedCustomer!
        } else {
            customer = Customer(context: K.customerInfoContext)
            customer.customerID = createUniqueCustomerID()
        }
        customer.firstName = firstNameTextField.text
        customer.lastName = lastNameTextField.text
        customer.customerAddress = addressTextField.text
        customer.customerCity = cityTextField.text
        customer.customerState = stateTextField.text
        customer.customerZipCode = zipTextField.text
        customer.customerPhone = phoneTextField.text
        saveCustomerInfo()
        navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func deleteCustomerPressed(_ sender: BrettButton) {
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
    
}
