//
//  RecipeFinancesViewController.swift
//  Home Bake Shop Assistant
//
//  Created by Brett Buchholz on 2/3/24.
//

import UIKit
import CoreData

class RecipeSalesViewController: UIViewController {
    
    @IBOutlet weak var financesTitleLabel: PaddingLabel!
    @IBOutlet weak var recipeDataTitleLabel: PaddingLabel!
    @IBOutlet weak var totalSalesLabel: PaddingLabel!
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
    
    @IBOutlet weak var recipeDataTableView: UITableView!
    
    var recipeList: [Recipe] = []
    var ordersList: [Order] = []
    var tempOrderList: [Order] = []
    var financeDataArray: [FinanceDataManager.RecipeSalesData] = []
    var selectedSortOption = "Recipe"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Style The View
        financesTitleLabel.clipsToBounds = true
        AddBorders().addAllBorders(with: K.bakeShopChocolate, andWidth: 2.0, view: financesTitleLabel)
        AddBorders().addAllBorders(with: K.bakeShopChocolate, andWidth: 4.0, view: recipeDataTitleLabel)
        AddBorders().addLeftBorder(with: K.bakeShopChocolate, andWidth: 4.0, view: dateStackView)
        AddBorders().addRightBorder(with: K.bakeShopChocolate, andWidth: 4.0, view: dateStackView)
        AddBorders().addLeftBorder(with: K.bakeShopChocolate, andWidth: 4.0, view: sortView)
        AddBorders().addRightBorder(with: K.bakeShopChocolate, andWidth: 4.0, view: sortView)
        AddBorders().addLeftBorder(with: K.bakeShopChocolate, andWidth: 4.0, view: headersStackView)
        AddBorders().addRightBorder(with: K.bakeShopChocolate, andWidth: 4.0, view: headersStackView)
        AddBorders().addAllBorders(with: K.bakeShopChocolate, andWidth: 4.0, view: recipeDataTableView)
        AddBorders().addLeftBorder(with: K.bakeShopChocolate, andWidth: 4.0, view: totalsStackView)
        AddBorders().addRightBorder(with: K.bakeShopChocolate, andWidth: 4.0, view: totalsStackView)
        AddBorders().addBottomBorder(with: K.bakeShopChocolate, andWidth: 4.0, view: totalsStackView)
        recipeDataTableView.rowHeight = 50.0
        sortSegmentedControl.defaultConfiguration()
        sortSegmentedControl.selectedConfiguration()
        
        //Register delegates, data sources and Nibs
        recipeDataTableView.dataSource = self
        recipeDataTableView.register(UINib(nibName: K.recipeSalesCellNibName, bundle: nil), forCellReuseIdentifier: K.recipeSalesReuseIdentifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.tintColor = .systemBackground
        setupSortButton()
        setStartDate()
        loadRecipeFinanceData()
        sortFinanceArray()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.navigationBar.tintColor = .bakeShopBlack
    }
    
