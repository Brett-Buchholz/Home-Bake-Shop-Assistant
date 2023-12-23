//
//  UnitsConverter.swift
//  Home Bake Shop Assistant
//
//  Created by Brett Buchholz on 11/29/23.
//

import Foundation

struct UnitsConverter {
    
    func convertStringToFloat(stringValue:String) -> Float {
        switch stringValue {
        case "1/8":
            return 0.125
        case "1/4":
            return 0.25
        case "3/8":
            return 0.375
        case "1/2":
            return 0.5
        case "5/8":
            return 0.625
        case "3/4":
            return 0.75
        case "7/8":
            return 0.875
        default:
            return 0.0
        }
    }
    
    func convertFloatToString(floatValue:Float) -> String {
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
            case 0.375:
                decimalString = "3/8"
            case 0.5:
                decimalString = "1/2"
            case 0.625:
                decimalString = "5/8"
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
    
}
