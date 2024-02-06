//
//  RecipeCostsViewController.swift
//  Home Bake Shop Assistant
//
//  Created by Brett Buchholz on 2/5/24.
//

import UIKit
import CoreData

class RecipeCostsViewController: UIViewController {
    
    
    @IBOutlet weak var financesTitleLabel: PaddingLabel!
    @IBOutlet weak var recipeCostsTitleLabel: PaddingLabel!
    @IBOutlet weak var batchSizeAmountLabel: PaddingLabel!
    @IBOutlet weak var batchPriceAmountLabel: PaddingLabel!
    @IBOutlet weak var totalIngredientValueLabel: PaddingLabel!
    @IBOutlet weak var profitValueLabel: PaddingLabel!
    
    @IBOutlet weak var selectRecipeView: UIView!
    @IBOutlet weak var recipeDetailsView: UIView!
    @IBOutlet weak var headersStackView: UIStackView!
    @IBOutlet weak var totalsStackView: UIStackView!
    
    @IBOutlet weak var selectRecipePopUpButton: UIButton!
    @IBOutlet weak var ingredientCostTableView: UITableView!
    
    var recipeList: [Recipe] = []
    var ingredientCostList: [FinanceDataManager.RecipeCostData] = []
    var selectedRecipe: Recipe? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Style The View
        financesTitleLabel.clipsToBounds = true
        AddBorders().addAllBorders(with: K.bakeShopChocolate, andWidth: 2.0, view: financesTitleLabel)
        AddBorders().addAllBorders(with: K.bakeShopChocolate, andWidth: 4.0, view: recipeCostsTitleLabel)
        AddBorders().addLeftBorder(with: K.bakeShopChocolate, andWidth: 4.0, view: selectRecipeView)
        AddBorders().addRightBorder(with: K.bakeShopChocolate, andWidth: 4.0, view: selectRecipeView)
        AddBorders().addLeftBorder(with: K.bakeShopChocolate, andWidth: 4.0, view: recipeDetailsView)
        AddBorders().addRightBorder(with: K.bakeShopChocolate, andWidth: 4.0, view: recipeDetailsView)
        AddBorders().addAllBorders(with: K.bakeShopChocolate, andWidth: 4.0, view: headersStackView)
        AddBorders().addLeftBorder(with: K.bakeShopChocolate, andWidth: 4.0, view: ingredientCostTableView)
        AddBorders().addRightBorder(with: K.bakeShopChocolate, andWidth: 4.0, view: ingredientCostTableView)
        AddBorders().addAllBorders(with: K.bakeShopChocolate, andWidth: 4.0, view: totalsStackView)
        
        
        //Register delegates, data sources and Nibs
        ingredientCostTableView.dataSource = self
        ingredientCostTableView.register(UINib(nibName: K.recipeCostCellNibName, bundle: nil), forCellReuseIdentifier: K.recipeCostReuseIdentifier)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupRecipeButton()
        loadIngredientCostList()
        navigationController?.navigationBar.tintColor = .systemBackground
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.navigationBar.tintColor = .bakeShopBlack
    }
    
    func setupRecipeButton() {
        loadRecipes()
        var chirren: [UIMenuElement] = []
        let closure = { (action: UIAction) in
            //print(action)
        }
        chirren.append(UIAction(title: "") { (action: UIAction) in
            self.selectedRecipe = nil
            self.loadIngredientCostList()
        })
        for recipe in recipeList {
            chirren.append(UIAction(title: "\(recipe.name!)") { (action: UIAction) in
                self.selectedRecipe = recipe
                self.loadIngredientCostList()
            })
        }
        selectRecipePopUpButton.menu = UIMenu(children: chirren)
    }
    
    func loadIngredientCostList() {
        ingredientCostList = []
        var ingredientList: [RecipeIngredient] = []
        if selectedRecipe != nil {
            for ingredient in (selectedRecipe?.toRecipeIngredient?.allObjects as! [RecipeIngredient]) {
                ingredientList.append(ingredient)
            }
            for ingredient in ingredientList {
                let name = ingredient.inventory!.ingredientName!
                let amount = ingredient.quantity
                let units = UnitsOfMeasurement().convertStringToUnits(string: ingredient.units!)
                let stringName = ingredient.stringName!
                let standardUnits = UnitsOfMeasurement().convertStringToUnits(string: ingredient.inventory!.baseUnit!)
                let adjustedAmount = UnitsConverter(amount: amount, measuredUnits: units, standardUnits: standardUnits).convertUnits()
                let cost = (adjustedAmount * ingredient.inventory!.cost)
                let newIngredientCostItem = FinanceDataManager.RecipeCostData(ingredient: name, amount: amount, recipeUnits: units, cost: cost, stringName: stringName)
                ingredientCostList.append(newIngredientCostItem)
            }
            var totalCost: Float = 0
            for ingredient in ingredientCostList {
                totalCost += ingredient.cost
            }
            totalIngredientValueLabel.text = StringConverter().convertCurrencyFloatToString(floatCurrency: totalCost)
            
            batchSizeAmountLabel.text = "\(selectedRecipe!.batchSize)"
            var batchPrice: Float = 0
            if selectedRecipe!.batchSize == 12 {
                batchPrice = selectedRecipe!.priceDozen
            } else if selectedRecipe!.batchSize == 6 {
                batchPrice = selectedRecipe!.priceHalfDozen
            } else {
                batchPrice = selectedRecipe!.priceSingle
            }
            batchPriceAmountLabel.text = StringConverter().convertCurrencyFloatToString(floatCurrency: batchPrice)
            profitValueLabel.text = StringConverter().convertCurrencyFloatToString(floatCurrency: (batchPrice - totalCost))
        }
        
        updateData()
    }
    
    
    //MARK: CoreData CRUD Methods
    
    func loadRecipes() {
        let request: NSFetchRequest<Recipe> = Recipe.fetchRequest()
        do {
            recipeList = try K.recipeContext.fetch(request)
        } catch {
            print("Error loading Recipe: \(error)")
        }
    }
    
    func updateData() {
        DispatchQueue.main.async {
            self.ingredientCostTableView.reloadData()
        }
    }
    
}

//MARK: TableView DataSource Methods

extension RecipeCostsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        ingredientCostList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ingredientCostTableView.dequeueReusableCell(withIdentifier: K.recipeCostReuseIdentifier, for: indexPath) as! RecipeCostTableViewCell
        cell.ingredientLabel.text = ingredientCostList[indexPath.row].stringName
        cell.costLabel.text = StringConverter().convertCurrencyFloatToString(floatCurrency: (ingredientCostList[indexPath.row].cost))
        
        return cell
    }
    
}

