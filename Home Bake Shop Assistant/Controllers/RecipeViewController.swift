//
//  RecipeViewController.swift
//  Home Bake Shop Assistant
//
//  Created by Brett Buchholz on 11/28/23.
//

import UIKit
import CoreData

class RecipeViewController: UIViewController {
    
    @IBOutlet weak var recipeNameLabel: UILabel!
    @IBOutlet weak var recipeIngredientsTableView: UITableView!
    @IBOutlet weak var directionsTextView: UITextView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var editRecipeButton: BrettButton!
    @IBOutlet weak var deleteRecipeButton: BrettButton!
    
    var loadedRecipe: [Recipe] = []
    var recipeIngredients: [Ingredient] = []
    var ingredientList: [String] = []
    var selectedIndexPath: IndexPath? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        stackView.layer.borderWidth = 2
        stackView.layer.borderColor = K.bakeShopMaroon.cgColor
        editRecipeButton.tintColor = K.bakeShopMaroon
        deleteRecipeButton.tintColor = K.bakeShopMaroon
        recipeNameLabel.text = loadedRecipe[0].name
        directionsTextView.text = loadedRecipe[0].directions
        recipeIngredients = loadedRecipe[0].ingredient!.allObjects as! [Ingredient]
        for i in recipeIngredients {
            let convertedQuantity = UnitsConverter().convertFloatToString(floatValue: i.quantity)
            if i.units == "Whole" {
                ingredientList.append("\(convertedQuantity) \(i.units!) \(i.name!)")
            } else {
                ingredientList.append("\(convertedQuantity) \(i.units!) of \(i.name!)")
            }
        }
        recipeIngredientsTableView.delegate = self
        recipeIngredientsTableView.dataSource = self
        recipeIngredientsTableView.register(UINib(nibName: "IngredientTableViewCell", bundle: nil), forCellReuseIdentifier: K.ingredientReuseIdentifier)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.segueIdentifierToEditRecipe {
            let destinationVC = segue.destination as! EditRecipeViewController
            destinationVC.loadedRecipe = loadedRecipe[0]
            destinationVC.recipeIngredients = ingredientList
        }
    }
    
    @IBAction func deleteRecipePressed(_ sender: BrettButton) {
        let alert = UIAlertController(title: "", message: "Are you sure you want to delete this recipe?", preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "Dismiss", style: .default) { action in
            //Dismiss alert
        }
        alert.addAction(dismissAction)
        let deleteAction = UIAlertAction(title: "Delete", style: .default) { action in
            K.context.delete(self.loadedRecipe[0])
            self.navigationController?.popToViewController((self.navigationController?.viewControllers[1])!, animated: true)
        }
        alert.addAction(deleteAction)
        present(alert, animated: true, completion: nil)
    }
    
}

//MARK: TableView DataSource Methods

extension RecipeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        recipeIngredients.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = recipeIngredientsTableView.dequeueReusableCell(withIdentifier: K.ingredientReuseIdentifier, for: indexPath) as! IngredientTableViewCell
        cell.ingredientCellLabel.text = "\(ingredientList[indexPath.row])"
        cell.ingredientCellLabel.textColor = K.bakeShopMaroon
        
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
