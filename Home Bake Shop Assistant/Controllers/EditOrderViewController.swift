//
//  EditOrderViewController.swift
//  Home Bake Shop Assistant
//
//  Created by Brett Buchholz on 12/24/23.
//

import UIKit
import CoreData

class EditOrderViewController: UIViewController {
    
    
    @IBOutlet weak var topBackgroundView: UIView!
    
    @IBOutlet weak var companyNameLabel: PaddingLabel!
    @IBOutlet weak var companyAddressLabel: PaddingLabel!
    @IBOutlet weak var companyCityLabel: PaddingLabel!
    @IBOutlet weak var companyStateLabel: PaddingLabel!
    @IBOutlet weak var companyZipLabel: PaddingLabel!
    
    @IBOutlet weak var selectCustomerPopup: UIButton!
    @IBOutlet weak var customerAddressLabel: PaddingLabel!
    @IBOutlet weak var customerCityLabel: PaddingLabel!
    @IBOutlet weak var customerStateLabel: PaddingLabel!
    @IBOutlet weak var customerZipLabel: PaddingLabel!
    @IBOutlet weak var customerPhoneLabel: PaddingLabel!
    
    @IBOutlet weak var orderDatePicker: UIDatePicker!
    @IBOutlet weak var orderNumberTextField: UITextField!
    
    @IBOutlet weak var itemOrderdPopUp: UIButton!
    @IBOutlet weak var quantityOrderedPicker: UIPickerView!
    @IBOutlet weak var priceTextField: CurrencyField!
    @IBOutlet weak var addToOrderButton: BrettButton!
    
    @IBOutlet weak var orderTableView: UITableView!
    
    @IBOutlet weak var subTotalStackView: UIStackView!
    @IBOutlet weak var subTotalAmountLabel: PaddingLabel!
    @IBOutlet weak var salesTaxStackView: UIStackView!
    @IBOutlet weak var salesTaxAmountLabel: PaddingLabel!
    @IBOutlet weak var totalAmountLabel: PaddingLabel!
    
    @IBOutlet weak var saveOrderButton: BrettButton!
    
    
    var loadedCompany: [Company] = []
    var customerList: [Customer] = []
    var recipeList: [Recipe] = []
    var selectedCustomer: Customer? = nil
    var pickerValue: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        quantityOrderedPicker.delegate = self
        quantityOrderedPicker.dataSource = self
        
        orderTableView.layer.borderWidth = 2.0
        orderTableView.layer.borderColor = K.bakeShopBlueberry.cgColor
        
        topBackgroundView.layer.borderWidth = 2.0
        topBackgroundView.layer.borderColor = K.bakeShopBlueberry.cgColor
        loadCustomerList()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadCustomerList()
        loadTextFields()
        setupSelectCustomerButton()
        setupItemOrderedButton()
        
    }
    
    func loadTextFields() {
        loadCompanyInfo()
        if loadedCompany != [] {
            let comp = loadedCompany[0]
            companyNameLabel.text = comp.name
            companyAddressLabel.text = comp.address
            companyCityLabel.text = comp.city
            companyStateLabel.text = comp.state
            companyZipLabel.text = comp.zipCode
            if comp.withholdTax == true {
                subTotalStackView.isHidden = false
                salesTaxStackView.isHidden = false
                salesTaxAmountLabel.text = comp.taxRate
            } else {
                subTotalStackView.isHidden = true
                salesTaxStackView.isHidden = true
            }
        }
        self.customerAddressLabel.text = " "
        self.customerCityLabel.text = " "
        self.customerStateLabel.text = " "
        self.customerZipLabel.text = " "
        self.customerPhoneLabel.text = " "
    }
    
    func setupSelectCustomerButton() {
        var chirren: [UIMenuElement] = []
        chirren.append(UIAction(title: "", handler: { action in
            self.customerAddressLabel.text = " "
            self.customerCityLabel.text = " "
            self.customerStateLabel.text = " "
            self.customerZipLabel.text = " "
            self.customerPhoneLabel.text = " "
        }))
        for customer in customerList {
            let chirrenID = customer.customerID
            chirren.append(UIAction(title: "\(customer.lastName ?? "unknown name"), \(customer.firstName ?? "unknown name")", handler: { action in
                for customer in self.customerList {
                    let listName = "\(customer.customerID)"
                    if "\(chirrenID)" == listName {
                        self.selectedCustomer = customer
                    }
                }
                self.customerAddressLabel.text = self.selectedCustomer?.customerAddress
                self.customerCityLabel.text = self.selectedCustomer?.customerCity
                self.customerStateLabel.text = self.selectedCustomer?.customerState
                self.customerZipLabel.text = self.selectedCustomer?.customerZipCode
                self.customerPhoneLabel.text = self.selectedCustomer?.customerPhone
            }))
        }
        selectCustomerPopup.menu = UIMenu(children: chirren)
    }
    
    func setupItemOrderedButton() {
        loadRecipes()
        var chirren: [UIMenuElement] = []
        let closure = { (action: UIAction) in
            //print(action)
        }
        chirren.append(UIAction(title: "", handler: closure))
        for recipe in recipeList {
            chirren.append(UIAction(title: "\(recipe.name!)", handler: closure))
        }
        itemOrderdPopUp.menu = UIMenu(children: chirren)
        
    }
    
    @IBAction func companyInfoPressed(_ sender: BrettButton) {
    }
    
    @IBAction func addToOrderPressed(_ sender: BrettButton) {
    }
    
    @IBAction func saveOrderPressed(_ sender: BrettButton) {
    }
    
    //MARK: CoreData CRUD Methods
    
//    func saveRecipe() {
//        do {
//            try K.context.save()
//        } catch {
//            print("Error saving Ingredients: \(error)")
//        }
//    }
    
    func loadCompanyInfo() {
        let request: NSFetchRequest<Company> = Company.fetchRequest()
        do {
            loadedCompany = try K.companyInfoContext.fetch(request)
        } catch {
            print("Error loading Recipe: \(error)")
        }
    }
    
    func loadCustomerList() {
        let request: NSFetchRequest<Customer> = Customer.fetchRequest()
        let lastNameSort = NSSortDescriptor(key:"lastName", ascending:true)
        let firstNameSort = NSSortDescriptor(key:"firstName", ascending:true)
        request.sortDescriptors = [lastNameSort, firstNameSort]
        do {
            customerList = try K.customerInfoContext.fetch(request)
        } catch {
            print("Error loading Recipe: \(error)")
        }
    }
    
    func loadRecipes() {
        let request: NSFetchRequest<Recipe> = Recipe.fetchRequest()
        do {
            recipeList = try K.context.fetch(request)
        } catch {
            print("Error loading Recipe: \(error)")
        }
    }
    
//    func loadIngredients() {
//        let request: NSFetchRequest<Inventory> = Inventory.fetchRequest()
//        do {
//            inventoryList = try K.context.fetch(request)
//        } catch {
//            print("Error loading Ingredients: \(error)")
//        }
//    }
    
//    func updateData() {
//        DispatchQueue.main.async {
//            self.ingredientsTableView.reloadData()
//        }
//    }
    
    
    
    
}

//MARK: PickerView DataSource and Delegate Methods
extension EditOrderViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return K.orderQuantity.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return K.orderQuantity[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickerValue = K.orderQuantity[row]
    }
}