    func setupSortButton() {
        let sortOptions = ["Recipe", "Sales", "Revenue", "COGS", "Profit"]
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
                financeDataArray = financeDataArray.sorted {$0.sales < $1.sales}
            } else {
                financeDataArray = financeDataArray.sorted {$0.sales > $1.sales}
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
                financeDataArray = financeDataArray.sorted {$0.name < $1.name}
            } else {
                financeDataArray = financeDataArray.sorted {$0.name > $1.name}
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
    
    func loadRecipeFinanceData() {
        loadRecipes()
        loadOrders()
        getOrdersInDateRange()
        financeDataArray = []
        
        //Get orderdItems
        var tempOrderedItems: [OrderedItem] = []
        for order in tempOrderList {
            for item in (order.toOrderedItem?.allObjects as! [OrderedItem]) {
                tempOrderedItems.append(item)
            }
        }
        
        //Get COGS
        for orderedItem in tempOrderedItems {
            var cogsAmount: Float = 0
            cogsAmount += FinanceDataManager().getCOGS(recipe: orderedItem.toRecipe!, orderedItemBatchSize: orderedItem.batchSize, quantityOrdered: orderedItem.quantityOrdered)
            
            //Update the Finance Array
            if financeDataArray.contains(where: { dataItem in
                dataItem.name == orderedItem.toRecipe!.name!
            }) == false {
                let dataName = orderedItem.toRecipe!.name!
                let dataSales = Int(orderedItem.quantityOrdered)
                let dataRevenue = Float(orderedItem.quantityOrdered) * orderedItem.batchPrice
                let dataCOGS = cogsAmount
                let newDataItem = FinanceDataManager.RecipeSalesData(name: dataName, sales: dataSales, revenue: dataRevenue, cogs: dataCOGS)
                financeDataArray.append(newDataItem)
            } else {
                for dataItem in financeDataArray {
                    if dataItem.name == orderedItem.toRecipe!.name! {
                        dataItem.sales += Int(orderedItem.quantityOrdered)
                        dataItem.revenue += (Float(orderedItem.quantityOrdered) * orderedItem.batchPrice)
                        dataItem.cogs += cogsAmount
                    }
                }
            }
        }
        for recipe in recipeList {
            if financeDataArray.contains(where: { item in
                item.name ==  recipe.name
            }) == false {
                let newRecipeData = FinanceDataManager.RecipeSalesData(name: recipe.name!, sales: 0, revenue: 0, cogs: 0)
                financeDataArray.append(newRecipeData)
            }
        }
        //Get Totals
        var totalSales: Int = 0
        var totalRevenue: Float = 0
        var totalCogs: Float = 0
        var totalProfit: Float = 0
        for item in financeDataArray {
            totalSales += item.sales
            totalRevenue += item.revenue
            totalCogs += item.cogs
            totalProfit += item.profit
        }
        totalSalesLabel.text = "\(totalSales)"
        totalRevenueLabel.text = StringConverter().convertCurrencyFloatToString(floatCurrency: totalRevenue)
        totalCOGSLabel.text = StringConverter().convertCurrencyFloatToString(floatCurrency: totalCogs)
        totalProfitLabel.text = StringConverter().convertCurrencyFloatToString(floatCurrency: totalProfit)
    }
    
    @IBAction func sortSegmentedControlChanged(_ sender: UISegmentedControl) {
        sortFinanceArray()
    }
    
    @IBAction func startDateUpdated(_ sender: UIDatePicker) {
        loadRecipeFinanceData()
        sortFinanceArray()
    }
    
    @IBAction func endDateUpdated(_ sender: UIDatePicker) {
        loadRecipeFinanceData()
        sortFinanceArray()
    }
    
    //MARK: CoreData CRUD Methods
    
    func loadRecipes() {
        let request: NSFetchRequest<Recipe> = Recipe.fetchRequest()
        do {
            recipeList = try K.recipeContext.fetch(request)
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
            self.recipeDataTableView.reloadData()
        }
    }
}

//MARK: TableView DataSource Methods

extension RecipeSalesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        financeDataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = recipeDataTableView.dequeueReusableCell(withIdentifier: K.recipeSalesReuseIdentifier, for: indexPath) as! RecipeSalesTableViewCell
        
        let recipe = financeDataArray[indexPath.row]
        cell.nameLabel.text = recipe.name
        cell.salesLabel.text = "\(recipe.sales)"
        cell.revenueLabel.text = StringConverter().convertCurrencyFloatToString(floatCurrency: recipe.revenue)
        cell.cogsLabel.text = StringConverter().convertCurrencyFloatToString(floatCurrency: recipe.cogs)
        cell.profitLabel.text = StringConverter().convertCurrencyFloatToString(floatCurrency: recipe.profit)
        
        return cell
    }
}

//MARK: Segmented Control Style Options

extension UISegmentedControl {
    
    func defaultConfiguration(font: UIFont = K.fontSegCtrlPadNormal!, color: UIColor = K.bakeShopChocolate) {
        let defaultAttributes = [
            NSAttributedString.Key.font: font,
            NSAttributedString.Key.foregroundColor: color
        ]
        setTitleTextAttributes(defaultAttributes, for: .normal)
    }

    func selectedConfiguration(font: UIFont = K.fontSegCtrlPadBold!, color: UIColor = K.bakeShopChocolate){
        let selectedAttributes = [
            NSAttributedString.Key.font: font,
            NSAttributedString.Key.foregroundColor: color
        ]
        setTitleTextAttributes(selectedAttributes, for: .selected)
    }
}
