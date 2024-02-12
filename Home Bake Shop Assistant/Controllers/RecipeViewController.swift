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
    @IBOutlet weak var batchLabel: PaddingLabel!
    
    var loadedRecipe: [Recipe] = []
    var recipeIngredients: [RecipeIngredient] = []
    var selectedIndexPath: IndexPath? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Style The View
        AddBorders().addAllBorders(with: K.bakeShopMaroon, andWidth: 2.0, view: stackView)
        editRecipeButton.tintColor = K.bakeShopMaroon
        deleteRecipeButton.tintColor = K.bakeShopDeleteRed
        
        //Register delegates, data sources and Nibs
        recipeIngredientsTableView.delegate = self
        recipeIngredientsTableView.dataSource = self
        recipeIngredientsTableView.register(UINib(nibName: K.recipeCellNibName, bundle: nil), forCellReuseIdentifier: K.recipeReuseIdentifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadLabelData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.segueIdentifierToEditRecipe {
            let destinationVC = segue.destination as! EditRecipeViewController
            destinationVC.loadedRecipe = loadedRecipe[0]
            destinationVC.tempIngredientList = recipeIngredients
        }
    }
    
    func loadLabelData() {
        recipeNameLabel.text = loadedRecipe[0].name
        directionsTextView.text = loadedRecipe[0].directions
        recipeIngredients = loadedRecipe[0].toRecipeIngredient!.allObjects as! [RecipeIngredient]
        recipeIngredients = recipeIngredients.sorted {$0.name! < $1.name!}
        let singlePrice = StringConverter().convertCurrencyFloatToString(floatCurrency: loadedRecipe[0].priceSingle)
        let halfDozenPrice = StringConverter().convertCurrencyFloatToString(floatCurrency: loadedRecipe[0].priceHalfDozen)
        let dozenPrice = StringConverter().convertCurrencyFloatToString(floatCurrency: loadedRecipe[0].priceDozen)
        if K.interfaceMode == .phone {
            batchLabel.text = "Batch Size Of: \(loadedRecipe[0].batchSize), Price per:\nDozen \(dozenPrice), Half Dozen \(halfDozenPrice), Single \(singlePrice)"
        } else {
            batchLabel.text = "Batch Size Of: \(loadedRecipe[0].batchSize), Price per: Dozen \(dozenPrice), Half Dozen \(halfDozenPrice), Single \(singlePrice)"
        }
    }
    
    @IBAction func deleteRecipePressed(_ sender: BrettButton) {
        let alert = UIAlertController(title: "", message: "Are you sure you want to delete this recipe?", preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "Dismiss", style: .default) { action in
            //Dismiss alert
        }
        alert.addAction(dismissAction)
        let deleteAction = UIAlertAction(title: "Delete", style: .default) { action in
            K.recipeContext.delete(self.loadedRecipe[0])
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
        let cell = recipeIngredientsTableView.dequeueReusableCell(withIdentifier: K.recipeReuseIdentifier, for: indexPath) as! RecipeTableViewCell
        cell.recipeIngredientLabel.text = "\(recipeIngredients[indexPath.row].stringName!)"
        recipeIngredients = recipeIngredients.sorted {$0.name! < $1.name!}
        
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
