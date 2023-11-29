//
//  CookbookViewController.swift
//  Home Bake Shop Assistant
//
//  Created by Brett Buchholz on 11/27/23.
//

import UIKit
import SwipeCellKit
import CoreData

class CookbookViewController: UIViewController {
    
    @IBOutlet weak var recipeTableView: UITableView!
    
    var recipeList: [Recipe] = []
    var selectedIndexPath: IndexPath? = nil
    var segueRecipe: [Recipe] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        recipeTableView.delegate = self
        recipeTableView.dataSource = self
        recipeTableView.register(UINib(nibName: "IngredientTableViewCell", bundle: nil), forCellReuseIdentifier: K.ingredientReuseIdentifier)
        loadRecipes()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateDataAndView()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.segueIdentifierToViewRecipe {
            let destinationVC = segue.destination as! RecipeViewController
            destinationVC.loadedRecipe = segueRecipe
        }
    }
    

    
    //MARK: CoreData CRUD Methods
    
    func saveRecipe() {
        do {
            try K.context.save()
        } catch {
            print("Error saving Recipe: \(error)")
        }
    }
    
    func loadRecipes() {
        let request: NSFetchRequest<Recipe> = Recipe.fetchRequest()
        do {
            recipeList = try K.context.fetch(request)
        } catch {
            print("Error loading Recipe: \(error)")
        }
    }
    
    func updateDataAndView() {
        saveRecipe()
        loadRecipes()
        DispatchQueue.main.async {
            self.recipeTableView.reloadData()
        }
    }
    
}

//MARK: TableView DataSource Methods

extension CookbookViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        recipeList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = recipeTableView.dequeueReusableCell(withIdentifier: K.ingredientReuseIdentifier, for: indexPath) as! IngredientTableViewCell
        cell.delegate = self
        cell.ingredientCellLabel.text = "\(recipeList[indexPath.row].name ?? "unknown name")"
        
        return cell
    }
    
}

extension CookbookViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        segueRecipe = [recipeList[indexPath.row]]
        performSegue(withIdentifier: K.segueIdentifierToViewRecipe, sender: self)
    }
}

//MARK: Swipe Cell Kit Functionality

extension CookbookViewController: SwipeTableViewCellDelegate {
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            K.context.delete(self.recipeList[indexPath.row])
            self.recipeList.remove(at: indexPath.row)
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
