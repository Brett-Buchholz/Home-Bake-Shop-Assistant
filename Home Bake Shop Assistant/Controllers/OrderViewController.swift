//
//  OrderViewController.swift
//  Home Bake Shop Assistant
//
//  Created by Brett Buchholz on 1/8/24.
//

import UIKit
import CoreData

class OrderViewController: UIViewController {
    
    @IBOutlet weak var companyNamelLabel: PaddingLabel!
    @IBOutlet weak var companyAddressLabel: PaddingLabel!
    @IBOutlet weak var companyCityLabel: PaddingLabel!
    @IBOutlet weak var companyStateLabel: PaddingLabel!
    @IBOutlet weak var companyZipCodeLabel: PaddingLabel!
    
    @IBOutlet weak var customerNameLabel: PaddingLabel!
    @IBOutlet weak var customerAddressLabel: PaddingLabel!
    @IBOutlet weak var customerCityLabel: PaddingLabel!
    @IBOutlet weak var customerStateLabel: PaddingLabel!
    @IBOutlet weak var customerZipCodeLabel: PaddingLabel!
    @IBOutlet weak var customerPhoneLabel: PaddingLabel!
    
    @IBOutlet weak var orderDateValue: PaddingLabel!
    @IBOutlet weak var orderNumberValue: PaddingLabel!
    
    @IBOutlet weak var subtotalAmountLabel: PaddingLabel!
    @IBOutlet weak var salesTaxLabel: PaddingLabel!
    @IBOutlet weak var salesTaxAmountLabel: PaddingLabel!
    @IBOutlet weak var totalAmountLabel: PaddingLabel!
    
    @IBOutlet weak var topBackgroundView: UIView!
    @IBOutlet weak var headerStackView: UIStackView!
    @IBOutlet weak var orderTableView: UITableView!
    @IBOutlet weak var subtotalStackView: UIStackView!
    @IBOutlet weak var salesTaxStackView: UIStackView!
    
    @IBOutlet weak var editOrderButton: BrettButton!
    @IBOutlet weak var deleteOrderButton: BrettButton!
    
    var loadedOrder: Order? = nil
    var orderedItems: [OrderedItem] = []
    var loadedCompany: [Company] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Style The View
        AddBorders().addAllBorders(with: K.bakeShopBlack, andWidth: 2.0, view: topBackgroundView)
        AddBorders().addAllBorders(with: K.bakeShopBlack, andWidth: 2.0, view: orderTableView)
        AddBorders().addTopBorder(with: K.bakeShopBlack, andWidth: 2.0, view: headerStackView)
        AddBorders().addLeftBorder(with: K.bakeShopBlack, andWidth: 2.0, view: headerStackView)
        AddBorders().addRightBorder(with: K.bakeShopBlack, andWidth: 2.0, view: headerStackView)
        deleteOrderButton.tintColor = K.bakeShopDeleteRed
        editOrderButton.tintColor = K.bakeShopBlueberry
        
        //Register delegates, data sources and Nibs
        orderTableView.dataSource = self
        orderTableView.delegate = self
        orderTableView.register(UINib(nibName: K.orderCellNibName, bundle: nil), forCellReuseIdentifier: K.orderReuseIdentifier)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        orderedItems = loadedOrder?.toOrderedItem?.allObjects as! [OrderedItem]
        loadLabelData()
    }
    
    func loadLabelData() {
        loadCompanyInfo()
        companyNamelLabel.text = loadedCompany[0].name
        companyAddressLabel.text = loadedCompany[0].address
        companyCityLabel.text = loadedCompany[0].city
        companyStateLabel.text = loadedCompany[0].state
        companyZipCodeLabel.text = loadedCompany[0].zipCode
        
        let customer = loadedOrder?.toCustomer
        customerNameLabel.text = "\(customer!.firstName ?? "unknown") \(customer!.lastName ?? "unknown")"
        customerAddressLabel.text = customer?.customerAddress
        customerCityLabel.text = customer?.customerCity
        customerStateLabel.text = customer?.customerState
        customerZipCodeLabel.text = customer?.customerZipCode
        
        let date = loadedOrder?.orderDate
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/DD/YY"
        let stringDate = dateFormatter.string(from: date!)
        orderDateValue.text = stringDate
        orderNumberValue.text = loadedOrder?.orderNumber
        
        if loadedOrder?.orderSalesTax == 0 {
            subtotalStackView.isHidden = true
            salesTaxStackView.isHidden = true
        } else {
            subtotalStackView.isHidden = false
            salesTaxStackView.isHidden = false
            salesTaxLabel.text = "Sales Tax (\(loadedCompany[0].taxRate)%)"
            salesTaxAmountLabel.text = UnitsConverter().convertCurrencyFloatToString(floatCurrency: loadedOrder!.orderSalesTax)
            subtotalAmountLabel.text = UnitsConverter().convertCurrencyFloatToString(floatCurrency: loadedOrder!.orderSubtotal)
        }
        totalAmountLabel.text = UnitsConverter().convertCurrencyFloatToString(floatCurrency: loadedOrder!.orderTotal)
    }
    
    @IBAction func editOrderPressed(_ sender: BrettButton) {
    }
    
    @IBAction func deleteOrderPressed(_ sender: BrettButton) {
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
    
    
//    func loadOrders() {
//        let request: NSFetchRequest<Order> = Order.fetchRequest()
//        do {
//            ordersList = try K.ordersContext.fetch(request)
//        } catch {
//            print("Error loading Ingredients: \(error)")
//        }
//    }
    
    
    func updateData() {
        DispatchQueue.main.async {
            self.orderTableView.reloadData()
        }
    }
    
    
}

//MARK: TableView DataSource Methods

extension OrderViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        orderedItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = orderTableView.dequeueReusableCell(withIdentifier: K.orderReuseIdentifier, for: indexPath) as! OrderTableViewCell
        let item = orderedItems[indexPath.row]
        cell.qtyLabel.text = "\(item.quantityOrdered)"
        cell.qtyLabel.textColor = K.bakeShopBlack
        let recipeName = (item.toRecipe!).name
        cell.itemOrderedLabel.text = "\(recipeName!) \(item.batchName!)"
        cell.itemOrderedLabel.textColor = K.bakeShopBlack
        let floatPrice = item.batchPrice
        cell.batchPriceLabel.text = UnitsConverter().convertCurrencyFloatToString(floatCurrency: floatPrice)
        cell.batchPriceLabel.textColor = K.bakeShopBlack
        let floatSubtotal = item.batchSubtotal
        cell.subtotalLabel.text = UnitsConverter().convertCurrencyFloatToString(floatCurrency: floatSubtotal)
        cell.subtotalLabel.textColor = K.bakeShopBlack
        let itemNote = item.itemNote
        if itemNote == "" {
            cell.bottomStackView.isHidden = true
        } else {
            cell.itemNoteLabel.text = "    Note: \(itemNote ?? "")"
        }
        cell.itemNoteLabel.textColor = K.bakeShopBlack
        
        return cell
    }
    
}

extension OrderViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

