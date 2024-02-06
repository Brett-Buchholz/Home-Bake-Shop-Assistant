//
//  Constants.swift
//  Home Bake Shop Assistant
//
//  Created by Brett Buchholz on 11/4/23.
//

import Foundation
import UIKit
import CoreData

class K {
    
    //MARK: Colors and Fonts
    static let bakeShopPink = UIColor(red: 255/255, green: 180/255, blue: 247/255, alpha: 1.0)
    static let bakeShopBlack = UIColor(red: 22/255, green: 22/255, blue: 22/255, alpha: 1.0)
    static let bakeShopMaroon = UIColor(red: 98/255, green: 55/255, blue: 57/255, alpha: 1.0)
    static let bakeShopTan = UIColor(red: 213/255, green: 203/255, blue: 176/255, alpha: 1.0)
    static let bakeShopBrown = UIColor(red: 194/255, green: 122/255, blue: 56/255, alpha: 1.0)
    static let bakeShopBlueberry = UIColor(red: 107/255, green: 137/255, blue: 154/255, alpha: 1.0)
    static let bakeShopDeleteRed = UIColor(red: 255/255, green: 38/255, blue: 0/255, alpha: 1.0)
    static let bakeShopChocolate = UIColor(red: 104/255, green: 82/255, blue: 74/255, alpha: 1.0)
    static let systemBackground = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
    static let fontPadTitle = UIFont(name: "Marker Felt", size: 46.0)
    static let fontPadNormal = UIFont(name: "Marker Felt", size: 30.0)
    
    //MARK: TableViewCells
    static let ingredientCellNibName = "IngredientTableViewCell"
    static let ingredientReuseIdentifier = "IngredientReusableCell"
    static let orderCellNibName = "OrderTableViewCell"
    static let orderReuseIdentifier = "OrderReusableCell"
    static let orderListCellNibName = "OrderListTableViewCell"
    static let orderListReuseIdentifier = "OrderListReusableCell"
    static let cookbookCellNibName = "CookbookTableViewCell"
    static let cookbookReuseIdentifier = "CookbookReusableCell"
    static let recipeCellNibName = "RecipeTableViewCell"
    static let recipeReuseIdentifier = "RecipeReusableCell"
    static let customerCellNibName = "CustomerTableViewCell"
    static let customerReuseIdentifier = "CustomerReusableCell"
    static let quickAddCellNibName = "QuickAddTableViewCell"
    static let quickAddReuseIdentifier = "QuickAddReusableCell"
    static let recipeSalesCellNibName = "RecipeSalesTableViewCell"
    static let recipeSalesReuseIdentifier = "RecipeDataReusableCell"
    static let recipeCostCellNibName = "RecipeCostTableViewCell"
    static let recipeCostReuseIdentifier = "RecipeCostReusableCell"
    
    //MARK: SegueIdentifiers
    static let segueIdentifierToViewRecipe = "viewReceipeSegue"
    static let segueIdentifierToEditRecipe = "editRecipeSegue"
    static let segueIdentifierToViewOrder = "viewOrderSegue"
    static let segueIdentifierToEditOrder = "ToEditOrderSegue"
    static let segueIdentifierToPrintableInvoice = "ToPrintableInvoiceSegue"
    static let segueIdentifierToAddIngredient = "addIngredientSegue"
    static let segueIdentifierToCustomerInfo = "ToCustomerInfo"
    static let segueIdentifierToCompanyInfo = "ToCompanyInfo"
    static let segueIdentifierToEditInventory = "ToEditInventorySegue"
    
    //MARK: Misc
    static var interfaceMode = UIDevice.current.userInterfaceIdiom
    static let fractionalMeasurements = ["", "1/8", "1/4", "3/8", "1/2", "5/8", "3/4", "7/8"]
    
    //MARK: CoreData
    static var context: NSManagedObjectContext {
        let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        managedContext.automaticallyMergesChangesFromParent = true
        return managedContext
    }
    static var inventoryIngredientContext: NSManagedObjectContext {
        let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        managedContext.automaticallyMergesChangesFromParent = true
        return managedContext
    }
    static var companyInfoContext: NSManagedObjectContext {
        let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        managedContext.automaticallyMergesChangesFromParent = true
        return managedContext
    }
    static var customerInfoContext: NSManagedObjectContext {
        let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        managedContext.automaticallyMergesChangesFromParent = true
        return managedContext
    }
    static var ordersContext: NSManagedObjectContext {
        let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        managedContext.automaticallyMergesChangesFromParent = true
        return managedContext
    }
    static var recipeContext: NSManagedObjectContext {
        let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        managedContext.automaticallyMergesChangesFromParent = true
        return managedContext
    }
    
}
