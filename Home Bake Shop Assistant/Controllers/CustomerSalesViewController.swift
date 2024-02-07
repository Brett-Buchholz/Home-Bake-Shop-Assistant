//
//  CustomerSalesViewController.swift
//  Home Bake Shop Assistant
//
//  Created by Brett Buchholz on 2/6/24.
//

import UIKit
import CoreData

class CustomerSalesViewController: UIViewController {
    
    @IBOutlet weak var financesTitleLabel: PaddingLabel!
    @IBOutlet weak var customerSalesTitleLabel: PaddingLabel!
    @IBOutlet weak var totalOrdersLabel: PaddingLabel!
    @IBOutlet weak var totalRevenueLabel: PaddingLabel!
    @IBOutlet weak var totalCOGSLabel: PaddingLabel!
    @IBOutlet weak var totalProfitLabel: PaddingLabel!
    
    @IBOutlet weak var dateStackView: UIStackView!
    @IBOutlet weak var sortView: UIView!
    @IBOutlet weak var headersStackView: UIStackView!
    @IBOutlet weak var totalsStackView: UIStackView!
    
    @IBOutlet weak var startDatePicker: UIDatePicker!
    @IBOutlet weak var endDatePicker: UIDatePicker!
    @IBOutlet weak var sortPopUpButton: UIButton!
    @IBOutlet weak var sortSegmentedControl: UISegmentedControl!
    @IBOutlet weak var customerSalesTableView: UITableView!
    
    var customerList: [Customer] = []
    var ordersList: [Order] = []
    var tempOrderList: [Order] = []
    var financeDataArray: [FinanceDataManager.CustomerSalesData] = []
    var selectedSortOption = "Name"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Style The View
        financesTitleLabel.clipsToBounds = true
        AddBorders().addAllBorders(with: K.bakeShopChocolate, andWidth: 2.0, view: financesTitleLabel)
        AddBorders().addAllBorders(with: K.bakeShopChocolate, andWidth: 4.0, view: customerSalesTitleLabel)
        AddBorders().addLeftBorder(with: K.bakeShopChocolate, andWidth: 4.0, view: dateStackView)
        AddBorders().addRightBorder(with: K.bakeShopChocolate, andWidth: 4.0, view: dateStackView)
        AddBorders().addLeftBorder(with: K.bakeShopChocolate, andWidth: 4.0, view: sortView)
        AddBorders().addRightBorder(with: K.bakeShopChocolate, andWidth: 4.0, view: sortView)
        AddBorders().addLeftBorder(with: K.bakeShopChocolate, andWidth: 4.0, view: headersStackView)
        AddBorders().addRightBorder(with: K.bakeShopChocolate, andWidth: 4.0, view: headersStackView)
        AddBorders().addAllBorders(with: K.bakeShopChocolate, andWidth: 4.0, view: customerSalesTableView)
        AddBorders().addLeftBorder(with: K.bakeShopChocolate, andWidth: 4.0, view: totalsStackView)
        AddBorders().addRightBorder(with: K.bakeShopChocolate, andWidth: 4.0, view: totalsStackView)
        AddBorders().addBottomBorder(with: K.bakeShopChocolate, andWidth: 4.0, view: totalsStackView)
        customerSalesTableView.rowHeight = 50.0
        sortSegmentedControl.defaultConfiguration()
        sortSegmentedControl.selectedConfiguration()
        
        //Register delegates, data sources and Nibs
        customerSalesTableView.dataSource = self
        customerSalesTableView.register(UINib(nibName: K.recipeSalesCellNibName, bundle: nil), forCellReuseIdentifier: K.recipeSalesReuseIdentifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.tintColor = .systemBackground
        setupSortButton()
        setStartDate()
        loadCustomerFinanceData()
        sortFinanceArray()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.navigationBar.tintColor = .bakeShopBlack
    }
    
    func setupSortButton() {
        let sortOptions = ["Name", "Orders", "Revenue", "COGS", "Profit"]
        var chirren: [UIMenuElement] = []
        for option in sortOptions {
            chirren.append(UIAction(title: option) { (action: UIAction) in
                self.selectedSortOption = option
                self.sortFinanceArray()
            })
        }
        sortPopUpButton.menu = UIMenu(children: chirren)
    }
    
