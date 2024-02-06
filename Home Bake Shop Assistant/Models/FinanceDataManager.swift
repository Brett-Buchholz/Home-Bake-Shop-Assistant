//
//  FinanceDataManager.swift
//  Home Bake Shop Assistant
//
//  Created by Brett Buchholz on 2/4/24.
//

import Foundation

class FinanceDataManager {
    
    class RecipeSalesData {
        
        var name: String
        var sales: Int16
        var revenue: Float
        var cogs: Float
        var profit: Float {
            return revenue - cogs
        }
        
        init(name: String, sales: Int16, revenue: Float, cogs: Float) {
            self.name = name
            self.sales = sales
            self.revenue = revenue
            self.cogs = cogs
        }
    }
    
    class RecipeCostData {
        
        var ingredient: String
        var amount: Float
        var recipeUnits: UnitsOfMeasurement.Units
        var cost: Float
        var stringName: String
        
        init(ingredient: String, amount: Float, recipeUnits: UnitsOfMeasurement.Units, cost: Float, stringName: String) {
            self.ingredient = ingredient
            self.amount = amount
            self.recipeUnits = recipeUnits
            self.cost = cost
            self.stringName = stringName
        }
    }
    
    
    
}

