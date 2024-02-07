//
//  InventoryCostsViewController.swift
//  Home Bake Shop Assistant
//
//  Created by Brett Buchholz on 2/6/24.
//

import UIKit
import CoreData

class InventoryCostsViewController: UIViewController {
    
    @IBOutlet weak var financesTitleLabel: PaddingLabel!
    @IBOutlet weak var inventoryCostsTitleLabel: PaddingLabel!
    @IBOutlet weak var totalIngredientValueLabel: PaddingLabel!
    
    @IBOutlet weak var dateStackView: UIStackView!
    @IBOutlet weak var sortView: UIView!
    @IBOutlet weak var headersStackView: UIStackView!
    @IBOutlet weak var totalsStackView: UIStackView!
    
    @IBOutlet weak var startDatePicker: UIDatePicker!
    @IBOutlet weak var endDatePicker: UIDatePicker!
    @IBOutlet weak var sortPopUpButton: UIButton!
    @IBOutlet weak var sortSegmentedControl: UISegmentedControl!
    @IBOutlet weak var inventoryCostsTableView: UITableView!
    
    var ordersList: [Order] = []
    var inventoryList: [Inventory] = []
    var tempOrderList: [Order] = []
    var financeDataArray: [FinanceDataManager.InventoryCostData] = []
    var selectedSortOption = "Ingredient"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Style The View
        financesTitleLabel.clipsToBounds = true
        AddBorders().addAllBorders(with: K.bakeShopChocolate, andWidth: 2.0, view: financesTitleLabel)
        AddBorders().addAllBorders(with: K.bakeShopChocolate, andWidth: 4.0, view: inventoryCostsTitleLabel)
        AddBorders().addLeftBorder(with: K.bakeShopChocolate, andWidth: 4.0, view: dateStackView)
        AddBorders().addRightBorder(with: K.bakeShopChocolate, andWidth: 4.0, view: dateStackView)
        AddBorders().addLeftBorder(with: K.bakeShopChocolate, andWidth: 4.0, view: sortView)
        AddBorders().addRightBorder(with: K.bakeShopChocolate, andWidth: 4.0, view: sortView)
        AddBorders().addLeftBorder(with: K.bakeShopChocolate, andWidth: 4.0, view: headersStackView)
        AddBorders().addRightBorder(with: K.bakeShopChocolate, andWidth: 4.0, view: headersStackView)
        AddBorders().addAllBorders(with: K.bakeShopChocolate, andWidth: 4.0, view: inventoryCostsTableView)
        AddBorders().addLeftBorder(with: K.bakeShopChocolate, andWidth: 4.0, view: totalsStackView)
        AddBorders().addRightBorder(with: K.bakeShopChocolate, andWidth: 4.0, view: totalsStackView)
        AddBorders().addBottomBorder(with: K.bakeShopChocolate, andWidth: 4.0, view: totalsStackView)
        inventoryCostsTableView.rowHeight = 50.0
        sortSegmentedControl.defaultConfiguration()
        sortSegmentedControl.selectedConfiguration()
        
        //Register delegates, data sources and Nibs
        inventoryCostsTableView.dataSource = self
        inventoryCostsTableView.register(UINib(nibName: K.inventoryCostCellNibName, bundle: nil), forCellReuseIdentifier: K.inventoryCostReuseIdentifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.tintColor = .systemBackground
        setupSortButton()
        setStartDate()
        loadInventoryFinanceData()
        sortFinanceArray()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.navigationBar.tintColor = .bakeShopBlack
    }
    
