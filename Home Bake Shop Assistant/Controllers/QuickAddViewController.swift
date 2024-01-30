//
//  QuickAddViewController.swift
//  Home Bake Shop Assistant
//
//  Created by Brett Buchholz on 1/25/24.
//

import UIKit
import CoreData
import SwipeCellKit

class QuickAddViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var headerStackView: UIStackView!
    @IBOutlet weak var quickAddTableView: UITableView!
    @IBOutlet weak var bottomView: UIView!
    
    @IBOutlet weak var ingredientPopUpButton: UIButton!
    @IBOutlet weak var amountAddedTextField: UITextField!
    @IBOutlet weak var unitsAddedPopup: UIButton!
    @IBOutlet weak var costCurrencyField: CurrencyField!
    @IBOutlet weak var errorLabel: PaddingLabel!
    @IBOutlet weak var addButton: BrettButton!
    @IBOutlet weak var saveButton: BrettButton!
    
    var inventoryList: [Inventory] = []
    var tempUpdateList: [[String:Any]] = []
    var selectedIngredient: Inventory? = nil
    var selectedMeasuredUnit: UnitsOfMeasurement.Units? = nil
    var standardUnit: UnitsOfMeasurement.Units? = nil
    var selectedIndexPath: IndexPath? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Style The View
        AddBorders().addAllBorders(with: K.bakeShopBrown, andWidth: 4.0, view: headerStackView)
        AddBorders().addLeftBorder(with: K.bakeShopBrown, andWidth: 4.0, view: quickAddTableView)
        AddBorders().addRightBorder(with: K.bakeShopBrown, andWidth: 4.0, view: quickAddTableView)
        AddBorders().addAllBorders(with: K.bakeShopBrown, andWidth: 4.0, view: bottomView)
        addButton.tintColor = K.bakeShopBrown
        saveButton.tintColor = K.bakeShopBrown
        quickAddTableView.rowHeight = 50.0
        
        //Register delegates, data sources and Nibs
        amountAddedTextField.delegate = self
        quickAddTableView.dataSource = self
        quickAddTableView.delegate = self
        quickAddTableView.register(UINib(nibName: K.quickAddCellNibName, bundle: nil), forCellReuseIdentifier: K.quickAddReuseIdentifier)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        errorLabel.isHidden = true
        costCurrencyField.text = ""
        costCurrencyField.placeholder = "$0.00"
        loadIngredients()
        setupIngredientButton()
        setupUnitsButtons()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newString = (amountAddedTextField.text! as NSString).replacingCharacters(in: range, with: string)
        let decimalRegex = try! NSRegularExpression(pattern: "^\\d*\\.?\\d{0,2}$", options: [])
        let matches = decimalRegex.matches(in: newString, options: [], range: NSMakeRange(0, newString.count))
        if matches.count == 1 {
            return true
        }
        return false
    }
    
    func setupIngredientButton() {
        var chirren: [UIMenuElement] = []
        chirren.append(UIAction(title: "") { (action: UIAction) in
            self.selectedIngredient = nil
        })
        inventoryList = inventoryList.sorted {$0.ingredientName! < $1.ingredientName!}
        for ingredient in inventoryList {
            chirren.append(UIAction(title: "\(ingredient.ingredientName ?? "unknown name")") { (action: UIAction) in
                self.selectedIngredient = ingredient
            })
        }
        ingredientPopUpButton.menu = UIMenu(children: chirren)
    }
    
    func setupUnitsButtons() {
        var chirren: [UIMenuElement] = []
        for unit in UnitsOfMeasurement.Units.allCases {
            let currentUnit: UnitsOfMeasurement.Units = unit
            var stringUnit = ""
            if unit == UnitsOfMeasurement.Units.Whole || unit == UnitsOfMeasurement.Units.None {
                stringUnit = UnitsOfMeasurement().convertUnitsToString(unit: unit)
            } else {
                stringUnit = "\(UnitsOfMeasurement().convertUnitsToString(unit: unit))s"
            }
            chirren.append(UIAction(title: stringUnit) { (action: UIAction) in
                self.selectedMeasuredUnit = currentUnit
            })
        }
        unitsAddedPopup.menu = UIMenu(children: chirren)
    }
    
    func ableToConvert() -> Bool {
        if standardUnit == .Whole && selectedMeasuredUnit != .Whole {
            return false
        } else if selectedMeasuredUnit == .Whole && standardUnit != .Whole {
            return false
        } else if standardUnit == .Gram {
            if selectedMeasuredUnit == .Gram {
                return true
            } else if selectedMeasuredUnit == .Kilogram {
                return true
            } else {
                return false
            }
        } else if selectedMeasuredUnit == .Gram {
            if standardUnit == .Gram {
                return true
            } else if standardUnit == .Kilogram {
                return true
            } else {
                return false
            }
        } else if standardUnit == .Kilogram {
            if selectedMeasuredUnit == .Gram {
                return true
            } else if selectedMeasuredUnit == .Kilogram {
                return true
            } else {
                return false
            }
        } else if selectedMeasuredUnit == .Kilogram {
            if standardUnit == .Gram {
                return true
            } else if standardUnit == .Kilogram {
                return true
            } else {
                return false
            }
        } else {
            return true
        }
    }
    
    @IBAction func addButtonPressed(_ sender: BrettButton) {
        errorLabel.isHidden = true
        standardUnit = UnitsOfMeasurement().convertStringToUnits(string: (selectedIngredient?.baseUnit)!)
        if selectedIngredient == nil {
            errorLabel.isHidden = false
            errorLabel.text = "Please select an ingredient!"
        } else if amountAddedTextField.text == "" {
            errorLabel.isHidden = false
            errorLabel.text = "Please provide an amount to add!"
        } else if selectedMeasuredUnit == nil {
            errorLabel.isHidden = false
            errorLabel.text = "Please select units of measurement!"
        } else if ableToConvert() == false {
            errorLabel.isHidden = false
            errorLabel.text = "Unable to convert \(selectedMeasuredUnit!)s to the standard unit of \(standardUnit!)s!"
        } else {
            var itemDict: Dictionary = [String:Any]()
            itemDict["Ingredient"] = selectedIngredient!
            itemDict["Name"] = selectedIngredient!.ingredientName
            itemDict["AmountAdded"] = amountAddedTextField.text
            itemDict["MeasuredUnits"] = selectedMeasuredUnit
            if costCurrencyField.text == "" {
                itemDict["TotalCost"] = "$0.00"
            } else {
                itemDict["TotalCost"] = costCurrencyField.text
            }
            tempUpdateList.append(itemDict)
            updateData()
            selectedIngredient = nil
            setupIngredientButton()
            amountAddedTextField.text = ""
            selectedMeasuredUnit = nil
            setupUnitsButtons()
            costCurrencyField.text = ""
            costCurrencyField.resignFirstResponder()
            amountAddedTextField.resignFirstResponder()
        }
        
    }
    
    @IBAction func saveButtonPressed(_ sender: BrettButton) {
        for item in tempUpdateList {
            let ingredientToSave:Inventory = item["Ingredient"] as! Inventory
            let floatAmount = StringConverter().convertInventoryStringToFloat(inventoryString: item["AmountAdded"] as! String)
            let myMeasuredUnits:UnitsOfMeasurement.Units = item["MeasuredUnits"] as! UnitsOfMeasurement.Units
            let myStandardUnits:UnitsOfMeasurement.Units = UnitsOfMeasurement().convertStringToUnits(string: ingredientToSave.baseUnit!)
            let totalCost:Float = StringConverter().convertCurrencyStringToFloat(stringCurrency: item["TotalCost"] as! String)
            let convertedAmount = UnitsConverter(amount: floatAmount, measuredUnits: myMeasuredUnits, standardUnits: myStandardUnits).convertUnits()
            let totalOnHandCost: Float = (ingredientToSave.amountOnHand * ingredientToSave.cost)
            ingredientToSave.amountOnHand += convertedAmount
            let updatedAmountOnHand = ingredientToSave.amountOnHand
            ingredientToSave.cost = (totalOnHandCost + totalCost)/updatedAmountOnHand
            saveIngredient()
        }
        navigationController?.popViewController(animated: true)
    }
    
    //MARK: CoreData CRUD Methods
    
    func saveIngredient() {
        do {
            try K.inventoryIngredientContext.save()
        } catch {
            print("Error saving Ingredients: \(error)")
        }
    }
    
    func loadIngredients() {
        let request: NSFetchRequest<Inventory> = Inventory.fetchRequest()
        do {
            inventoryList = try K.inventoryIngredientContext.fetch(request)
        } catch {
            print("Error loading Ingredients: \(error)")
        }
    }
    
    func updateData() {
        DispatchQueue.main.async {
            self.quickAddTableView.reloadData()
        }
    }
    
}

