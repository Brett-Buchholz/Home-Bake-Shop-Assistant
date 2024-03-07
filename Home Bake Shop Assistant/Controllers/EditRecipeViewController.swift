//
//  EditRecipeViewController.swift
//  Home Bake Shop Assistant
//
//  Created by Brett Buchholz on 11/8/23.
//

import UIKit
import CoreData
import SwipeCellKit

class EditRecipeViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var ingredientsTableView: UITableView!
    @IBOutlet weak var ingredientPopUpButton: UIButton!
    @IBOutlet weak var unitsPopUpButton: UIButton!
    @IBOutlet weak var quantityIntegerTextField: UITextField!
    @IBOutlet weak var fractionPickerView: UIPickerView!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var noteTextField: UITextField!
    @IBOutlet weak var recipeNameTextField: UITextField!
    @IBOutlet weak var directionsTextView: UITextView!
    @IBOutlet weak var saveButton: BrettButton!
    @IBOutlet weak var addButton: BrettButton!
    @IBOutlet weak var ingredientsView: UIView!
    @IBOutlet weak var directionsView: UIView!
    @IBOutlet weak var addNewView: UIView!
    @IBOutlet weak var batchSizeTextField: UITextField!
    @IBOutlet weak var batchPriceTextField: CurrencyField!
    @IBOutlet weak var priceDozenCurrencyField: CurrencyField!
    @IBOutlet weak var priceHalfDozenCurrencyField: CurrencyField!
    @IBOutlet weak var priceSingleCurrencyField: CurrencyField!
    
    var newRecipe: Recipe? = nil
    var loadedRecipe: Recipe? = nil
    var selectedUnits: UnitsOfMeasurement.Units? = nil
    var selectedIngredient: Inventory? = nil
    var inventoryList: [Inventory] = []
    var tempIngredientList: [RecipeIngredient] = []
    var pickerValue: String = ""
    var selectedIndexPath: IndexPath? = nil
    var pickerAsFloat: Float = 0
    var recipeList: [Recipe] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Style The View
        AddBorders().addTopBorder(with: K.bakeShopMaroon, andWidth: 2.0, view: ingredientsView)
        AddBorders().addLeftBorder(with: K.bakeShopMaroon, andWidth: 2.0, view: ingredientsView)
        AddBorders().addRightBorder(with: K.bakeShopMaroon, andWidth: 2.0, view: ingredientsView)
        AddBorders().addLeftBorder(with: K.bakeShopMaroon, andWidth: 2.0, view: addNewView)
        AddBorders().addRightBorder(with: K.bakeShopMaroon, andWidth: 2.0, view: addNewView)
        AddBorders().addLeftBorder(with: K.bakeShopMaroon, andWidth: 2.0, view: directionsView)
        AddBorders().addRightBorder(with: K.bakeShopMaroon, andWidth: 2.0, view: directionsView)
        AddBorders().addBottomBorder(with: K.bakeShopMaroon, andWidth: 2.0, view: directionsView)
        saveButton.tintColor = K.bakeShopMaroon
        addButton.tintColor = K.bakeShopMaroon
        errorLabel.isHidden = true
        
        //Register delegates, data sources and Nibs
        quantityIntegerTextField.delegate = self
        batchSizeTextField.delegate = self
        fractionPickerView.dataSource = self
        fractionPickerView.delegate = self
        ingredientsTableView.dataSource = self
        ingredientsTableView.delegate = self
        ingredientsTableView.register(UINib(nibName: K.recipeCellNibName, bundle: nil), forCellReuseIdentifier: K.recipeReuseIdentifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if loadedRecipe != nil {
            newRecipe = loadedRecipe!
            recipeNameTextField.text = loadedRecipe!.name
            directionsTextView.text = loadedRecipe!.directions
            batchSizeTextField.text = "\(loadedRecipe!.batchSize)"
            batchPriceTextField.text = StringConverter().convertCurrencyFloatToString(floatCurrency: loadedRecipe!.batchPrice)
            priceSingleCurrencyField.text = StringConverter().convertCurrencyFloatToString(floatCurrency: loadedRecipe!.priceSingle)
            priceHalfDozenCurrencyField.text = StringConverter().convertCurrencyFloatToString(floatCurrency: loadedRecipe!.priceHalfDozen)
            priceDozenCurrencyField.text = StringConverter().convertCurrencyFloatToString(floatCurrency: loadedRecipe!.priceDozen)
        } else {
            batchPriceTextField.text = ""
            priceSingleCurrencyField.text = ""
            priceHalfDozenCurrencyField.text = ""
            priceDozenCurrencyField.text = ""
        }
        loadIngredients()
        loadRecipes()
        setupIngredientButton()
        setupUnitsTypeButton()
        updateData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkAvailability()
    }
    
    func checkAvailability() {
        if AvailabilityManager().giveFullAccess() == false {
            let alert = UIAlertController(title: "", message: "Unsubscribed users are limited to 2 recipes. Subscribed users have full access to all features.", preferredStyle: .alert)
            let action = UIAlertAction(title: "Dismiss", style: .default) { action in
                //Dismiss
            }
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        }
    }
    
    func setupIngredientButton() {
        var chirren: [UIMenuElement] = []
        let closure = { (action: UIAction) in
            //print(action)
        }
        chirren.append(UIAction(title: "", handler: closure))
        inventoryList = inventoryList.sorted {$0.ingredientName! < $1.ingredientName!}
        for ingredient in inventoryList {
            chirren.append(UIAction(title: "\(ingredient.ingredientName ?? "unknown name")") { action in
                self.selectedIngredient = ingredient
                self.selectedUnits = UnitsOfMeasurement().convertStringToUnits(string: (self.selectedIngredient?.baseUnit)!)
                self.setupUnitsTypeButton()
            })
        }
        ingredientPopUpButton.menu = UIMenu(children: chirren)
    }
    
    func setupUnitsTypeButton() {
        var chirren: [UIMenuElement] = []
        var myTitle = ""
        if selectedIngredient != nil {
            let unit = UnitsOfMeasurement().convertStringToUnits(string: (selectedIngredient?.baseUnit)!)
            if unit == .None {
                myTitle = ""
            } else if unit == .Whole {
                myTitle = "\(unit)"
            } else {
                myTitle = "\(unit)s"
            }
            chirren.append(UIAction(title: myTitle) { (action: UIAction) in
                self.selectedUnits = unit
            })
        }
        for unit in UnitsOfMeasurement.Units.allCases {
            if unit == .None {
                myTitle = ""
            } else if unit == .Whole {
                myTitle = "\(unit)"
            } else {
                myTitle = "\(unit)s"
            }
            chirren.append(UIAction(title: myTitle) { (action: UIAction) in
                self.selectedUnits = unit
            })
        }
        unitsPopUpButton.menu = UIMenu(children: chirren)
    }
    
    func ableToConvert() -> Bool {
        if selectedIngredient == nil {
            return false
        }
        let selectedStandardUnit = UnitsOfMeasurement().convertStringToUnits(string: (selectedIngredient?.baseUnit)!)
        let selectedMeasuredUnit = selectedUnits
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
    
    func addTopBorder(with color: UIColor?, andWidth borderWidth: CGFloat, view: UIView) {
        let border = UIView()
        border.backgroundColor = color
        border.autoresizingMask = [.flexibleWidth, .flexibleBottomMargin]
        border.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: borderWidth)
        view.addSubview(border)
    }

    func addBottomBorder(with color: UIColor?, andWidth borderWidth: CGFloat, view: UIView) {
        let border = UIView()
        border.backgroundColor = color
        border.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
        border.frame = CGRect(x: 0, y: view.frame.size.height - borderWidth, width: view.frame.size.width, height: borderWidth)
        view.addSubview(border)
    }

    func addLeftBorder(with color: UIColor?, andWidth borderWidth: CGFloat, view: UIView) {
        let border = UIView()
        border.backgroundColor = color
        border.frame = CGRect(x: 0, y: 0, width: borderWidth, height: view.frame.size.height)
        border.autoresizingMask = [.flexibleHeight, .flexibleRightMargin]
        view.addSubview(border)
    }

    func addRightBorder(with color: UIColor?, andWidth borderWidth: CGFloat, view: UIView) {
        let border = UIView()
        border.backgroundColor = color
        border.autoresizingMask = [.flexibleHeight, .flexibleLeftMargin]
        border.frame = CGRect(x: view.frame.size.width - borderWidth, y: 0, width: borderWidth, height: view.frame.size.height)
        view.addSubview(border)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        return allowedCharacters.isSuperset(of: characterSet)
    }
    
    @IBAction func addButtonPressed(_ sender: BrettButton) {
        errorLabel.isHidden = true
        validData()
    }
    
    func validData() {
        var recipeIngredient = ""
        var inventoryIngredient: Inventory? = nil
        var units = ""
        var quantityWhole = ""
        var quantityPicker = ""
        var quantity = ""
        var note = ""
        var floatQuantity: Float = 0
        
        //Create quantity
        if quantityIntegerTextField.text == "" {
            quantityIntegerTextField.text = "0"
        }
        if Int(quantityIntegerTextField.text!) == nil {
            errorLabel.isHidden = false
            errorLabel.text = "Invalid Quantity"
        } else if quantityIntegerTextField.text == "0" && pickerValue == "" {
            errorLabel.isHidden = false
            errorLabel.text = "Please add a quantity"
        } else if pickerValue == "" {
            quantityWhole = quantityIntegerTextField.text!
            quantity = quantityIntegerTextField.text!
        } else if quantityIntegerTextField.text! == "0" {
            quantityPicker = pickerValue
            quantity = pickerValue
        } else {
            quantityWhole = quantityIntegerTextField.text!
            quantityPicker = pickerValue
            quantity = "\(quantityWhole) \(quantityPicker)"
        }
        
        //Create a float quantity
        pickerAsFloat = StringConverter().convertFractionStringToFloat(stringValue: quantityPicker)
        floatQuantity = (Float(quantityWhole) ?? 0) + (pickerAsFloat)
        
        // Create Units of Measurment
        if unitsPopUpButton.titleLabel?.text == nil {
            errorLabel.isHidden = false
            errorLabel.text = "Please choose units of measurment"
        } else if quantityIntegerTextField.text! == "0" || quantityIntegerTextField.text! == "1" && pickerValue == ""{
            units = UnitsOfMeasurement().convertUnitsToString(unit: selectedUnits!)
        } else {
            units = "\(UnitsOfMeasurement().convertUnitsToString(unit: selectedUnits!))s"
        }
        
        //Create an inventory ingredient
        for ingredient in inventoryList {
            if ingredientPopUpButton.titleLabel?.text == ingredient.ingredientName {
                inventoryIngredient = ingredient
            }
        }
        
        //Create a recipe ingredient
        if ingredientPopUpButton.titleLabel?.text == nil {
            errorLabel.isHidden = false
            errorLabel.text = "Please choose an ingredient"
        } else if unitsPopUpButton.titleLabel?.text == nil {
            errorLabel.isHidden = false
            errorLabel.text = "Please choose units of measurment"
        } else if unitsPopUpButton.titleLabel!.text! == "Whole" && quantityIntegerTextField.text != "1" && quantityIntegerTextField.text != "0" {
            recipeIngredient = "\(ingredientPopUpButton.titleLabel!.text!)s"
            units = unitsPopUpButton.titleLabel!.text!
        } else {
            recipeIngredient = ingredientPopUpButton.titleLabel!.text!
        }
        
        //Create note
        if noteTextField.text != "" {
            note = " (Note: \(noteTextField.text!))"
        }
        
        //Check that units of measurment don't conflict
        if ableToConvert() == false {
            if selectedIngredient != nil {
                let selected = UnitsOfMeasurement().convertUnitsToString(unit: selectedUnits!)
                let standard = selectedIngredient?.baseUnit
                errorLabel.isHidden = false
                errorLabel.text = "\(selected)s are not compatible with the standard unit of \(standard!)"
            }
        }
        
        //Add ingredient to recipe
        if quantity != "" {
            if units != "" {
                if ableToConvert() == true {
                    if recipeIngredient != "" {
                        let newIngredient = RecipeIngredient(context: K.recipeContext)
                        newIngredient.inventory = inventoryIngredient
                        newIngredient.name = recipeIngredient
                        newIngredient.units = units
                        newIngredient.quantity = floatQuantity
                        if newIngredient.units == "Whole" {
                            newIngredient.stringName = "\(quantity) \(recipeIngredient) \(note)"
                        } else {
                            newIngredient.stringName = "\(quantity) \(units) of \(recipeIngredient)\(note)"
                        }
                        tempIngredientList.append(newIngredient)
                        quantityIntegerTextField.text = ""
                        noteTextField.text = ""
                        setupIngredientButton()
                        ingredientPopUpButton.titleLabel?.text = nil
                        selectedIngredient = nil
                        setupUnitsTypeButton()
                        unitsPopUpButton.titleLabel?.text = nil
                        pickerValue = ""
                        fractionPickerView.selectRow(0, inComponent: 0, animated: true)
                        updateData()
                        quantityIntegerTextField.resignFirstResponder()
                        noteTextField.resignFirstResponder()
                    }
                }
            }
        }
    }
    
    @IBAction func saveRecipePressed(_ sender: BrettButton) {
        errorLabel.isHidden = true
        if recipeNameTextField.text == "" {
            errorLabel.isHidden = false
            errorLabel.text = "Please add a Recipe Name"
        } else if directionsTextView.text == "" {
            errorLabel.isHidden = false
            errorLabel.text = "Please add directions to this recipe"
        } else if batchSizeTextField.text == "" || batchSizeTextField.text == "0" {
            errorLabel.isHidden = false
            errorLabel.text = "Please provide a batch size for this recipe"
        } else if AvailabilityManager().giveFullAccess() == false && newRecipe == nil && recipeList.count >= 2 {
            let alert = UIAlertController(title: "", message: "You cannot add a new recipe. Unsubscribed users are limited to 2 recipes. Subscribed users have full access to all features.", preferredStyle: .alert)
            let action = UIAlertAction(title: "Dismiss", style: .default) { action in
                //Dismiss
            }
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        } else {
            if newRecipe == nil {
                newRecipe = Recipe(context: K.recipeContext)
            }
            newRecipe!.name = recipeNameTextField.text
            newRecipe!.directions = directionsTextView.text
            let intBatchSize = Int16(batchSizeTextField.text!)!
            newRecipe!.batchSize = intBatchSize
            if batchPriceTextField.text == "" {
                newRecipe!.batchPrice = Float(0.00)
            } else {
                newRecipe!.batchPrice = StringConverter().convertCurrencyStringToFloat(stringCurrency: batchPriceTextField.text!)
            }
            if priceDozenCurrencyField.text == "" {
                newRecipe!.priceDozen = Float(0.00)
            } else {
                newRecipe!.priceDozen = StringConverter().convertCurrencyStringToFloat(stringCurrency: priceDozenCurrencyField.text!)
            }
            if priceHalfDozenCurrencyField.text == "" {
                newRecipe!.priceHalfDozen = Float(0.00)
            } else {
                newRecipe!.priceHalfDozen = StringConverter().convertCurrencyStringToFloat(stringCurrency: priceHalfDozenCurrencyField.text!)
            }
            if priceSingleCurrencyField.text == "" {
                newRecipe!.priceSingle = Float(0.00)
            } else {
                newRecipe!.priceSingle = StringConverter().convertCurrencyStringToFloat(stringCurrency: priceSingleCurrencyField.text!)
            }
            for ingredient in tempIngredientList {
                ingredient.addToRecipe(newRecipe!)
            }
            saveRecipe()
            navigationController?.popToViewController((navigationController?.viewControllers[1])!, animated: true)
        }
    }
    
    //MARK: CoreData CRUD Methods
    
    func saveRecipe() {
        do {
            try K.recipeContext.save()
        } catch {
            print("Error saving Ingredients: \(error)")
        }
    }
    
    func loadRecipes() {
        let request: NSFetchRequest<Recipe> = Recipe.fetchRequest()
        do {
            recipeList = try K.recipeContext.fetch(request)
        } catch {
            print("Error loading Recipe: \(error)")
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
            self.tempIngredientList = self.tempIngredientList.sorted {$0.name! < $1.name!}
            self.ingredientsTableView.reloadData()
        }
    }
    
}

