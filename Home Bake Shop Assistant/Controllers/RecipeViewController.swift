//
//  RecipeViewController.swift
//  Home Bake Shop Assistant
//
//  Created by Brett Buchholz on 11/28/23.
//

import UIKit
import CoreData
import SwipeCellKit

class RecipeViewController: UIViewController {
    
    @IBOutlet weak var recipeNameLabel: UILabel!
    @IBOutlet weak var recipeIngredientsTableView: UITableView!
    @IBOutlet weak var directionsTextView: UITextView!
    
    
    var loadedRecipe: [Recipe] = []
    var recipeIngredients: [Ingredient] = []
    var ingredientList: [String] = []
    var selectedIndexPath: IndexPath? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        recipeNameLabel.text = loadedRecipe[0].name
        directionsTextView.text = loadedRecipe[0].directions
        recipeIngredients = loadedRecipe[0].ingredient!.allObjects as! [Ingredient]
        for i in recipeIngredients {
            ingredientList.append("\(i.quantity) \(i.unitsType!) \(i.name!)")
        }
        recipeIngredientsTableView.delegate = self
        recipeIngredientsTableView.dataSource = self
        recipeIngredientsTableView.register(UINib(nibName: "IngredientTableViewCell", bundle: nil), forCellReuseIdentifier: K.ingredientReuseIdentifier)
        
        }
        
        
    
    
    
    
    
}

//MARK: TableView DataSource Methods

extension RecipeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        recipeIngredients.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = recipeIngredientsTableView.dequeueReusableCell(withIdentifier: K.ingredientReuseIdentifier, for: indexPath) as! IngredientTableViewCell
        cell.delegate = self
        cell.ingredientCellLabel.text = "\(ingredientList[indexPath.row])"
        
        return cell
    }
    
}

extension RecipeViewController: UITableViewDelegate {
    
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

extension RecipeViewController: SwipeTableViewCellDelegate {
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            K.context.delete(self.recipeIngredients[indexPath.row])
            self.recipeIngredients.remove(at: indexPath.row)
//            self.updateDataAndView()
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


