//
//  InventoryViewController.swift
//  Home Bake Shop Assistant
//
//  Created by Brett Buchholz on 1/17/24.
//

import UIKit
import CoreData

class EditInventoryViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var ingredientStackView: UIStackView!
    @IBOutlet weak var standardUnitsStackView: UIStackView!
    @IBOutlet weak var costStackView: UIStackView!
    @IBOutlet weak var onHandView: UIView!
    
    @IBOutlet weak var ingredientTextField: UITextField!
    @IBOutlet weak var standardUnitsPopupButton: UIButton!
    @IBOutlet weak var costCurrencyField: CurrencyField!
    @IBOutlet weak var currentAmountLabel: PaddingLabel!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var measuredUnitsPopupButton: UIButton!
    @IBOutlet weak var updatedAmountLabel: PaddingLabel!
    @IBOutlet weak var updateButton: BrettButton!
    @IBOutlet weak var deleteButton: BrettButton!
    @IBOutlet weak var saveButton: BrettButton!
    
    var loadedInventoryIngredient: Inventory? = nil
    var selectedStandardUnit: UnitsOfMeasurement.Units? = nil
    var selectedMeasuredUnit: UnitsOfMeasurement.Units? = nil
    var convertedAmount:Float = 0.00
    var updateOnHandAmount: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Style The View
        AddBorders().addAllBorders(with: K.bakeShopBrown, andWidth: 2.0, view: ingredientStackView)
        AddBorders().addAllBorders(with: K.bakeShopBrown, andWidth: 2.0, view: standardUnitsStackView)
        AddBorders().addAllBorders(with: K.bakeShopBrown, andWidth: 2.0, view: costStackView)
        AddBorders().addAllBorders(with: K.bakeShopBrown, andWidth: 2.0, view: onHandView)
        updatedAmountLabel.text = "Updated Amount"
        updatedAmountLabel.textColor = K.bakeShopBrown
        updatedAmountLabel.isHidden = true
        updateButton.tintColor = K.bakeShopBrown
        deleteButton.tintColor = K.bakeShopDeleteRed
        saveButton.tintColor = K.bakeShopBrown
        
        //Register delegates, data sources and Nibs
        amountTextField.delegate = self
        selectedStandardUnit = UnitsOfMeasurement().convertStringToUnits(string: loadedInventoryIngredient!.baseUnit!)
        setupStandardUnitsButtons()
        setupMeasuredUnitsButtons()
        loadTextFields()
    }
    
    func setupStandardUnitsButtons() {
        var chirren: [UIMenuElement] = []
        chirren.append(UIAction(title: (loadedInventoryIngredient!.baseUnit)!) { (action: UIAction) in
            self.selectedStandardUnit = UnitsOfMeasurement().convertStringToUnits(string: self.loadedInventoryIngredient!.baseUnit!)
        })
        for unit in UnitsOfMeasurement.Units.allCases {
            let currentUnit: UnitsOfMeasurement.Units = unit
            var stringUnit = ""
            if unit == UnitsOfMeasurement.Units.Whole || unit == UnitsOfMeasurement.Units.None {
                stringUnit = UnitsOfMeasurement().convertUnitsToString(unit: unit)
            } else {
                stringUnit = "\(UnitsOfMeasurement().convertUnitsToString(unit: unit))s"
            }
            chirren.append(UIAction(title: stringUnit) { (action: UIAction) in
                self.selectedStandardUnit = currentUnit
            })
        }
        standardUnitsPopupButton.menu = UIMenu(children: chirren)
    }
    
    func setupMeasuredUnitsButtons() {
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
        measuredUnitsPopupButton.menu = UIMenu(children: chirren)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newString = (amountTextField.text! as NSString).replacingCharacters(in: range, with: string)
        let decimalRegex = try! NSRegularExpression(pattern: "^\\d*\\.?\\d{0,2}$", options: [])
        let matches = decimalRegex.matches(in: newString, options: [], range: NSMakeRange(0, newString.count))
        if matches.count == 1 {
            return true
        }
        return false
    }
    
    func loadTextFields() {
        if loadedInventoryIngredient != nil {
            ingredientTextField.text = loadedInventoryIngredient!.ingredientName
            costCurrencyField.text = StringConverter().convertCurrencyFloatToString(floatCurrency: loadedInventoryIngredient!.cost)
            let stringAmount = StringConverter().convertInventoryFloatToString(inventoryFloat: loadedInventoryIngredient!.amountOnHand)
            if loadedInventoryIngredient?.baseUnit == "Whole" {
                currentAmountLabel.text = "Currently, there are \(stringAmount) \(loadedInventoryIngredient!.ingredientName!)s on hand"
            } else {
                currentAmountLabel.text = "Currently, there are \(stringAmount) \(loadedInventoryIngredient!.baseUnit!) of \(loadedInventoryIngredient!.ingredientName!) on hand"
            }
            if loadedInventoryIngredient?.baseUnit == "Whole" {
                updatedAmountLabel.text = "Currently, there are \(loadedInventoryIngredient!.amountOnHand) \(loadedInventoryIngredient!.ingredientName!)s on hand"
            } else {
                updatedAmountLabel.text = "Currently, there are \(loadedInventoryIngredient!.amountOnHand) \(loadedInventoryIngredient!.baseUnit!) of \(loadedInventoryIngredient!.ingredientName!) on hand"
            }
        }
    }
    
    func ableToConvert() -> Bool {
        if selectedStandardUnit == .Whole && selectedMeasuredUnit != .Whole {
            return false
        } else if selectedMeasuredUnit == .Whole && selectedStandardUnit != .Whole {
            return false
        } else if selectedStandardUnit == .Gram {
            if selectedMeasuredUnit == .Gram {
                return true
            } else if selectedMeasuredUnit == .Kilogram {
                return true
            } else {
                return false
            }
        } else if selectedMeasuredUnit == .Gram {
            if selectedStandardUnit == .Gram {
                return true
            } else if selectedStandardUnit == .Kilogram {
                return true
            } else {
                return false
            }
        } else if selectedStandardUnit == .Kilogram {
            if selectedMeasuredUnit == .Gram {
                return true
            } else if selectedMeasuredUnit == .Kilogram {
                return true
            } else {
                return false
            }
        } else if selectedMeasuredUnit == .Kilogram {
            if selectedStandardUnit == .Gram {
                return true
            } else if selectedStandardUnit == .Kilogram {
                return true
            } else {
                return false
            }
        } else {
            return true
        }
    }
    
    @IBAction func updateButtonPressed(_ sender: BrettButton) {
        updatedAmountLabel.isHidden = true
        updatedAmountLabel.textColor = K.bakeShopBrown
        
        //Validate the data then get updated amount
        if amountTextField.text == "" {
            updatedAmountLabel.isHidden = false
            updatedAmountLabel.textColor = K.bakeShopDeleteRed
            updatedAmountLabel.text = "Please enter an amount to update"
        } else if selectedMeasuredUnit == .None || selectedMeasuredUnit == nil {
            updatedAmountLabel.isHidden = false
            updatedAmountLabel.textColor = K.bakeShopDeleteRed
            updatedAmountLabel.text = "Please select the measured units"
        } else if ableToConvert() == false {
            updatedAmountLabel.isHidden = false
            updatedAmountLabel.textColor = K.bakeShopDeleteRed
            updatedAmountLabel.text = "Unable to convert \(selectedMeasuredUnit!)s to \(selectedStandardUnit!)s!"
        } else {
            updatedAmountLabel.isHidden = false
            let floatAmount = StringConverter().convertInventoryStringToFloat(inventoryString: amountTextField.text ?? "0")
            convertedAmount = UnitsConverter(amount: floatAmount, measuredUnits: selectedMeasuredUnit!, standardUnits: selectedStandardUnit!).convertUnits()
            let stringAmount = StringConverter().convertInventoryFloatToString(inventoryFloat: convertedAmount)
            updatedAmountLabel.text = "Once saved, amount on hand will be updated to \(stringAmount) \(selectedStandardUnit!)s"
            updateOnHandAmount = true
        }
    }
    
    @IBAction func deleteButtonPressed(_ sender: BrettButton) {
        K.inventoryIngredientContext.delete(loadedInventoryIngredient!)
        saveInventoryIngredients()
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveButtonPressed(_ sender: BrettButton) {
        updatedAmountLabel.isHidden = true
        updatedAmountLabel.textColor = K.bakeShopBrown
        
        //Validate the data then save the context
        if ingredientTextField.text == "" {
            updatedAmountLabel.isHidden = false
            updatedAmountLabel.textColor = K.bakeShopDeleteRed
            updatedAmountLabel.text = "Please enter a name for the Ingredient"
        } else if selectedStandardUnit == .None {
            updatedAmountLabel.isHidden = false
            updatedAmountLabel.textColor = K.bakeShopDeleteRed
            updatedAmountLabel.text = "Please select a Standard Unit"
        } else if updateOnHandAmount == true && amountTextField.text == "" {
            updatedAmountLabel.isHidden = false
            updatedAmountLabel.textColor = K.bakeShopDeleteRed
            updatedAmountLabel.text = "Please enter an amount to update"
        } else if updateOnHandAmount == true && (selectedMeasuredUnit == .None || selectedMeasuredUnit == nil) {
            updatedAmountLabel.isHidden = false
            updatedAmountLabel.textColor = K.bakeShopDeleteRed
            updatedAmountLabel.text = "Please select the measured units"
        } else {
            loadedInventoryIngredient?.ingredientName = ingredientTextField.text?.capitalized
            loadedInventoryIngredient?.baseUnit = standardUnitsPopupButton.titleLabel?.text
            loadedInventoryIngredient?.cost = StringConverter().convertCurrencyStringToFloat(stringCurrency: costCurrencyField.text ?? "0.00")
            if updateOnHandAmount == true {
                loadedInventoryIngredient?.amountOnHand = convertedAmount
            }
            saveInventoryIngredients()
            navigationController?.popViewController(animated: true)
        }
    }
    
    //MARK: CoreData CRUD Methods
    
    func saveInventoryIngredients() {
        do {
            try K.inventoryIngredientContext.save()
        } catch {
            print("Error saving Prayer Rquests: \(error)")
        }
    }
    
}
