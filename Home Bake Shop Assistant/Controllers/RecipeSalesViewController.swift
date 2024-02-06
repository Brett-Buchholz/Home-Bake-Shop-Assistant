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
    @IBOutlet weak var headersStackView: UIStackView!
    @IBOutlet weak var totalsStackView: UIStackView!
    
    @IBOutlet weak var startDatePicker: UIDatePicker!
    @IBOutlet weak var endDatePicker: UIDatePicker!
    
    @IBOutlet weak var recipeDataTableView: UITableView!
    
    var recipeList: [Recipe] = []
    var ordersList: [Order] = []
    var tempDataArray: [FinanceDataManager.RecipeSalesData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Style The View
        financesTitleLabel.clipsToBounds = true
        AddBorders().addAllBorders(with: K.bakeShopChocolate, andWidth: 2.0, view: financesTitleLabel)
        AddBorders().addAllBorders(with: K.bakeShopChocolate, andWidth: 4.0, view: recipeDataTitleLabel)
        AddBorders().addLeftBorder(with: K.bakeShopChocolate, andWidth: 4.0, view: dateStackView)
        AddBorders().addRightBorder(with: K.bakeShopChocolate, andWidth: 4.0, view: dateStackView)
        AddBorders().addLeftBorder(with: K.bakeShopChocolate, andWidth: 4.0, view: headersStackView)
        AddBorders().addRightBorder(with: K.bakeShopChocolate, andWidth: 4.0, view: headersStackView)
        AddBorders().addAllBorders(with: K.bakeShopChocolate, andWidth: 4.0, view: recipeDataTableView)
        AddBorders().addLeftBorder(with: K.bakeShopChocolate, andWidth: 4.0, view: totalsStackView)
        AddBorders().addRightBorder(with: K.bakeShopChocolate, andWidth: 4.0, view: totalsStackView)
        AddBorders().addBottomBorder(with: K.bakeShopChocolate, andWidth: 4.0, view: totalsStackView)
        recipeDataTableView.rowHeight = 50.0
        
        //Register delegates, data sources and Nibs
        recipeDataTableView.dataSource = self
        recipeDataTableView.register(UINib(nibName: K.recipeSalesCellNibName, bundle: nil), forCellReuseIdentifier: K.recipeSalesReuseIdentifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.tintColor = .systemBackground
        setStartDate()
        loadRecipeFinanceData()
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
    
    func loadRecipeFinanceData() {
        loadRecipes()
        loadOrders()
        tempDataArray = []
        var tempOrderList: [Order] = []
        
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
            for ingredient in (orderedItem.toRecipe?.toRecipeIngredient?.allObjects as! [RecipeIngredient]) {
                
                //Cost per standard Unit
                let cost = ingredient.inventory!.cost
                
                //Convert recipe units to standard units
                let amount = (ingredient.quantity * Float(orderedItem.quantityOrdered))
                let measuredUnits = UnitsOfMeasurement().convertStringToUnits(string: ingredient.units!)
                let standardUnits = UnitsOfMeasurement().convertStringToUnits(string: (ingredient.inventory?.baseUnit)!)
                let adjustedAmount = UnitsConverter(amount: amount, measuredUnits: measuredUnits, standardUnits: standardUnits).convertUnits()
                
                //Update COGS
                cogsAmount += (cost * adjustedAmount)
                
            }
            
            //Update the dictionary
            if tempDataArray.contains(where: { dataItem in
                dataItem.name == orderedItem.toRecipe!.name!
            }) == false {
                let dataName = orderedItem.toRecipe!.name!
                let dataSales = orderedItem.quantityOrdered
                let dataRevenue = Float(orderedItem.quantityOrdered) * orderedItem.batchPrice
                let dataCOGS = cogsAmount
                let newDataItem = FinanceDataManager.RecipeSalesData(name: dataName, sales: dataSales, revenue: dataRevenue, cogs: dataCOGS)
                tempDataArray.append(newDataItem)
            } else {
                for dataItem in tempDataArray {
                    if dataItem.name == orderedItem.toRecipe!.name! {
                        dataItem.sales += orderedItem.quantityOrdered
                        dataItem.revenue += (Float(orderedItem.quantityOrdered) * orderedItem.batchPrice)
                        dataItem.cogs += cogsAmount
                    }
                }
            }
        }
        for recipe in recipeList {
            if tempDataArray.contains(where: { item in
                item.name ==  recipe.name
            }) == false {
                let newRecipeData = FinanceDataManager.RecipeSalesData(name: recipe.name!, sales: 0, revenue: 0, cogs: 0)
                tempDataArray.append(newRecipeData)
            }
        }
        //Get Totals
        var totalSales: Int16 = 0
        var totalRevenue: Float = 0
        var totalCogs: Float = 0
        var totalProfit: Float = 0
        for item in tempDataArray {
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
    
    @IBAction func startDateUpdated(_ sender: UIDatePicker) {
        loadRecipeFinanceData()
        reloadDataAndView()
    }
    
    @IBAction func endDateUpdated(_ sender: UIDatePicker) {
        loadRecipeFinanceData()
        reloadDataAndView()
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
    
    func reloadDataAndView() {
        DispatchQueue.main.async {
            self.tempDataArray = self.tempDataArray.sorted {$0.name < $1.name}
            self.recipeDataTableView.reloadData()
        }
    }
}

//MARK: TableView DataSource Methods

extension RecipeSalesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tempDataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = recipeDataTableView.dequeueReusableCell(withIdentifier: K.recipeSalesReuseIdentifier, for: indexPath) as! RecipeSalesTableViewCell
        
        tempDataArray = tempDataArray.sorted {$0.name < $1.name}
        let recipe = tempDataArray[indexPath.row]
        cell.nameLabel.text = recipe.name
        cell.salesLabel.text = "\(recipe.sales)"
        cell.revenueLabel.text = StringConverter().convertCurrencyFloatToString(floatCurrency: recipe.revenue)
        cell.cogsLabel.text = StringConverter().convertCurrencyFloatToString(floatCurrency: recipe.cogs)
        cell.profitLabel.text = StringConverter().convertCurrencyFloatToString(floatCurrency: recipe.profit)
        
        return cell
    }
    
}
