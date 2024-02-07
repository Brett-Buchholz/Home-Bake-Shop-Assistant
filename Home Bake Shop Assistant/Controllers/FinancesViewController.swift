//
//  FinancesViewController.swift
//  Home Bake Shop Assistant
//
//  Created by Brett Buchholz on 1/31/24.
//

import UIKit
import CoreData

class FinancesViewController: UIViewController {
    
    @IBOutlet weak var financesTitleLabel: PaddingLabel!
    @IBOutlet weak var companyDataHeader: PaddingLabel!
    @IBOutlet weak var orderAmountLabel: PaddingLabel!
    @IBOutlet weak var revenueAmountLabel: PaddingLabel!
    @IBOutlet weak var cogsAmountLabel: PaddingLabel!
    @IBOutlet weak var salesTaxAmountLabel: PaddingLabel!
    @IBOutlet weak var profitAmountLabel: PaddingLabel!
    
    @IBOutlet weak var startDatePicker: UIDatePicker!
    @IBOutlet weak var endDatePicker: UIDatePicker!
    @IBOutlet weak var dateStackView: UIStackView!
    @IBOutlet weak var companyDataView: UIView!
    
    @IBOutlet weak var recipeSalesButton: BrettButton!
    @IBOutlet weak var recipeCostsButton: BrettButton!
    @IBOutlet weak var customerDataButton: BrettButton!
    @IBOutlet weak var inventoryDataButton: BrettButton!
    
    var ordersList: [Order] = []
    var tempOrderList: [Order] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Style The View
        financesTitleLabel.clipsToBounds = true
        AddBorders().addAllBorders(with: K.bakeShopChocolate, andWidth: 2.0, view: financesTitleLabel)
        AddBorders().addAllBorders(with: K.bakeShopChocolate, andWidth: 2.0, view: companyDataHeader)
        AddBorders().addAllBorders(with: K.bakeShopChocolate, andWidth: 2.0, view: dateStackView)
        //AddBorders().addRightBorder(with: K.bakeShopChocolate, andWidth: 2.0, view: dateStackView)
        AddBorders().addAllBorders(with: K.bakeShopChocolate, andWidth: 2.0, view: companyDataView)
        recipeSalesButton.tintColor = K.systemBackground
        recipeSalesButton.configuration?.baseForegroundColor = K.bakeShopChocolate
        recipeCostsButton.tintColor = K.systemBackground
        recipeCostsButton.configuration?.baseForegroundColor = K.bakeShopChocolate
        customerDataButton.tintColor = K.systemBackground
        customerDataButton.configuration?.baseForegroundColor = K.bakeShopChocolate
        inventoryDataButton.tintColor = K.systemBackground
        inventoryDataButton.configuration?.baseForegroundColor = K.bakeShopChocolate
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.tintColor = .systemBackground
        setStartDate()
        loadCompanyFinanceData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.navigationBar.tintColor = .bakeShopBlack
    }
    
    func setStartDate() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        let stringYear = formatter.string(from: endDatePicker.date)
        let stringDate = "01-01-" + stringYear
        let newFormatter = DateFormatter()
        newFormatter.dateFormat = "MM-DD-yyyy"
        let startDate = newFormatter.date(from: stringDate)
        startDatePicker.date = startDate!
    }
    
    func getOrdersInDateRange() {
        loadOrders()
        tempOrderList = []
        
        //Format Start Date
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let stringDate = formatter.string(from: startDatePicker.date)
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        let startDateString = stringDate + " 00:00:00"
        let startDate = formatter.date(from: startDateString)!
        
        //Format End Date
        formatter.dateFormat = "yyyy-MM-dd"
        let stringEndDate = formatter.string(from: endDatePicker.date)
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        let endDateString = stringEndDate + " 23:59:59"
        let endDate = formatter.date(from: endDateString)!
        
        //Get Orders in the Date Range
        let range = startDate...endDate
        for order in ordersList {
            if range.contains(order.orderDate!) {
                tempOrderList.append(order)
            }
        }
    }
    
    func loadCompanyFinanceData() {
        loadOrders()
        getOrdersInDateRange()
        
        //Get COGS
        var cogsAmount: Float = 0.00
        //Get Recipe Ingredients
        var orderedItems: [OrderedItem] = []
        for order in tempOrderList {
            for item in order.toOrderedItem?.allObjects as! [OrderedItem] {
                orderedItems.append(item)
            }
        }
        for item in orderedItems {
            cogsAmount += FinanceDataManager().getCOGS(recipe: item.toRecipe!, orderedItemBatchSize: item.batchSize, quantityOrdered: item.quantityOrdered)
        }
        //Get Values
        var revenueAmount: Float = 0.00
        var salesTaxAmount: Float = 0.00
        for order in tempOrderList {
            revenueAmount += order.orderTotal
            salesTaxAmount += order.orderSalesTax
        }
        orderAmountLabel.text = "\(tempOrderList.count)"
        revenueAmountLabel.text = StringConverter().convertCurrencyFloatToString(floatCurrency: revenueAmount)
        cogsAmountLabel.text = StringConverter().convertCurrencyFloatToString(floatCurrency: cogsAmount)
        salesTaxAmountLabel.text = StringConverter().convertCurrencyFloatToString(floatCurrency: salesTaxAmount)
        profitAmountLabel.text = StringConverter().convertCurrencyFloatToString(floatCurrency: (revenueAmount - salesTaxAmount - cogsAmount))
    }
    
    @IBAction func startDatePickerChanged(_ sender: UIDatePicker) {
        loadCompanyFinanceData()
    }
    
    @IBAction func endDatePickerChanged(_ sender: UIDatePicker) {
        loadCompanyFinanceData()
    }
    
    //MARK: CoreData CRUD Methods
    
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