    func sortFinanceArray() {
        switch selectedSortOption {
        case "Sales":
            if sortSegmentedControl.selectedSegmentIndex == 0 {
                financeDataArray = financeDataArray.sorted {$0.orders < $1.orders}
            } else {
                financeDataArray = financeDataArray.sorted {$0.orders > $1.orders}
            }
        case "Revenue":
            if sortSegmentedControl.selectedSegmentIndex == 0 {
                financeDataArray = financeDataArray.sorted {$0.revenue < $1.revenue}
            } else {
                financeDataArray = financeDataArray.sorted {$0.revenue > $1.revenue}
            }
        case "COGS":
            if sortSegmentedControl.selectedSegmentIndex == 0 {
                financeDataArray = financeDataArray.sorted {$0.cogs < $1.cogs}
            } else {
                financeDataArray = financeDataArray.sorted {$0.cogs > $1.cogs}
            }
        case "Profit":
            if sortSegmentedControl.selectedSegmentIndex == 0 {
                financeDataArray = financeDataArray.sorted {$0.profit < $1.profit}
            } else {
                financeDataArray = financeDataArray.sorted {$0.profit > $1.profit}
            }
        default:
            if sortSegmentedControl.selectedSegmentIndex == 0 {
                financeDataArray = financeDataArray.sorted {$0.stringName < $1.stringName}
            } else {
                financeDataArray = financeDataArray.sorted {$0.stringName > $1.stringName}
            }
        }
        reloadTableView()
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
    
    func loadCustomerFinanceData() {
        loadCustomerList()
        getOrdersInDateRange()
        financeDataArray = []

        //Get Order Info
        var orderCustomer: Customer? = nil
        var orderRevenue: Float = 0
        var orderCOGS: Float = 0
        for order in tempOrderList {
            orderCOGS = 0
            orderCustomer = order.toCustomer!
            orderRevenue = order.orderTotal - order.orderSalesTax
            
            //Get COGS
            for item in (order.toOrderedItem?.allObjects as! [OrderedItem]) {
                orderCOGS += FinanceDataManager().getCOGS(recipe: item.toRecipe!, orderedItemBatchSize: item.batchSize, quantityOrdered: item.quantityOrdered)
            }
            if financeDataArray.contains(where: { dataItem in
                dataItem.customer == orderCustomer
            }) == false {
                let newSalesData = FinanceDataManager.CustomerSalesData(customer: orderCustomer!, orders: 1, revenue: orderRevenue, cogs: orderCOGS)
                financeDataArray.append(newSalesData)
            } else {
                for dataItem in financeDataArray {
                    if dataItem.customer == orderCustomer {
                        dataItem.orders += 1
                        dataItem.revenue += orderRevenue
                        dataItem.cogs += orderCOGS
                    }
                }
            }
        }
        
        for customer in customerList {
            if financeDataArray.contains(where: { dataItem in
                dataItem.customer == customer
            }) == false {
                let newSalesData = FinanceDataManager.CustomerSalesData(customer: customer, orders: 0, revenue: 0, cogs: 0)
                financeDataArray.append(newSalesData)
            }
        }
        //Get Totals
        var totalOrders: Int16 = 0
        var totalRevenue: Float = 0
        var totalCogs: Float = 0
        var totalProfit: Float = 0
        for item in financeDataArray {
            totalOrders += item.orders
            totalRevenue += item.revenue
            totalCogs += item.cogs
            totalProfit += item.profit
        }
        totalOrdersLabel.text = "\(totalOrders)"
        totalRevenueLabel.text = StringConverter().convertCurrencyFloatToString(floatCurrency: totalRevenue)
        totalCOGSLabel.text = StringConverter().convertCurrencyFloatToString(floatCurrency: totalCogs)
        totalProfitLabel.text = StringConverter().convertCurrencyFloatToString(floatCurrency: totalProfit)
        
    }
    
    @IBAction func sortSegmentedControlChanged(_ sender: UISegmentedControl) {
        sortFinanceArray()
    }
    
    @IBAction func startDateChanged(_ sender: UIDatePicker) {
        loadCustomerFinanceData()
        sortFinanceArray()
    }
    
    @IBAction func endDateChanged(_ sender: UIDatePicker) {
        loadCustomerFinanceData()
        sortFinanceArray()
    }
    
    //MARK: CoreData CRUD Methods
    
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
    
    func reloadTableView() {
        DispatchQueue.main.async {
            self.customerSalesTableView.reloadData()
        }
    }
}

//MARK: TableView DataSource Methods

extension CustomerSalesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        financeDataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = customerSalesTableView.dequeueReusableCell(withIdentifier: K.recipeSalesReuseIdentifier, for: indexPath) as! RecipeSalesTableViewCell
        
        
        let customer = financeDataArray[indexPath.row]
        cell.nameLabel.text = customer.stringName
        cell.salesLabel.text = "\(customer.orders)"
        cell.revenueLabel.text = StringConverter().convertCurrencyFloatToString(floatCurrency: customer.revenue)
        cell.cogsLabel.text = StringConverter().convertCurrencyFloatToString(floatCurrency: customer.cogs)
        cell.profitLabel.text = StringConverter().convertCurrencyFloatToString(floatCurrency: customer.profit)
        
        return cell
    }
}