    func setupSortButton() {
        let sortOptions = ["Ingredient", "UnitCost", "TotalCost"]
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
        case "UnitCost":
            if sortSegmentedControl.selectedSegmentIndex == 0 {
                financeDataArray = financeDataArray.sorted {$0.unitCost < $1.unitCost}
            } else {
                financeDataArray = financeDataArray.sorted {$0.unitCost > $1.unitCost}
            }
        case "TotalCost":
            if sortSegmentedControl.selectedSegmentIndex == 0 {
                financeDataArray = financeDataArray.sorted {$0.totalCost < $1.totalCost}
            } else {
                financeDataArray = financeDataArray.sorted {$0.totalCost > $1.totalCost}
            }
        default:
            if sortSegmentedControl.selectedSegmentIndex == 0 {
                financeDataArray = financeDataArray.sorted {$0.ingredient < $1.ingredient}
            } else {
                financeDataArray = financeDataArray.sorted {$0.ingredient > $1.ingredient}
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
    
    func loadInventoryFinanceData() {
        loadIngredients()
        getOrdersInDateRange()
        financeDataArray = []
        
        var tempOrderedItemList: [OrderedItem] = []
        for order in tempOrderList {
            for orderedItem in (order.toOrderedItem?.allObjects as! [OrderedItem]) {
                tempOrderedItemList.append(orderedItem)
            }
        }
        var financeDataIngredient: String = ""
        var financeDataAmount: Float = 0
        var financeDataUnits: UnitsOfMeasurement.Units = .None
        var financeDataUnitCost: Float = 0
        var financeDataTotalCost: Float = 0
        for orderedItem in tempOrderedItemList {
            for ingredient in (orderedItem.toRecipe?.toRecipeIngredient?.allObjects as! [RecipeIngredient]) {
                financeDataIngredient = ingredient.inventory!.ingredientName!
                let amount = (ingredient.quantity * Float(orderedItem.quantityOrdered)) / (Float(orderedItem.toRecipe!.batchSize)/Float(orderedItem.batchSize))
                let measuredUnits = UnitsOfMeasurement().convertStringToUnits(string: ingredient.units!)
                let standardUnits = UnitsOfMeasurement().convertStringToUnits(string: ingredient.inventory!.baseUnit!)
                let adjustedAmount = UnitsConverter(amount: amount, measuredUnits: measuredUnits, standardUnits: standardUnits).convertUnits()
                financeDataAmount = adjustedAmount
                financeDataUnits = standardUnits
                financeDataUnitCost = ingredient.inventory!.cost
                financeDataTotalCost = financeDataAmount * financeDataUnitCost
                if financeDataArray.contains(where: { dataItem in
                    dataItem.ingredient == financeDataIngredient
                }) == false {
                    let newInventoryFinanceData = FinanceDataManager.InventoryCostData(ingredient: financeDataIngredient, amount: financeDataAmount, units: financeDataUnits, unitCost: financeDataUnitCost, totalCost: financeDataTotalCost)
                    financeDataArray.append(newInventoryFinanceData)
                } else {
                    for dataItem in financeDataArray {
                        if dataItem.ingredient == financeDataIngredient {
                            dataItem.amount += financeDataAmount
                            dataItem.totalCost += financeDataTotalCost
                        }
                    }
                }
            }
        }
        for inventoryIngredient in inventoryList {
            if financeDataArray.contains(where: { dataItem in
                inventoryIngredient.ingredientName == dataItem.ingredient
            }) == false {
                let unit = UnitsOfMeasurement().convertStringToUnits(string: inventoryIngredient.baseUnit!)
                let newInventoryFinanceData = FinanceDataManager.InventoryCostData(ingredient: inventoryIngredient.ingredientName!, amount: 0, units: unit, unitCost: inventoryIngredient.cost, totalCost: 0)
                financeDataArray.append(newInventoryFinanceData)
            }
        }
        var total:Float = 0
        for dataItem in financeDataArray {
            total += dataItem.totalCost
        }
        totalIngredientValueLabel.text = StringConverter().convertCurrencyFloatToString(floatCurrency: total)
    }
    
    @IBAction func segmentedControlChanged(_ sender: UISegmentedControl) {
        sortFinanceArray()
    }
    
    @IBAction func startDatePickerChanged(_ sender: UIDatePicker) {
        loadInventoryFinanceData()
        sortFinanceArray()
    }
    
    @IBAction func endDatePickerChanged(_ sender: UIDatePicker) {
        loadInventoryFinanceData()
        sortFinanceArray()
    }
    
    //MARK: CoreData CRUD Methods
    
    func loadIngredients() {
        let request: NSFetchRequest<Inventory> = Inventory.fetchRequest()
        do {
            inventoryList = try K.inventoryIngredientContext.fetch(request)
        } catch {
            print("Error loading Prayer Requests: \(error)")
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
            self.inventoryCostsTableView.reloadData()
        }
    }
}

//MARK: TableView DataSource Methods

extension InventoryCostsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        financeDataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = inventoryCostsTableView.dequeueReusableCell(withIdentifier: K.inventoryCostReuseIdentifier, for: indexPath) as! InventoryCostTableViewCell
        
        let ingredient = financeDataArray[indexPath.row]
        cell.ingredientLabel.text = ingredient.ingredient
        cell.amountUsedLabel.text = ingredient.amountUsed
        cell.unitCostLabel.text = StringConverter().convertCurrencyFloatToString(floatCurrency: ingredient.unitCost)
        cell.totalCostLabel.text = StringConverter().convertCurrencyFloatToString(floatCurrency: ingredient.totalCost)
        
        return cell
    }
}
