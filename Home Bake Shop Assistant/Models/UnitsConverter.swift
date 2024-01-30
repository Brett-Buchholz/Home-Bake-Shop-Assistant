//
//  UnitsConverter.swift
//  Home Bake Shop Assistant
//
//  Created by Brett Buchholz on 1/21/24.
//

import Foundation

struct UnitsConverter {
    
    var amount: Float
    var measuredUnits: UnitsOfMeasurement.Units
    var standardUnits: UnitsOfMeasurement.Units
    
    init(amount: Float, measuredUnits: UnitsOfMeasurement.Units, standardUnits: UnitsOfMeasurement.Units) {
        self.amount = amount
        self.measuredUnits = measuredUnits
        self.standardUnits = standardUnits
    }
    
    func convertUnits() -> Float {
        var multiplier:Float = 0
        if measuredUnits == UnitsOfMeasurement.Units.Teaspoon {
            if standardUnits == UnitsOfMeasurement.Units.Teaspoon {
                multiplier = 1
            } else if standardUnits == UnitsOfMeasurement.Units.Tablespoon {
                multiplier = (1/3)
            } else if standardUnits == UnitsOfMeasurement.Units.Cup {
                multiplier = (1/48)
            } else if standardUnits == UnitsOfMeasurement.Units.Ounce {
                multiplier = (1/6)
            } else if standardUnits == UnitsOfMeasurement.Units.Pound {
                multiplier = (1/96)
            } else if standardUnits == UnitsOfMeasurement.Units.FluidOunce {
                multiplier = (1/6)
            } else if standardUnits == UnitsOfMeasurement.Units.Pint {
                multiplier = (1/96)
            } else if standardUnits == UnitsOfMeasurement.Units.Quart {
                multiplier = (1/192)
            } else if standardUnits == UnitsOfMeasurement.Units.Gallon {
                multiplier = (1/768)
            } else if standardUnits == UnitsOfMeasurement.Units.Liter {
                multiplier = (1/202.9)
            } else if standardUnits == UnitsOfMeasurement.Units.Milliliter {
                multiplier = 4.929
            }
        } else if measuredUnits == UnitsOfMeasurement.Units.Tablespoon {
            if standardUnits == UnitsOfMeasurement.Units.Teaspoon {
                multiplier = 3
            } else if standardUnits == UnitsOfMeasurement.Units.Tablespoon {
                multiplier = 1
            } else if standardUnits == UnitsOfMeasurement.Units.Cup {
                multiplier = (1/16)
            } else if standardUnits == UnitsOfMeasurement.Units.Ounce {
                multiplier = (1/2)
            } else if standardUnits == UnitsOfMeasurement.Units.Pound {
                multiplier = (1/32)
            } else if standardUnits == UnitsOfMeasurement.Units.FluidOunce {
                multiplier = (1/2)
            } else if standardUnits == UnitsOfMeasurement.Units.Pint {
                multiplier = (1/32)
            } else if standardUnits == UnitsOfMeasurement.Units.Quart {
                multiplier = (1/64)
            } else if standardUnits == UnitsOfMeasurement.Units.Gallon {
                multiplier = (1/256)
            } else if standardUnits == UnitsOfMeasurement.Units.Liter {
                multiplier = (1/67.628)
            } else if standardUnits == UnitsOfMeasurement.Units.Milliliter {
                multiplier = 14.787
            }
        } else if measuredUnits == UnitsOfMeasurement.Units.Cup {
            if standardUnits == UnitsOfMeasurement.Units.Teaspoon {
                multiplier = 48
            } else if standardUnits == UnitsOfMeasurement.Units.Tablespoon {
                multiplier = 16
            } else if standardUnits == UnitsOfMeasurement.Units.Cup {
                multiplier = 1
            } else if standardUnits == UnitsOfMeasurement.Units.Ounce {
                multiplier = 8
            } else if standardUnits == UnitsOfMeasurement.Units.Pound {
                multiplier = 2
            } else if standardUnits == UnitsOfMeasurement.Units.FluidOunce {
                multiplier = 8
            } else if standardUnits == UnitsOfMeasurement.Units.Pint {
                multiplier = (1/2)
            } else if standardUnits == UnitsOfMeasurement.Units.Quart {
                multiplier = (1/4)
            } else if standardUnits == UnitsOfMeasurement.Units.Gallon {
                multiplier = (1/16)
            } else if standardUnits == UnitsOfMeasurement.Units.Liter {
                multiplier = (1/4.167)
            } else if standardUnits == UnitsOfMeasurement.Units.Milliliter {
                multiplier = 240
            }
        } else if measuredUnits == UnitsOfMeasurement.Units.Ounce {
            if standardUnits == UnitsOfMeasurement.Units.Teaspoon {
                multiplier = 6
            } else if standardUnits == UnitsOfMeasurement.Units.Tablespoon {
                multiplier = 2
            } else if standardUnits == UnitsOfMeasurement.Units.Cup {
                multiplier = 8
            } else if standardUnits == UnitsOfMeasurement.Units.Ounce {
                multiplier = 1
            } else if standardUnits == UnitsOfMeasurement.Units.Pound {
                multiplier = 16
            } else if standardUnits == UnitsOfMeasurement.Units.FluidOunce {
                multiplier = 1
            } else if standardUnits == UnitsOfMeasurement.Units.Pint {
                multiplier = (1/16)
            } else if standardUnits == UnitsOfMeasurement.Units.Quart {
                multiplier = (1/32)
            } else if standardUnits == UnitsOfMeasurement.Units.Gallon {
                multiplier = (1/128)
            } else if standardUnits == UnitsOfMeasurement.Units.Liter {
                multiplier = (1/33.814)
            } else if standardUnits == UnitsOfMeasurement.Units.Milliliter {
                multiplier = 29.574
            }
        } else if measuredUnits == UnitsOfMeasurement.Units.Pound {
            if standardUnits == UnitsOfMeasurement.Units.Teaspoon {
                multiplier = 96
            } else if standardUnits == UnitsOfMeasurement.Units.Tablespoon {
                multiplier = 32
            } else if standardUnits == UnitsOfMeasurement.Units.Cup {
                multiplier = (1/2)
            } else if standardUnits == UnitsOfMeasurement.Units.Ounce {
                multiplier = (1/16)
            } else if standardUnits == UnitsOfMeasurement.Units.Pound {
                multiplier = 1
            } else if standardUnits == UnitsOfMeasurement.Units.FluidOunce {
                multiplier = (1/16)
            } else if standardUnits == UnitsOfMeasurement.Units.Pint {
                multiplier = 1
            } else if standardUnits == UnitsOfMeasurement.Units.Quart {
                multiplier = (1/2)
            } else if standardUnits == UnitsOfMeasurement.Units.Gallon {
                multiplier = (1/8)
            } else if standardUnits == UnitsOfMeasurement.Units.Liter {
                multiplier = (1/2.2)
            } else if standardUnits == UnitsOfMeasurement.Units.Milliliter {
                multiplier = 0.0022
            }
        } else if measuredUnits == UnitsOfMeasurement.Units.FluidOunce {
            if standardUnits == UnitsOfMeasurement.Units.Teaspoon {
                multiplier = 6
            } else if standardUnits == UnitsOfMeasurement.Units.Tablespoon {
                multiplier = 2
            } else if standardUnits == UnitsOfMeasurement.Units.Cup {
                multiplier = 8
            } else if standardUnits == UnitsOfMeasurement.Units.Ounce {
                multiplier = 1
            } else if standardUnits == UnitsOfMeasurement.Units.Pound {
                multiplier = 16
            } else if standardUnits == UnitsOfMeasurement.Units.FluidOunce {
                multiplier = 1
            } else if standardUnits == UnitsOfMeasurement.Units.Pint {
                multiplier = (1/16)
            } else if standardUnits == UnitsOfMeasurement.Units.Quart {
                multiplier = (1/32)
            } else if standardUnits == UnitsOfMeasurement.Units.Gallon {
                multiplier = (1/128)
            } else if standardUnits == UnitsOfMeasurement.Units.Liter {
                multiplier = (1/33.814)
            } else if standardUnits == UnitsOfMeasurement.Units.Milliliter {
                multiplier = 29.574
            }
        } else if measuredUnits == UnitsOfMeasurement.Units.Pint {
            if standardUnits == UnitsOfMeasurement.Units.Teaspoon {
                multiplier = 16
            } else if standardUnits == UnitsOfMeasurement.Units.Tablespoon {
                multiplier = 32
            } else if standardUnits == UnitsOfMeasurement.Units.Cup {
                multiplier = 2
            } else if standardUnits == UnitsOfMeasurement.Units.Ounce {
                multiplier = 16
            } else if standardUnits == UnitsOfMeasurement.Units.Pound {
                multiplier = 1
            } else if standardUnits == UnitsOfMeasurement.Units.FluidOunce {
                multiplier = 16
            } else if standardUnits == UnitsOfMeasurement.Units.Pint {
                multiplier = 1
            } else if standardUnits == UnitsOfMeasurement.Units.Quart {
                multiplier = (1/2)
            } else if standardUnits == UnitsOfMeasurement.Units.Gallon {
                multiplier = (1/8)
            } else if standardUnits == UnitsOfMeasurement.Units.Liter {
                multiplier = (1/2.113)
            } else if standardUnits == UnitsOfMeasurement.Units.Milliliter {
                multiplier = 473.2
            }
        } else if measuredUnits == UnitsOfMeasurement.Units.Quart {
            if standardUnits == UnitsOfMeasurement.Units.Teaspoon {
                multiplier = 192
            } else if standardUnits == UnitsOfMeasurement.Units.Tablespoon {
                multiplier = 64
            } else if standardUnits == UnitsOfMeasurement.Units.Cup {
                multiplier = 4
            } else if standardUnits == UnitsOfMeasurement.Units.Ounce {
                multiplier = 32
            } else if standardUnits == UnitsOfMeasurement.Units.Pound {
                multiplier = 2
            } else if standardUnits == UnitsOfMeasurement.Units.FluidOunce {
                multiplier = 32
            } else if standardUnits == UnitsOfMeasurement.Units.Pint {
                multiplier = 2
            } else if standardUnits == UnitsOfMeasurement.Units.Quart {
                multiplier = 1
            } else if standardUnits == UnitsOfMeasurement.Units.Gallon {
                multiplier = (1/4)
            } else if standardUnits == UnitsOfMeasurement.Units.Liter {
                multiplier = (1/1.057)
            } else if standardUnits == UnitsOfMeasurement.Units.Milliliter {
                multiplier = 946.4
            }
        } else if measuredUnits == UnitsOfMeasurement.Units.Gallon {
            if standardUnits == UnitsOfMeasurement.Units.Teaspoon {
                multiplier = 768
            } else if standardUnits == UnitsOfMeasurement.Units.Tablespoon {
                multiplier = 256
            } else if standardUnits == UnitsOfMeasurement.Units.Cup {
                multiplier = 16
            } else if standardUnits == UnitsOfMeasurement.Units.Ounce {
                multiplier = 128
            } else if standardUnits == UnitsOfMeasurement.Units.Pound {
                multiplier = 8
            } else if standardUnits == UnitsOfMeasurement.Units.FluidOunce {
                multiplier = 128
            } else if standardUnits == UnitsOfMeasurement.Units.Pint {
                multiplier = 8
            } else if standardUnits == UnitsOfMeasurement.Units.Quart {
                multiplier = 4
            } else if standardUnits == UnitsOfMeasurement.Units.Gallon {
                multiplier = 1
            } else if standardUnits == UnitsOfMeasurement.Units.Liter {
                multiplier = 3.785
            } else if standardUnits == UnitsOfMeasurement.Units.Milliliter {
                multiplier = 3785
            }
        } else if measuredUnits == UnitsOfMeasurement.Units.Liter {
            if standardUnits == UnitsOfMeasurement.Units.Teaspoon {
                multiplier = 202.9
            } else if standardUnits == UnitsOfMeasurement.Units.Tablespoon {
                multiplier = 67.628
            } else if standardUnits == UnitsOfMeasurement.Units.Cup {
                multiplier = 4.167
            } else if standardUnits == UnitsOfMeasurement.Units.Ounce {
                multiplier = 33.814
            } else if standardUnits == UnitsOfMeasurement.Units.Pound {
                multiplier = 2.2
            } else if standardUnits == UnitsOfMeasurement.Units.FluidOunce {
                multiplier = 33.814
            } else if standardUnits == UnitsOfMeasurement.Units.Pint {
                multiplier = 2.113
            } else if standardUnits == UnitsOfMeasurement.Units.Quart {
                multiplier = 1.057
            } else if standardUnits == UnitsOfMeasurement.Units.Gallon {
                multiplier = (1/3.785)
            } else if standardUnits == UnitsOfMeasurement.Units.Liter {
                multiplier = 1
            } else if standardUnits == UnitsOfMeasurement.Units.Milliliter {
                multiplier = 1000
            }
        } else if measuredUnits == UnitsOfMeasurement.Units.Milliliter {
            if standardUnits == UnitsOfMeasurement.Units.Teaspoon {
                multiplier = (1/4.929)
            } else if standardUnits == UnitsOfMeasurement.Units.Tablespoon {
                multiplier = (1/14.787)
            } else if standardUnits == UnitsOfMeasurement.Units.Cup {
                multiplier = (1/240)
            } else if standardUnits == UnitsOfMeasurement.Units.Ounce {
                multiplier = (1/29.574)
            } else if standardUnits == UnitsOfMeasurement.Units.Pound {
                multiplier = (1/0.0022)
            } else if standardUnits == UnitsOfMeasurement.Units.FluidOunce {
                multiplier = (1/29.574)
            } else if standardUnits == UnitsOfMeasurement.Units.Pint {
                multiplier = (1/473.2)
            } else if standardUnits == UnitsOfMeasurement.Units.Quart {
                multiplier = (1/946.4)
            } else if standardUnits == UnitsOfMeasurement.Units.Gallon {
                multiplier = (1/3785)
            } else if standardUnits == UnitsOfMeasurement.Units.Liter {
                multiplier = (1/1000)
            } else if standardUnits == UnitsOfMeasurement.Units.Milliliter {
                multiplier = 1
            }
        } else if measuredUnits == UnitsOfMeasurement.Units.Gram {
            if standardUnits == UnitsOfMeasurement.Units.Gram {
                multiplier = 1
            } else if standardUnits == UnitsOfMeasurement.Units.Kilogram {
                multiplier = (1/1000)
            }
        } else if measuredUnits == UnitsOfMeasurement.Units.Kilogram {
            if standardUnits == UnitsOfMeasurement.Units.Gram {
                multiplier = 1000
            } else if standardUnits == UnitsOfMeasurement.Units.Kilogram {
                multiplier = 1
            }
        } else if measuredUnits == UnitsOfMeasurement.Units.Whole {
            if standardUnits == UnitsOfMeasurement.Units.Whole {
                multiplier = 1
            }
        }
        return amount * multiplier
    }
    
}

