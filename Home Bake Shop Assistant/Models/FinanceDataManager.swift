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
        var sales: Int
        var revenue: Float
        var cogs: Float
        var profit: Float {
            return revenue - cogs
        }
        
        init(name: String, sales: Int, revenue: Float, cogs: Float) {
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
    
    class CustomerSalesData {
        
        var customer: Customer
        var stringName: String {
            "\(customer.lastName!), \(customer.firstName!)"
        }
        var orders: Int
        var revenue: Float
        var cogs: Float
        var profit: Float {
            return revenue - cogs
        }
        
        init(customer: Customer, orders: Int, revenue: Float, cogs: Float) {
            self.customer = customer
            self.orders = orders
            self.revenue = revenue
            self.cogs = cogs
        }
    }
    
    class InventoryCostData {
        
        var ingredient: String
        var amount: Float
        var units: UnitsOfMeasurement.Units
        var unitCost: Float
        var totalCost: Float
        var amountUsed: String {
            let stringUnits = UnitsOfMeasurement().convertUnitsToString(unit: units)
            var used = ""
            if units == .Whole {
                used = "\(String(format: "%.f", amount))"
            } else {
                used = "\(String(format: "%.f", amount)) \(stringUnits)s"
            }
            return used
        }
        
        init(ingredient: String, amount: Float, units: UnitsOfMeasurement.Units, unitCost: Float, totalCost: Float) {
            self.ingredient = ingredient
            self.amount = amount
            self.units = units
            self.unitCost = unitCost
            self.totalCost = totalCost
        }
    }
    
    func getCOGS(recipe: Recipe, orderedItemBatchSize: Int16, quantityOrdered: Int16) -> Float {
        var RecipeCOGSList: [FinanceDataManager.RecipeCostData] = []
        var ingredientList: [RecipeIngredient] = []
        for ingredient in (recipe.toRecipeIngredient?.allObjects as! [RecipeIngredient]) {
            ingredientList.append(ingredient)
        }
        for ingredient in ingredientList {
            let name = ingredient.inventory!.ingredientName!
            let amount = (ingredient.quantity * Float(quantityOrdered)) / (Float(recipe.batchSize)/Float(orderedItemBatchSize))
            let units = UnitsOfMeasurement().convertStringToUnits(string: ingredient.units!)
            let stringName = ingredient.stringName!
            let standardUnits = UnitsOfMeasurement().convertStringToUnits(string: ingredient.inventory!.baseUnit!)
            let adjustedAmount = UnitsConverter(amount: amount, measuredUnits: units, standardUnits: standardUnits).convertUnits()
            let cost = (adjustedAmount * ingredient.inventory!.cost)
            let newIngredientCostItem = FinanceDataManager.RecipeCostData(ingredient: name, amount: adjustedAmount, recipeUnits: units, cost: cost, stringName: stringName)
            RecipeCOGSList.append(newIngredientCostItem)
        }
        var totalCost: Float = 0
        for ingredient in RecipeCOGSList {
            totalCost += ingredient.cost
        }
        
        return totalCost
    }
    
}