//MARK: TableView DataSource Methods

extension QuickAddViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tempUpdateList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = quickAddTableView.dequeueReusableCell(withIdentifier: K.quickAddReuseIdentifier, for: indexPath) as! QuickAddTableViewCell
        let amount = tempUpdateList[indexPath.row]["AmountAdded"]
        let units = tempUpdateList[indexPath.row]["MeasuredUnits"]
        if units as! UnitsOfMeasurement.Units == .Whole {
            if amount as! String == "1" {
                cell.ingredientLabel.text = "\(tempUpdateList[indexPath.row]["Name"]!)"
                cell.amountAddedLabel.text = "\(amount!)"
            } else {
                cell.ingredientLabel.text = "\(tempUpdateList[indexPath.row]["Name"]!)s"
                cell.amountAddedLabel.text = "\(amount!)"
            }
        } else {
            if amount as! String == "1" {
                cell.ingredientLabel.text = "\(tempUpdateList[indexPath.row]["Name"]!)"
                cell.amountAddedLabel.text = "\(amount!) \(units!)"
            } else {
                cell.ingredientLabel.text = "\(tempUpdateList[indexPath.row]["Name"]!)"
                cell.amountAddedLabel.text = "\(amount!) \(units!)s"
            }
        }
        cell.costLabel.text = "\(tempUpdateList[indexPath.row]["TotalCost"]!)"
        inventoryList = inventoryList.sorted {$0.ingredientName! < $1.ingredientName!}
        cell.delegate = self
        
        return cell
    }
    
}

extension QuickAddViewController: UITableViewDelegate {
    
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

extension QuickAddViewController: SwipeTableViewCellDelegate {
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title:.none) { action, indexPath in
            self.updateData()
            self.tempUpdateList.remove(at: indexPath.row)
            self.updateData()
        }
        
        // customize the action appearance
        deleteAction.image = UIImage(named: "delete-icon")
        
        return [deleteAction]
    }
}
