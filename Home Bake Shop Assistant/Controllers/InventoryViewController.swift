//
//  AddIngredientViewController.swift
//  Home Bake Shop Assistant
//
//  Created by Brett Buchholz on 11/8/23.
//

import UIKit
import CoreData

class InventoryViewController: UIViewController {
    
    @IBOutlet weak var ingredientsTableView: UITableView!
    @IBOutlet weak var ingredientNameTextField: UITextField!
    @IBOutlet weak var unitsPopUpButton: UIButton!
    @IBOutlet weak var addIngredientButton: BrettButton!
    @IBOutlet weak var ingredientTitleLabel: PaddingLabel!
    @IBOutlet weak var headerStackView: UIStackView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var quickAddButton: BrettButton!
    
    var inventoryList: [Inventory] = []
    var ordersList: [Order] = []
    var segueInventoryIngredient: Inventory? = nil
    var selectedStandardUnit: UnitsOfMeasurement.Units = .None
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Style The View
        ingredientTitleLabel.clipsToBounds = true
        AddBorders().addAllBorders(with: K.bakeShopBrown, andWidth: 2.0, view: ingredientTitleLabel)
        AddBorders().addAllBorders(with: K.bakeShopBrown, andWidth: 4.0, view: headerStackView)
        AddBorders().addLeftBorder(with: K.bakeShopBrown, andWidth: 4.0, view: ingredientsTableView)
        AddBorders().addRightBorder(with: K.bakeShopBrown, andWidth: 4.0, view: ingredientsTableView)
        AddBorders().addAllBorders(with: K.bakeShopBrown, andWidth: 4.0, view: bottomView)
        AddBorders().addBottomBorder(with: K.bakeShopBrown, andWidth: 4.0, view: quickAddButton)
        addIngredientButton.tintColor = K.bakeShopBrown
        ingredientsTableView.rowHeight = 50
        
        //Register delegates, data sources and Nibs
        ingredientsTableView.dataSource = self
        ingredientsTableView.delegate = self
        ingredientsTableView.register(UINib(nibName: K.ingredientCellNibName, bundle: nil), forCellReuseIdentifier: K.ingredientReuseIdentifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        errorLabel.isHidden = true
        setupUnitsTypeButton()
        updateDataAndView()
        inventoryList = inventoryList.sorted {$0.ingredientName! < $1.ingredientName!}
        getAmountNeeded()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.segueIdentifierToEditInventory {
            let destinationVC = segue.destination as! EditInventoryViewController
            destinationVC.loadedInventoryIngredient = segueInventoryIngredient
        }
    }
    
    func setupUnitsTypeButton() {
        var chirren: [UIMenuElement] = []
        for unit in UnitsOfMeasurement.Units.allCases {
            var myTitle = ""
            if unit == .None {
                myTitle = ""
            } else if unit == .Whole {
                myTitle = "\(unit)"
            } else {
                myTitle = "\(unit)s"
            }
            chirren.append(UIAction(title: myTitle) { (action: UIAction) in
                self.selectedStandardUnit = unit
            })
        }
        unitsPopUpButton.menu = UIMenu(children: chirren)
    }
    
    func getAmountNeeded() {
        loadOrders()
        var orderedItemsList: [OrderedItem] = []
        for item in inventoryList {
            item.amountNeeded = Float(0.00)
        }
        for order in ordersList {
            if order.orderComplete == false {
                for item in (order.toOrderedItem?.allObjects as! [OrderedItem]) {
                    orderedItemsList.append(item)
                }
            }
        }
        for item in orderedItemsList {
            for ingredient in (item.toRecipe?.toRecipeIngredient?.allObjects as! [RecipeIngredient]){
                let measuredUnits:UnitsOfMeasurement.Units = UnitsOfMeasurement().convertStringToUnits(string: ingredient.units!)
                let standardUnits:UnitsOfMeasurement.Units = UnitsOfMeasurement().convertStringToUnits(string: (ingredient.inventory?.baseUnit)!)
                let floatQuantity = Float(item.quantityOrdered) * ingredient.quantity
                let neededAmount = UnitsConverter(amount: floatQuantity, measuredUnits: measuredUnits, standardUnits: standardUnits).convertUnits()
                ingredient.inventory?.amountNeeded = neededAmount
            }
        }
        saveIngredients()
    }
    
    @IBAction func addIngredientPressed(_ sender: BrettButton) {
        errorLabel.isHidden = true
        if ingredientNameTextField.text == "" {
            errorLabel.isHidden = false
            errorLabel.text = "Please type an ingredient name!"
        } else if selectedStandardUnit == .None {
            errorLabel.isHidden = false
            errorLabel.text = "Please select a standard unit!"
        } else {
            let newIngredient = Inventory(context: K.inventoryIngredientContext)
            newIngredient.ingredientName = (ingredientNameTextField.text)!.capitalized
            newIngredient.baseUnit = unitsPopUpButton.titleLabel?.text
            updateDataAndView()
            ingredientNameTextField.text = ""
            unitsPopUpButton.titleLabel?.text = nil
            selectedStandardUnit = .None
            setupUnitsTypeButton()
        }
    }
    
    //MARK: CoreData CRUD Methods
    
    func saveIngredients() {
        do {
            try K.inventoryIngredientContext.save()
        } catch {
            print("Error saving Prayer Rquests: \(error)")
        }
    }
    
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
    
    func updateDataAndView() {
        saveIngredients()
        loadIngredients()
        DispatchQueue.main.async {
            self.inventoryList = self.inventoryList.sorted {$0.ingredientName! < $1.ingredientName!}
            self.ingredientsTableView.reloadData()
        }
    }
}

//MARK: TableView DataSource Methods

extension InventoryViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        inventoryList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ingredientsTableView.dequeueReusableCell(withIdentifier: K.ingredientReuseIdentifier, for: indexPath) as! IngredientTableViewCell
        cell.ingredientLabel.text = inventoryList[indexPath.row].ingredientName
        cell.unitsLabel.text = inventoryList[indexPath.row].baseUnit
        cell.onHandLabel.text = "\(inventoryList[indexPath.row].amountOnHand)"
        cell.neededLabel.text = "\(inventoryList[indexPath.row].amountNeeded)"
        inventoryList = inventoryList.sorted {$0.ingredientName! < $1.ingredientName!}
        
        return cell
    }
    
}

extension InventoryViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        segueInventoryIngredient = inventoryList[indexPath.row]
        performSegue(withIdentifier: K.segueIdentifierToEditInventory, sender: self)
    }
}

