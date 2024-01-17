//
//  EditOrderViewController.swift
//  Home Bake Shop Assistant
//
//  Created by Brett Buchholz on 12/24/23.
//

import UIKit
import CoreData
import SwipeCellKit

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
    @IBOutlet weak var itemNoteTextField: UITextField!
    @IBOutlet weak var priceTextField: CurrencyField!
    @IBOutlet weak var addToOrderButton: BrettButton!
    @IBOutlet weak var errorLabel: PaddingLabel!
    
    @IBOutlet weak var orderTableView: UITableView!
    
    @IBOutlet weak var subTotalStackView: UIStackView!
    @IBOutlet weak var subTotalAmountLabel: PaddingLabel!
    @IBOutlet weak var salesTaxStackView: UIStackView!
    @IBOutlet weak var salesTaxLabel: PaddingLabel!
    @IBOutlet weak var salesTaxAmountLabel: PaddingLabel!
    @IBOutlet weak var totalAmountLabel: PaddingLabel!
    
    @IBOutlet weak var quantityTextField: UITextField!
    @IBOutlet weak var batchSizeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var otherTextField: UITextField!
    @IBOutlet weak var saveOrderButton: BrettButton!
    @IBOutlet weak var headerStackView: UIStackView!
    
    var loadedCompany: [Company] = []
    var customerList: [Customer] = []
    var ordersList: [Order] = []
    var recipeList: [Recipe] = []
    var selectedCustomer: Customer? = nil
    var pickerValue: String = ""
    var batchSize: Int16 = 12
    var tempItemsOrdered: [[String:Any]] = []
    var selectedIndexPath: IndexPath? = nil
    var segueOrder: Order? = nil
    var segueVC: OrderViewController? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Style The View
        AddBorders().addAllBorders(with: K.bakeShopBlueberry, andWidth: 2.0, view: orderTableView)
        AddBorders().addAllBorders(with: K.bakeShopBlueberry, andWidth: 2.0, view: topBackgroundView)
        AddBorders().addTopBorder(with: K.bakeShopBlueberry, andWidth: 2.0, view: headerStackView)
        AddBorders().addLeftBorder(with: K.bakeShopBlueberry, andWidth: 2.0, view: headerStackView)
        AddBorders().addRightBorder(with: K.bakeShopBlueberry, andWidth: 2.0, view: headerStackView)
        addToOrderButton.tintColor = K.bakeShopBlueberry
        saveOrderButton.tintColor = K.bakeShopBlueberry
        
        //Register delegates, data sources and Nibs
        orderTableView.dataSource = self
        orderTableView.delegate = self
        orderTableView.register(UINib(nibName: K.orderCellNibName, bundle: nil), forCellReuseIdentifier: K.orderReuseIdentifier)
        
        loadCustomerList()
        createOrderNumber()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        otherTextField.isHidden = true
        self.customerAddressLabel.text = " "
        self.customerCityLabel.text = " "
        self.customerStateLabel.text = " "
        self.customerZipLabel.text = " "
        self.customerPhoneLabel.text = " "
        loadCustomerList()
        setupSelectCustomerButton()
        setupItemOrderedButton()
        loadTextFields()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.segueIdentifierToCompanyInfo {
            let destinationVC = segue.destination as! CompanyInfoViewController
            let originVC = segue.source as! EditOrderViewController
            destinationVC.originVC = originVC
        }
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
                salesTaxLabel.text = "Sales Tax (\(comp.taxRate)%):"
            } else {
                subTotalStackView.isHidden = true
                salesTaxStackView.isHidden = true
            }
        }
        if segueOrder != nil {
            selectedCustomer = segueOrder?.toCustomer
            selectCustomerPopup.changesSelectionAsPrimaryAction = true
            loadSelectCustomerButton()
            self.customerAddressLabel.text = self.selectedCustomer?.customerAddress
            self.customerCityLabel.text = self.selectedCustomer?.customerCity
            self.customerStateLabel.text = self.selectedCustomer?.customerState
            self.customerZipLabel.text = self.selectedCustomer?.customerZipCode
            self.customerPhoneLabel.text = self.selectedCustomer?.customerPhone
            orderDatePicker.date = (segueOrder?.orderDate)!
            orderNumberTextField.text = segueOrder?.orderNumber
            let itemsOrdered = segueOrder?.toOrderedItem?.allObjects as! [OrderedItem]
            var itemDict: Dictionary = [String:Any]()
            for item in itemsOrdered {
                itemDict["ItemOrdered"] = item.toRecipe
                itemDict["ItemNotes"] = item.itemNote
                itemDict["Quantity"] = item.quantityOrdered
                itemDict["BatchName"] = item.batchName
                itemDict["BatchSize"] = item.batchSize
                itemDict["BatchPrice"] = item.batchPrice
                itemDict["BatchSubtotal"] = item.batchSubtotal
                tempItemsOrdered.append(itemDict)
            }
            self.subTotalAmountLabel.text = UnitsConverter().convertCurrencyFloatToString(floatCurrency: self.getSubtotal())
            self.salesTaxAmountLabel.text = UnitsConverter().convertCurrencyFloatToString(floatCurrency: self.getSalesTax())
            self.totalAmountLabel.text = UnitsConverter().convertCurrencyFloatToString(floatCurrency: self.getTotal())
        }
        self.priceTextField.text = ""
        self.errorLabel.isHidden = true
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
                    let listID = "\(customer.customerID)"
                    if "\(chirrenID)" == listID {
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
    
    //Called when editing an existing order
    func loadSelectCustomerButton() {
        
        var chirren: [UIMenuElement] = []
        chirren.append(UIAction(title: "\(selectedCustomer!.lastName ?? "unknown name"), \(selectedCustomer!.firstName ?? "unknown name")", handler: { action in
            self.customerAddressLabel.text = self.selectedCustomer?.customerAddress
            self.customerCityLabel.text = self.selectedCustomer?.customerCity
            self.customerStateLabel.text = self.selectedCustomer?.customerState
            self.customerZipLabel.text = self.selectedCustomer?.customerZipCode
            self.customerPhoneLabel.text = self.selectedCustomer?.customerPhone
        }))
        for customer in customerList {
            let chirrenID = customer.customerID
            if customer.customerID != selectedCustomer?.customerID {
                chirren.append(UIAction(title: "\(customer.lastName ?? "unknown name"), \(customer.firstName ?? "unknown name")", handler: { action in
                    for customer in self.customerList {
                        let listID = "\(customer.customerID)"
                        if "\(chirrenID)" == listID {
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
    
    func validateItemAddedData() -> Bool {
        var dataValid = false
        if itemOrderdPopUp.titleLabel?.text == nil {
            errorLabel.isHidden = false
            errorLabel.text = "Please choose an item to order!"
        } else if quantityTextField.text == "" {
            errorLabel.isHidden = false
            errorLabel.text = "Please enter the quantity of items ordered!"
        } else if batchSizeSegmentedControl.selectedSegmentIndex == 3 && otherTextField.text == "" {
            errorLabel.isHidden = false
            errorLabel.text = "Please enter a batch size!"
        } else if priceTextField.text == "" {
            errorLabel.isHidden = false
            errorLabel.text = "Please enter a batch price!"
        } else {
            dataValid = true
        }
        return dataValid
    }
    
    func validateOrderData() -> Bool {
        var dataValid = false
        if selectCustomerPopup.titleLabel?.text == nil {
            errorLabel.isHidden = false
            errorLabel.text = "Please choose a customer!"
        } else if tempItemsOrdered.count < 1 {
            errorLabel.isHidden = false
            errorLabel.text = "Please add items to the order!"
        } else {
            dataValid = true
        }
        return dataValid
    }
    
    func createOrderItem() {
        var itemDict: Dictionary = [String:Any]()
        var selectedRecipe: Recipe? = nil
        for recipe in recipeList {
            if itemOrderdPopUp.titleLabel?.text == recipe.name {
                selectedRecipe = recipe
            }
        }
        itemDict["ItemOrdered"] = selectedRecipe
        itemDict["ItemNotes"] = itemNoteTextField.text
        let quantity = Int16(quantityTextField.text ?? "0")!
        itemDict["Quantity"] = quantity
        var tempBatchSize:Int16 = 0
        var batchName =  ""
        switch batchSizeSegmentedControl.selectedSegmentIndex {
        case 1:
            batchName = "(half-dozen)"
            tempBatchSize = batchSize
        case 2:
            batchName = ""
            tempBatchSize = batchSize
        case 3:
            batchName = "(Batch of \(otherTextField.text ?? "0"))"
            let intBatchSize = Int16(otherTextField.text ?? "0")
            tempBatchSize = intBatchSize!
        default:
            batchName = "(dozen)"
            tempBatchSize = batchSize
        }
        itemDict["BatchName"] = batchName
        itemDict["BatchSize"] = tempBatchSize
        let floatPrice = UnitsConverter().convertCurrencyStringToFloat(stringCurrency: priceTextField.text ?? "0")
        itemDict["BatchPrice"] = floatPrice
        itemDict["BatchSubtotal"] = Float(quantity) * floatPrice
        tempItemsOrdered.append(itemDict)
    }
    
    func createOrderNumber() {
        loadOrders()
        var orderNumberList: [String] = []
        for order in ordersList {
            orderNumberList.append(order.orderNumber!)
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "YYMMDD"
        let stringDate = formatter.string(from: orderDatePicker.date)
        var tempOrderNumber = "\(stringDate)\("001")"
        var dailyOrders = 1
        while orderNumberList.contains(tempOrderNumber) == true {
            dailyOrders += 1
            var orders = ""
            if dailyOrders < 10 {
                orders = "00\(dailyOrders)"
            } else if dailyOrders < 100 {
                orders = "0\(dailyOrders)"
            } else {
                orders = "\(dailyOrders)"
            }
            tempOrderNumber = "\(stringDate)\(orders)"
        }
        orderNumberTextField.text = tempOrderNumber
    }
    
    func getSubtotal() -> Float {
        var orderSubtotal: Float = 0.0
        for item in tempItemsOrdered {
            orderSubtotal += item["BatchSubtotal"] as! Float
        }
        return orderSubtotal
    }
    
    func getSalesTax() -> Float {
        var salesTax: Float = 0.0
        if loadedCompany == [] {
            salesTax = 0.0
        } else if loadedCompany[0].withholdTax == true {
            let subtotal = getSubtotal()
            let rawTax = roundf(loadedCompany[0].taxRate * subtotal)
            salesTax = rawTax/100
        }
        return salesTax
    }
    
    func getTotal() -> Float {
        let subTotal = getSubtotal()
        let salesTax = getSalesTax()
        let total = subTotal + salesTax
        return total
    }
    
    @IBAction func orderDateChanged(_ sender: UIDatePicker) {
        createOrderNumber()
    }
    
    @IBAction func batchSegmentedControlChanged(_ sender: UISegmentedControl) {
        
        otherTextField.isHidden = true
        switch batchSizeSegmentedControl.selectedSegmentIndex {
        case 1 :
            batchSize = 6
        case 2:
            batchSize = 1
        case 3:
            otherTextField.isHidden = false
        default:
            batchSize = 12
        }
    }
    
    @IBAction func addToOrderPressed(_ sender: BrettButton) {
        errorLabel.isHidden = true
        if validateItemAddedData() == true {
            createOrderItem()
            setupItemOrderedButton()
            itemOrderdPopUp.titleLabel?.text = nil
            quantityTextField.text = ""
            batchSizeSegmentedControl.selectedSegmentIndex = 0
            otherTextField.text = ""
            otherTextField.isHidden = true
            priceTextField.text = ""
            itemNoteTextField.text = ""
            updateData()
        }
    }
    
    @IBAction func saveOrderPressed(_ sender: BrettButton) {
        errorLabel.isHidden = true
        if validateOrderData() == true {
            if segueOrder != nil {
                let newOrder = segueOrder!
                newOrder.toCustomer = selectedCustomer
                newOrder.orderDate = orderDatePicker.date
                newOrder.orderNumber = orderNumberTextField.text
                newOrder.orderSubtotal = getSubtotal()
                newOrder.orderSalesTax = getSalesTax()
                newOrder.orderTotal = getTotal()
                newOrder.orderComplete = false
                newOrder.toOrderedItem = nil
                for item in tempItemsOrdered {
                    let newItemOrdered = OrderedItem(context: K.ordersContext)
                    (item["ItemOrdered"] as! Recipe).addToToOrderedItem(newItemOrdered)
                    newItemOrdered.quantityOrdered = item["Quantity"] as! Int16
                    newItemOrdered.batchName = "\(item["BatchName"]!)"
                    newItemOrdered.batchSize = item["BatchSize"] as! Int16
                    newItemOrdered.batchPrice = item["BatchPrice"] as! Float
                    newItemOrdered.batchSubtotal = item["BatchSubtotal"] as! Float
                    newItemOrdered.itemNote = "\(item["ItemNotes"]!)"
                    newItemOrdered.addToToOrder(newOrder)
                }
            } else {
                let newOrder = Order(context: K.ordersContext)
                selectedCustomer?.addToToOrder(newOrder)
                newOrder.orderDate = orderDatePicker.date
                newOrder.orderNumber = orderNumberTextField.text
                newOrder.orderSubtotal = getSubtotal()
                newOrder.orderSalesTax = getSalesTax()
                newOrder.orderTotal = getTotal()
                newOrder.orderComplete = false
                for item in tempItemsOrdered {
                    let newItemOrdered = OrderedItem(context: K.ordersContext)
                    (item["ItemOrdered"] as! Recipe).addToToOrderedItem(newItemOrdered)
                    newItemOrdered.quantityOrdered = item["Quantity"] as! Int16
                    newItemOrdered.batchName = "\(item["BatchName"]!)"
                    newItemOrdered.batchSize = item["BatchSize"] as! Int16
                    newItemOrdered.batchPrice = item["BatchPrice"] as! Float
                    newItemOrdered.batchSubtotal = item["BatchSubtotal"] as! Float
                    newItemOrdered.itemNote = "\(item["ItemNotes"]!)"
                    newItemOrdered.addToToOrder(newOrder)
                }
            }
            saveOrder()
            navigationController?.popViewController(animated: true)
            DispatchQueue.main.async {
                self.segueVC?.orderTableView.reloadData()
            }
            
        }
    }
    
    //MARK: CoreData CRUD Methods
    
    func saveOrder() {
        do {
            try K.ordersContext.save()
        } catch {
            print("Error saving Ingredients: \(error)")
        }
    }
    
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
    
    func loadOrders() {
        let request: NSFetchRequest<Order> = Order.fetchRequest()
        do {
            ordersList = try K.ordersContext.fetch(request)
        } catch {
            print("Error loading Ingredients: \(error)")
        }
    }
    
    func updateData() {
        DispatchQueue.main.async {
            self.subTotalAmountLabel.text = UnitsConverter().convertCurrencyFloatToString(floatCurrency: self.getSubtotal())
            self.salesTaxAmountLabel.text = UnitsConverter().convertCurrencyFloatToString(floatCurrency: self.getSalesTax())
            self.totalAmountLabel.text = UnitsConverter().convertCurrencyFloatToString(floatCurrency: self.getTotal())
            self.orderTableView.reloadData()
        }
    }
    
}

//MARK: TableView DataSource Methods

extension EditOrderViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tempItemsOrdered.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = orderTableView.dequeueReusableCell(withIdentifier: K.orderReuseIdentifier, for: indexPath) as! OrderTableViewCell
        cell.delegate = self
        cell.qtyLabel.text = "\(tempItemsOrdered[indexPath.row]["Quantity"]!)"
        cell.qtyLabel.textColor = K.bakeShopBlueberry
        let recipeName = (tempItemsOrdered[indexPath.row]["ItemOrdered"] as! Recipe).name
        cell.itemOrderedLabel.text = "\(recipeName!) \(tempItemsOrdered[indexPath.row]["BatchName"]!)"
        cell.itemOrderedLabel.textColor = K.bakeShopBlueberry
        let floatPrice = tempItemsOrdered[indexPath.row]["BatchPrice"] as! Float
        cell.batchPriceLabel.text = UnitsConverter().convertCurrencyFloatToString(floatCurrency: floatPrice)
        cell.batchPriceLabel.textColor = K.bakeShopBlueberry
        let floatSubtotal = tempItemsOrdered[indexPath.row]["BatchSubtotal"] as! Float
        cell.subtotalLabel.text = UnitsConverter().convertCurrencyFloatToString(floatCurrency: floatSubtotal)
        cell.subtotalLabel.textColor = K.bakeShopBlueberry
        let itemNote = tempItemsOrdered[indexPath.row]["ItemNotes"]
        if itemNote as! String == "" {
            cell.bottomStackView.isHidden = true
        } else {
            cell.itemNoteLabel.text = "    Note: \(itemNote ?? "")"
        }
        cell.itemNoteLabel.textColor = K.bakeShopBlueberry
        
        return cell
    }
    
}

extension EditOrderViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        //Allowing the user to deselect a selected cell
        if selectedIndexPath == indexPath {
            // it was already selected
            selectedIndexPath = nil
            tableView.deselectRow(at: indexPath, animated: false)
        } else {
            // wasn't yet selected, so let's remember it
            selectedIndexPath = indexPath
        }
        
    }
}

//MARK: Swipe Cell Kit Functionality

extension EditOrderViewController: SwipeTableViewCellDelegate {
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title:.none) { action, indexPath in
            self.tempItemsOrdered.remove(at: indexPath.row)
            self.updateData()
        }
        
        // customize the action appearance
        deleteAction.image = UIImage(named: "delete-icon")
        
        return [deleteAction]
    }
}
