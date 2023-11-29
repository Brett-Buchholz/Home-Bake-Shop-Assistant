//
//  EditRecipeViewController.swift
//  Home Bake Shop Assistant
//
//  Created by Brett Buchholz on 11/8/23.
//

import UIKit
import CoreData
import SwipeCellKit

class EditRecipeViewController: UIViewController {
    
    @IBOutlet weak var ingredientsTableView: UITableView!
    @IBOutlet weak var ingredientPopUpButton: UIButton!
    @IBOutlet weak var unitsPopUpButton: UIButton!
    @IBOutlet weak var quantityIntegerTextField: UITextField!
    @IBOutlet weak var fractionPickerView: UIPickerView!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var noteTextField: UITextField!
    @IBOutlet weak var recipeNameTextField: UITextField!
    @IBOutlet weak var directionsTextView: UITextView!
    
    let newRecipe = Recipe(context: K.context)
    var ingredientList: [Ingredient] = []
    var recipeIngredients: [String] = []
    var pickerValue: String = ""
    var selectedIndexPath: IndexPath? = nil
    var pickerAsFloat: Float = 0
    var recipeSaved: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fractionPickerView.dataSource = self
        fractionPickerView.delegate = self
        errorLabel.isHidden = true
        
        ingredientsTableView.dataSource = self
        ingredientsTableView.delegate = self
        ingredientsTableView.register(UINib(nibName: "IngredientTableViewCell", bundle: nil), forCellReuseIdentifier: K.ingredientReuseIdentifier)
        loadIngredients()
        setupIngredientButton()
        setupUnitsTypeButton()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if recipeSaved == false {
            K.context.delete(newRecipe)
        }
    }
    
    
    func setupIngredientButton() {
        var chirren: [UIMenuElement] = []
        let closure = { (action: UIAction) in
            //print(action)
        }
        chirren.append(UIAction(title: "", handler: closure))
        for ingredient in ingredientList {
            chirren.append(UIAction(title: "\(ingredient.name ?? "unknown name")", handler: closure))
        }
        ingredientPopUpButton.menu = UIMenu(children: chirren)
    }
    
    func setupUnitsTypeButton() {
        var chirren: [UIMenuElement] = []
        let closure = { (action: UIAction) in
            //print(action)
        }
        for unit in K.unitsOfMeasurement {
            chirren.append(UIAction(title: "\(unit)", handler: closure))
        }
        unitsPopUpButton.menu = UIMenu(children: chirren)
    }
    
    @IBAction func addButtonPressed(_ sender: BrettButton) {
        errorLabel.isHidden = true
        validData()
        
    }
    
    func validData() {
        var ingredient = ""
        var units = ""
        var quantityWhole = ""
        var quantityPicker = ""
        var quantity = ""
        var note = ""
        var floatQuantity: Float = 0
        
        //Create quantity
        if quantityIntegerTextField.text == "" {
            quantityIntegerTextField.text = "0"
        } else if Int(quantityIntegerTextField.text!) == nil {
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
        convertPickerToFloat()
        floatQuantity = Float(quantityWhole) ?? 0 + pickerAsFloat
        
        // Create Units of Measurment
        if unitsPopUpButton.titleLabel?.text == nil {
            errorLabel.isHidden = false
            errorLabel.text = "Please choose units of measurment"
        } else if quantityIntegerTextField.text! == "0" || quantityIntegerTextField.text! == "1" && pickerValue == ""{
            units = unitsPopUpButton.titleLabel!.text!
        } else {
            units = "\(unitsPopUpButton.titleLabel!.text!)s"
        }
        
        //Create base ingredient
        if ingredientPopUpButton.titleLabel?.text == nil {
            errorLabel.isHidden = false
            errorLabel.text = "Please choose an ingredient"
        } else if unitsPopUpButton.titleLabel?.text == nil {
            errorLabel.isHidden = false
            errorLabel.text = "Please choose units of measurment"
        } else if unitsPopUpButton.titleLabel!.text! == "Whole" && quantityIntegerTextField.text != "1" && quantityIntegerTextField.text != "0" {
            ingredient = "\(ingredientPopUpButton.titleLabel!.text!)s"
            units = unitsPopUpButton.titleLabel!.text!
        } else {
            ingredient = ingredientPopUpButton.titleLabel!.text!
        }
        
        //Create note
        if noteTextField.text != "" {
            note = " (Note: \(noteTextField.text!))"
        }
        
        //Add ingredient to recipe
        if quantity != "" {
            if units != "" {
                if ingredient != "" {
                    let newIngredient = ingredientList.first { Ingredient in Ingredient.name == ingredientPopUpButton.titleLabel?.text}
                    newIngredient!.name = ingredient
                    newIngredient!.unitsType = units
                    newIngredient!.quantity = floatQuantity
                    newIngredient!.addToRecipe(newRecipe)
                    recipeIngredients.append("\(quantity) \(units) \(ingredient)\(note)")
                    quantityIntegerTextField.text = ""
                    noteTextField.text = ""
                    setupIngredientButton()
                    ingredientPopUpButton.titleLabel?.text = nil
                    setupUnitsTypeButton()
                    unitsPopUpButton.titleLabel?.text = nil
                    pickerValue = ""
                    fractionPickerView.selectRow(0, inComponent: 0, animated: true)
                    ingredientsTableView.reloadData()
                }
            }
        }
    }
    
    func convertPickerToFloat() {
        switch pickerValue {
        case "1/8":
            pickerAsFloat = 0.125
        case "1/4":
            pickerAsFloat = 0.25
        case "3/8":
            pickerAsFloat = 0.375
        case "1/2":
            pickerAsFloat = 0.5
        case "5/8":
            pickerAsFloat = 0.625
        case "3/4":
            pickerAsFloat = 0.75
        case "7/8":
            pickerAsFloat = 0.875
        default:
            pickerAsFloat = 0.0
        }
    }
    
    @IBAction func saveRecipePressed(_ sender: BrettButton) {
        
        newRecipe.name = recipeNameTextField.text
        newRecipe.directions = directionsTextView.text
        saveRecipe()
        recipeSaved = true
        navigationController?.popViewController(animated: true)
    }
    
    //MARK: CoreData CRUD Methods
    
    func saveRecipe() {
        do {
            try K.context.save()
        } catch {
            print("Error saving Ingredients: \(error)")
        }
    }
    
    func loadIngredients() {
        let request: NSFetchRequest<Ingredient> = Ingredient.fetchRequest()
        do {
            ingredientList = try K.context.fetch(request)
        } catch {
            print("Error loading Ingredients: \(error)")
        }
    }
    
    func updateDataAndView() {
        //saveIngredients()
        //loadIngredients()
        DispatchQueue.main.async {
            self.ingredientsTableView.reloadData()
        }
    }
    
}

//MARK: TableView DataSource Methods

extension EditRecipeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        recipeIngredients.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ingredientsTableView.dequeueReusableCell(withIdentifier: K.ingredientReuseIdentifier, for: indexPath) as! IngredientTableViewCell
        cell.delegate = self
        cell.ingredientCellLabel.text = "\(recipeIngredients[indexPath.row])"
        
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
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            K.context.delete(self.ingredientList[indexPath.row])
            self.recipeIngredients.remove(at: indexPath.row)
            self.updateDataAndView()
        }
        
        let editAction = SwipeAction(style: .default, title: "Edit\nIngredient") { action, indexPath in
//            self.segueCollectedWisdom = [self.collectedWisdom[indexPath.row]]
//            self.performSegue(withIdentifier: "editWisdomSegue", sender: self)
        }
        
        // customize the action appearance
        deleteAction.image = UIImage(named: "delete-icon")
//        editAction.backgroundColor = K.fontColor.withAlphaComponent(1.0)
//        editAction.textColor = K.fontColorWhite
//        editAction.font = UIFont(name: "Times New Roman", size: 20.0)
        
        return [deleteAction, editAction]
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

