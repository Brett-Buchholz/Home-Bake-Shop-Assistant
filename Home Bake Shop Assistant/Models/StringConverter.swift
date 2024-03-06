//
//  UnitsConverter.swift
//  Home Bake Shop Assistant
//
//  Created by Brett Buchholz on 11/29/23.
//

import Foundation

struct StringConverter {
    
    func convertFractionStringToFloat(stringValue:String) -> Float {
        switch stringValue {
        case "1/8":
            return 0.125
        case "1/4":
            return 0.25
        case "1/3":
            return 0.333
        case "3/8":
            return 0.375
        case "1/2":
            return 0.5
        case "5/8":
            return 0.625
        case "2/3":
            return 0.666
        case "3/4":
            return 0.75
        case "7/8":
            return 0.875
        default:
            return 0.0
        }
    }
    
    func convertFractionFloatToString(floatValue:Float) -> String {
        if floor(floatValue) == floatValue {
            return "\(Int(floatValue))"
        } else {
            let wholeNumber = "\(Int(floor(floatValue)))"
            let decimalNumber = floatValue - floor(floatValue)
            var decimalString = ""
            switch decimalNumber {
            case 0.125:
                decimalString = "1/8"
            case 0.25:
                decimalString = "1/4"
            case 0.333:
                decimalString = "1/3"
            case 0.375:
                decimalString = "3/8"
            case 0.5:
                decimalString = "1/2"
            case 0.625:
                decimalString = "5/8"
            case 0.666:
                decimalString = "2/3"
            case 0.667:
                decimalString = "2/3"
            case 0.75:
                decimalString = "3/4"
            case 0.875:
                decimalString = "7/8"
            default:
                decimalString = "\(decimalNumber)"
            }
            if wholeNumber == "0" {
                return decimalString
            } else {
                return "\(wholeNumber) \(decimalString)"
            }
        }
    }
    
    func convertCurrencyFloatToString(floatCurrency:Float) -> String {
        var newString = String(format: "$%.2f", floatCurrency)
        let stringLength = newString.count
        switch stringLength {
        case 8:
            if floatCurrency < 0 {
                newString = String(format: "$%.2f", floatCurrency)
            } else {
                let stringIndex = newString.index(newString.startIndex, offsetBy: 2)
                newString.insert(",", at: stringIndex)
            }
        case 9:
            let stringIndex = newString.index(newString.startIndex, offsetBy: 3)
            newString.insert(",", at: stringIndex)
        case 10:
            let stringIndex = newString.index(newString.startIndex, offsetBy: 4)
            newString.insert(",", at: stringIndex)
        case 11:
            if floatCurrency < 0 {
                let stringIndex = newString.index(newString.startIndex, offsetBy: 5)
                newString.insert(",", at: stringIndex)
            } else {
                let stringIndex = newString.index(newString.startIndex, offsetBy: 5)
                newString.insert(",", at: stringIndex)
                let stringIndex2 = newString.index(newString.startIndex, offsetBy: 2)
                newString.insert(",", at: stringIndex2)
            }
        case 12:
            let stringIndex = newString.index(newString.startIndex, offsetBy: 6)
            newString.insert(",", at: stringIndex)
            let stringIndex2 = newString.index(newString.startIndex, offsetBy: 3)
            newString.insert(",", at: stringIndex2)
        case 13:
            let stringIndex = newString.index(newString.startIndex, offsetBy: 7)
            newString.insert(",", at: stringIndex)
            let stringIndex2 = newString.index(newString.startIndex, offsetBy: 4)
            newString.insert(",", at: stringIndex2)
        default:
            newString = String(format: "$%.2f", floatCurrency)
        }
        
        return newString
    }
    
    func convertCurrencyStringToFloat(stringCurrency: String) -> Float {
        let string1 = stringCurrency.replacingOccurrences(of: "$", with: "")
        let newString = string1.replacingOccurrences(of: ",", with: "")
        let floatCurrency = (newString as NSString).floatValue
        return floatCurrency
    }
    
    func convertInventoryFloatToString(inventoryFloat: Float) -> String {
        var newString = "\(inventoryFloat)"
        if inventoryFloat * 10 == roundf(inventoryFloat * 10) {
            newString = String(format: "%.1f", inventoryFloat)
        } else if inventoryFloat * 100 == roundf(inventoryFloat * 100) {
            newString = String(format: "%.2f", inventoryFloat)
        } else {
            newString = String(format: "%.3f", inventoryFloat)
        }
        let stringLength = newString.count
        switch stringLength {
        case 8:
            let stringIndex = newString.index(newString.startIndex, offsetBy: 1)
            newString.insert(",", at: stringIndex)
        case 9:
            let stringIndex = newString.index(newString.startIndex, offsetBy: 2)
            newString.insert(",", at: stringIndex)
        case 10:
            let stringIndex = newString.index(newString.startIndex, offsetBy: 3)
            newString.insert(",", at: stringIndex)
        case 11:
            let stringIndex = newString.index(newString.startIndex, offsetBy: 4)
            newString.insert(",", at: stringIndex)
            let stringIndex2 = newString.index(newString.startIndex, offsetBy: 1)
            newString.insert(",", at: stringIndex2)
        case 12:
            let stringIndex = newString.index(newString.startIndex, offsetBy: 5)
            newString.insert(",", at: stringIndex)
            let stringIndex2 = newString.index(newString.startIndex, offsetBy: 2)
            newString.insert(",", at: stringIndex2)
        case 13:
            let stringIndex = newString.index(newString.startIndex, offsetBy: 6)
            newString.insert(",", at: stringIndex)
            let stringIndex2 = newString.index(newString.startIndex, offsetBy: 3)
            newString.insert(",", at: stringIndex2)
        default:
            return newString
        }
        
        return newString
    }
    
    func convertInventoryStringToFloat(inventoryString: String) -> Float {
        let newString = inventoryString.replacingOccurrences(of: ",", with: "")
        let floatInventory = (newString as NSString).floatValue
        return floatInventory
    }
}