//MARK: TableView DataSource Methods

extension EditRecipeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tempIngredientList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ingredientsTableView.dequeueReusableCell(withIdentifier: K.recipeReuseIdentifier, for: indexPath) as! RecipeTableViewCell
        cell.delegate = self
        cell.recipeIngredientLabel.text = "\(tempIngredientList[indexPath.row].stringName!)"
        tempIngredientList = tempIngredientList.sorted {$0.name! < $1.name!}
        
        return cell
    }
}

extension EditRecipeViewController: UITableViewDelegate {
    
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

extension EditRecipeViewController: SwipeTableViewCellDelegate {
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title:.none) { action, indexPath in
            self.updateData()
            if self.newRecipe != nil {
                let mySet = self.newRecipe?.toRecipeIngredient as! Set<RecipeIngredient>
                let mySelection = (self.tempIngredientList[indexPath.row])
                if mySet.contains(mySelection) == true {
                    K.recipeContext.delete(mySelection)
                }
            }
            self.tempIngredientList.remove(at: indexPath.row)
            self.updateData()
        }
        
        // customize the action appearance
        deleteAction.image = UIImage(named: "delete-icon")
        
        return [deleteAction]
    }
}

//MARK: PickerView DataSource and Delegate Methods
extension EditRecipeViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return K.fractionalMeasurements.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return K.fractionalMeasurements[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickerValue = K.fractionalMeasurements[row]
    }
}

