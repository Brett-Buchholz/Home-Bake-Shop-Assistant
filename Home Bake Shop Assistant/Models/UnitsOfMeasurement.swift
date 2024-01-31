//
//  UnitsOfMeasurement.swift
//  Home Bake Shop Assistant
//
//  Created by Brett Buchholz on 1/21/24.
//

import Foundation

struct UnitsOfMeasurement {
    
    enum Units: CaseIterable {
        
        case None, Whole, Teaspoon, Tablespoon, Cup, Ounce, Pound, FluidOunce, Pint, Quart, Gallon, Gram, Kilogram, Liter, Milliliter
    }
    
    func convertUnitsToString(unit: Units) -> String {
        switch unit {
        case .None:
            return ""
        case .Whole:
            return "Whole"
        case .Teaspoon:
            return "Teaspoon"
        case .Tablespoon:
            return "Tablespoon"
        case .Cup:
            return "Cup"
        case .Ounce:
            return "Ounce"
        case .Pound:
            return "Pound"
        case .FluidOunce:
            return "FluidOunce"
        case .Pint:
            return "Pint"
        case .Quart:
            return "Quart"
        case .Gallon:
            return "Gallon"
        case .Gram:
            return "Gram"
        case .Kilogram:
            return "Kilogram"
        case .Liter:
            return "Liter"
        case .Milliliter:
            return "Milliliter"
        }
    }
    
    func convertStringToUnits(string: String) -> Units {
        switch string {
        case "Whole":
            return .Whole
        case "Teaspoon":
            return .Teaspoon
        case "Teaspoons":
            return .Teaspoon
        case "Tablespoon":
            return .Tablespoon
        case "Tablespoons":
            return .Tablespoon
        case "Cup":
            return .Cup
        case "Cups":
            return .Cup
        case "Ounce":
            return .Ounce
        case "Ounces":
            return .Ounce
        case "Pound":
            return .Pound
        case "Pounds":
            return .Pound
        case "FluidOunce":
            return .FluidOunce
        case "FluidOunces":
            return .FluidOunce
        case "Pint":
            return .Pint
        case "Pints":
            return .Pint
        case "Quart":
            return .Quart
        case "Quarts":
            return .Quart
        case "Gallon":
            return .Gallon
        case "Gallons":
            return .Gallon
        case "Gram":
            return .Gram
        case "Grams":
            return .Gram
        case "Kilogram":
            return .Kilogram
        case "Kilograms":
            return .Kilogram
        case "Liter":
            return .Liter
        case "Liters":
            return .Liter
        case "Milliliter":
            return .Milliliter
        case "Milliliters":
            return .Milliliter
        default:
            return .None
        }
    }
}
