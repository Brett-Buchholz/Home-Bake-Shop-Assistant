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
    
    static let bakeShopPink = UIColor(red: 255/255, green: 180/255, blue: 247/255, alpha: 1.0)
    static let bakeShopBlack = UIColor(red: 22/255, green: 22/255, blue: 22/255, alpha: 1.0)
    static let bakeShopMaroon = UIColor(red: 98/255, green: 55/255, blue: 57/255, alpha: 1.0)
    static let bakeShopTan = UIColor(red: 213/255, green: 203/255, blue: 176/255, alpha: 1.0)
    static let bakeShopBlueberry = UIColor(red: 107/255, green: 137/255, blue: 154/255, alpha: 1.0)
    static let bakeShopDeleteRed = UIColor(named: "DeleteRed")
    static let fontPadTitle = UIFont(name: "Marker Felt", size: 46.0)
    static let fontPadNormal = UIFont(name: "Marker Felt", size: 30.0)
    
    //MARK: TableViewCell
    static let ingredientCellNibName = "IngredientTableViewCell"
    static let ingredientReuseIdentifier = "IngredientReusableCell"
    
    static var interfaceMode = UIDevice.current.userInterfaceIdiom
    static var context: NSManagedObjectContext {
        let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        managedContext.automaticallyMergesChangesFromParent = true
        return managedContext
    }
    static var ingedientContext: NSManagedObjectContext {
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
    
    static let unitsOfMeasurement = ["", "Whole", "Teaspoon", "Tablespoon", "Cup", "Ounce", "Pound", "Fluid Ounce", "Pint", "Quart", "Gallon", "Gram", "Kilogram", "Liter", "Milliliter"]
    static let fractionalMeasurements = ["", "1/8", "1/4", "3/8", "1/2", "5/8", "3/4", "7/8"]
    
    
    static let segueIdentifierToViewRecipe = "viewReceipeSegue"
    static let segueIdentifierToEditRecipe = "editRecipeSegue"
    static let segueIdentifierToAddIngredient = "addIngredientSegue"
    static let segueIdentifierToCustomerInfo = "ToCustomerInfo"
}
