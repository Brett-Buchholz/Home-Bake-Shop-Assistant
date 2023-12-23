//
//  AddIngredientViewController.swift
//  Home Bake Shop Assistant
//
//  Created by Brett Buchholz on 11/8/23.
//

import UIKit
import CoreData
import SwipeCellKit

class AddIngredientViewController: UIViewController {
    
    @IBOutlet weak var ingredientsTableView: UITableView!
    @IBOutlet weak var ingredientNameTextField: UITextField!
    @IBOutlet weak var unitsPopUpButton: UIButton!
    @IBOutlet weak var addIngredientButton: BrettButton!
    
    var ingredientList: [Inventory] = []
    var selectedIndexPath: IndexPath? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ingredientsTableView.dataSource = self
        ingredientsTableView.delegate = self
        ingredientsTableView.register(UINib(nibName: K.ingredientCellNibName, bundle: nil), forCellReuseIdentifier: K.ingredientReuseIdentifier)
        setupUnitsTypeButton()
        setupAddIngredientsButton()
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
    
    func setupAddIngredientsButton() {
        addIngredientButton.translatesAutoresizingMaskIntoConstraints = false
        let myString = "Add\nIngredients"
        let myStyle = NSMutableParagraphStyle()
        myStyle.alignment = .center
        myStyle.lineSpacing = 0.0
        let myAttributes = [NSAttributedString.Key.font: UIFont(name: "Times New Roman", size: 26.0), NSAttributedString.Key.foregroundColor: K.bakeShopBlack, NSAttributedString.Key.paragraphStyle: myStyle]
        let myAttrString = NSAttributedString(string: myString, attributes: myAttributes as [NSAttributedString.Key : Any])
        addIngredientButton.setAttributedTitle(myAttrString, for: .normal)
        addIngredientButton.configuration?.contentInsets.top = 5.0
        addIngredientButton.configuration?.contentInsets.bottom = 5.0
        addIngredientButton.configuration?.titlePadding = -5.0
    }
    
    
    @IBAction func addIngredientPressed(_ sender: BrettButton) {
        let newIngredient = Inventory(context: K.ingedientContext)
        newIngredient.item = ingredientNameTextField.text
        newIngredient.baseUnit = unitsPopUpButton.titleLabel?.text
        updateDataAndView()
        ingredientNameTextField.text = ""
    }
    
    //MARK: CoreData CRUD Methods
    
    func saveIngredients() {
        do {
            try K.ingedientContext.save()
        } catch {
            print("Error saving Prayer Rquests: \(error)")
        }
    }
    
    func loadIngredients() {
        let request: NSFetchRequest<Inventory> = Inventory.fetchRequest()
        do {
            ingredientList = try K.ingedientContext.fetch(request)
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

extension AddIngredientViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        ingredientList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ingredientsTableView.dequeueReusableCell(withIdentifier: K.ingredientReuseIdentifier, for: indexPath) as! IngredientTableViewCell
        cell.delegate = self
        cell.ingredientCellLabel.text = "\(ingredientList[indexPath.row].item ?? "unknown name") (\(ingredientList[indexPath.row].baseUnit ?? "unknown type"))"
        
        return cell
    }
    
}

extension AddIngredientViewController: UITableViewDelegate {
    
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

extension AddIngredientViewController: SwipeTableViewCellDelegate {
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            K.ingedientContext.delete(self.ingredientList[indexPath.row])
            self.ingredientList.remove(at: indexPath.row)
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

