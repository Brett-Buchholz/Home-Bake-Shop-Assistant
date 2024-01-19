//
//  AddIngredientViewController.swift
//  Home Bake Shop Assistant
//
//  Created by Brett Buchholz on 11/8/23.
//

import UIKit
import CoreData
import SwipeCellKit

class InventoryViewController: UIViewController {
    
    @IBOutlet weak var ingredientsTableView: UITableView!
    @IBOutlet weak var ingredientNameTextField: UITextField!
    @IBOutlet weak var unitsPopUpButton: UIButton!
    @IBOutlet weak var addIngredientButton: BrettButton!
    @IBOutlet weak var ingredientTitleLabel: PaddingLabel!
    @IBOutlet weak var headerStackView: UIStackView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var errorLabel: UILabel!
    
    var inventoryList: [Inventory] = []
    var selectedIndexPath: IndexPath? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Style The View
        ingredientTitleLabel.clipsToBounds = true
        AddBorders().addAllBorders(with: K.bakeShopBrown, andWidth: 2.0, view: ingredientTitleLabel)
        AddBorders().addAllBorders(with: K.bakeShopBrown, andWidth: 4.0, view: headerStackView)
        AddBorders().addLeftBorder(with: K.bakeShopBrown, andWidth: 4.0, view: ingredientsTableView)
        AddBorders().addRightBorder(with: K.bakeShopBrown, andWidth: 4.0, view: ingredientsTableView)
        AddBorders().addAllBorders(with: K.bakeShopBrown, andWidth: 4.0, view: bottomView)
        addIngredientButton.tintColor = K.bakeShopBrown
        ingredientsTableView.rowHeight = 50
        
        //Register delegates, data sources and Nibs
        ingredientsTableView.dataSource = self
        ingredientsTableView.delegate = self
        ingredientsTableView.register(UINib(nibName: K.ingredientCellNibName, bundle: nil), forCellReuseIdentifier: K.ingredientReuseIdentifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        inventoryList = inventoryList.sorted {$0.ingredientName! < $1.ingredientName!}
        errorLabel.isHidden = true
        setupUnitsTypeButton()
        updateDataAndView()
    }
    
    func setupUnitsTypeButton() {
        var chirren: [UIMenuElement] = []
        let closure = { (action: UIAction) in
            //print(action)
        }
        for unit in K.unitsOfMeasurement {
            if unit == "" || unit == "Whole" {
                chirren.append(UIAction(title: "\(unit)", handler: closure))
            } else {
                chirren.append(UIAction(title: "\(unit)s", handler: closure))
            }
        }
        unitsPopUpButton.menu = UIMenu(children: chirren)
    }
    
    @IBAction func addIngredientPressed(_ sender: BrettButton) {
        errorLabel.isHidden = true
        if ingredientNameTextField.text == "" {
            errorLabel.isHidden = false
            errorLabel.text = "Please type an ingredient name!"
        } else if unitsPopUpButton.titleLabel?.text == nil {
            errorLabel.isHidden = false
            errorLabel.text = "Please select a standard unit!"
        } else {
            let newIngredient = Inventory(context: K.inventoryIngredientContext)
            newIngredient.ingredientName = ingredientNameTextField.text
            newIngredient.baseUnit = unitsPopUpButton.titleLabel?.text
            updateDataAndView()
            ingredientNameTextField.text = ""
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
    
    func updateDataAndView() {
        saveIngredients()
        loadIngredients()
        DispatchQueue.main.async {
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
        cell.delegate = self
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

extension InventoryViewController: SwipeTableViewCellDelegate {
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            K.inventoryIngredientContext.delete(self.inventoryList[indexPath.row])
            self.inventoryList.remove(at: indexPath.row)
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

