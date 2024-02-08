//
//  ConverterViewController.swift
//  Home Bake Shop Assistant
//
//  Created by Brett Buchholz on 2/7/24.
//

import UIKit

class ConverterViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var converterTitleLabel: PaddingLabel!
    @IBOutlet weak var startingAmountLabel: PaddingLabel!
    @IBOutlet weak var startingAmountStackView: UIStackView!
    @IBOutlet weak var startingUnitsStackView: UIStackView!
    @IBOutlet weak var endingUnitsStackView: UIStackView!
    @IBOutlet weak var fractionsStackView: UIStackView!
    
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var startingUnitsPopUpButton: UIButton!
    @IBOutlet weak var endingUnitsPopUpButton: UIButton!
    @IBOutlet weak var convertButton: BrettButton!
    @IBOutlet weak var outputLabel: PaddingLabel!
    
    var selectedStartingUnit: UnitsOfMeasurement.Units? = nil
    var selectedConvertedUnit: UnitsOfMeasurement.Units? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Style the view
        converterTitleLabel.clipsToBounds = true
        AddBorders().addAllBorders(with: K.bakeShopBlack, andWidth: 2.0, view: converterTitleLabel)
        AddBorders().addLeftBorder(with: K.bakeShopBlack, andWidth: 2.0, view: startingAmountLabel)
        AddBorders().addTopBorder(with: K.bakeShopBlack, andWidth: 2.0, view: startingAmountLabel)
        AddBorders().addBottomBorder(with: K.bakeShopBlack, andWidth: 2.0, view: startingAmountLabel)
        AddBorders().addRightBorder(with: K.bakeShopBlack, andWidth: 2.0, view: amountTextField)
        AddBorders().addTopBorder(with: K.bakeShopBlack, andWidth: 2.0, view: amountTextField)
        AddBorders().addBottomBorder(with: K.bakeShopBlack, andWidth: 2.0, view: amountTextField)
        AddBorders().addAllBorders(with: K.bakeShopBlack, andWidth: 2.0, view: startingUnitsStackView)
        AddBorders().addAllBorders(with: K.bakeShopBlack, andWidth: 2.0, view: endingUnitsStackView)
        AddBorders().addAllBorders(with: K.bakeShopBlack, andWidth: 2.0, view: fractionsStackView)
        convertButton.tintColor = K.systemBackground
        convertButton.configuration?.baseForegroundColor = K.bakeShopBlack
        
        //Register delegates, data sources and Nibs
        amountTextField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        outputLabel.isHidden = true
        outputLabel.textColor = K.bakeShopBlack
        setupStartingUnitsButton()
        setupConvertedUnitsButton()
    }
    
    func setupStartingUnitsButton() {
        var chirren: [UIMenuElement] = []
        for unit in UnitsOfMeasurement.Units.allCases {
            let currentUnit: UnitsOfMeasurement.Units = unit
            var stringUnit = ""
            if unit == UnitsOfMeasurement.Units.Whole || unit == UnitsOfMeasurement.Units.None {
                stringUnit = UnitsOfMeasurement().convertUnitsToString(unit: unit)
            } else {
                stringUnit = "\(UnitsOfMeasurement().convertUnitsToString(unit: unit))s"
            }
            chirren.append(UIAction(title: stringUnit) { (action: UIAction) in
                self.selectedStartingUnit = currentUnit
            })
        }
        startingUnitsPopUpButton.menu = UIMenu(children: chirren)
    }
    
    func setupConvertedUnitsButton() {
        var chirren: [UIMenuElement] = []
        for unit in UnitsOfMeasurement.Units.allCases {
            let currentUnit: UnitsOfMeasurement.Units = unit
            var stringUnit = ""
            if unit == UnitsOfMeasurement.Units.Whole || unit == UnitsOfMeasurement.Units.None {
                stringUnit = UnitsOfMeasurement().convertUnitsToString(unit: unit)
            } else {
                stringUnit = "\(UnitsOfMeasurement().convertUnitsToString(unit: unit))s"
            }
            chirren.append(UIAction(title: stringUnit) { (action: UIAction) in
                self.selectedConvertedUnit = currentUnit
            })
        }
        endingUnitsPopUpButton.menu = UIMenu(children: chirren)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newString = (amountTextField.text! as NSString).replacingCharacters(in: range, with: string)
        let decimalRegex = try! NSRegularExpression(pattern: "^\\d*\\.?\\d{0,3}$", options: [])
        let matches = decimalRegex.matches(in: newString, options: [], range: NSMakeRange(0, newString.count))
        if matches.count == 1 {
            return true
        }
        return false
    }
    
    func ableToConvert() -> Bool {
        if selectedStartingUnit == .Whole && selectedConvertedUnit != .Whole {
            return false
        } else if selectedConvertedUnit == .Whole && selectedStartingUnit != .Whole {
            return false
        } else if selectedStartingUnit == .Gram {
            if selectedConvertedUnit == .Gram {
                return true
            } else if selectedConvertedUnit == .Kilogram {
                return true
            } else {
                return false
            }
        } else if selectedConvertedUnit == .Gram {
            if selectedStartingUnit == .Gram {
                return true
            } else if selectedStartingUnit == .Kilogram {
                return true
            } else {
                return false
            }
        } else if selectedStartingUnit == .Kilogram {
            if selectedConvertedUnit == .Gram {
                return true
            } else if selectedConvertedUnit == .Kilogram {
                return true
            } else {
                return false
            }
        } else if selectedConvertedUnit == .Kilogram {
            if selectedStartingUnit == .Gram {
                return true
            } else if selectedStartingUnit == .Kilogram {
                return true
            } else {
                return false
            }
        } else {
            return true
        }
    }
    
    @IBAction func convertButtonPressed(_ sender: BrettButton) {
        amountTextField.resignFirstResponder()
        outputLabel.isHidden = true
        outputLabel.textColor = K.bakeShopBlack
        
        //Validate the data then get updated amount
        if amountTextField.text == "" {
            outputLabel.isHidden = false
            outputLabel.textColor = K.bakeShopDeleteRed
            outputLabel.text = "Please enter an amount to convert"
        } else if selectedStartingUnit == .None || selectedStartingUnit == nil {
            outputLabel.isHidden = false
            outputLabel.textColor = K.bakeShopDeleteRed
            outputLabel.text = "Please select the starting units"
        } else if selectedConvertedUnit == .None || selectedConvertedUnit == nil {
            outputLabel.isHidden = false
            outputLabel.textColor = K.bakeShopDeleteRed
            outputLabel.text = "Please select the ending units"
        } else if ableToConvert() == false {
            outputLabel.isHidden = false
            outputLabel.textColor = K.bakeShopDeleteRed
            outputLabel.text = "Unable to convert \(selectedStartingUnit!)s to \(selectedConvertedUnit!)s!"
        } else {
            outputLabel.isHidden = false
            let floatAmount = StringConverter().convertInventoryStringToFloat(inventoryString: amountTextField.text ?? "0")
            let convertedAmount = UnitsConverter(amount: floatAmount, measuredUnits: selectedStartingUnit!, standardUnits: selectedConvertedUnit!).convertUnits()
            let stringAmount = StringConverter().convertInventoryFloatToString(inventoryFloat: convertedAmount)
            var stringStartingUnits = ""
            var stringEndingUnits = ""
            if floatAmount == 1 {
                stringStartingUnits = "\(selectedStartingUnit!)"
            } else {
                stringStartingUnits = "\(selectedStartingUnit!)s"
            }
            if convertedAmount == 1 {
                stringEndingUnits = "\(selectedConvertedUnit!)"
            } else {
                stringEndingUnits = "\(selectedConvertedUnit!)s"
            }
            outputLabel.text = "\(amountTextField.text!) \(stringStartingUnits) converts to \(stringAmount) \(stringEndingUnits)"
        }
    }
    
}
