//
//  CompanyInfoViewController.swift
//  Home Bake Shop Assistant
//
//  Created by Brett Buchholz on 12/26/23.
//

import UIKit
import CoreData

class CompanyInfoViewController: UIViewController {
    
    @IBOutlet weak var companyInfoTitleLabel: PaddingLabel!
    @IBOutlet weak var nameStackView: UIStackView!
    @IBOutlet weak var addressStackView: UIStackView!
    @IBOutlet weak var cityStackView: UIStackView!
    @IBOutlet weak var stateStackView: UIStackView!
    @IBOutlet weak var zipStackView: UIStackView!
    @IBOutlet weak var taxStackView: UIStackView!
    @IBOutlet weak var taxRateStackView: UIStackView!
    
    @IBOutlet weak var companyNameTextField: UITextField!
    @IBOutlet weak var companyAddressTextField: UITextField!
    @IBOutlet weak var companyCityTextField: UITextField!
    @IBOutlet weak var companyStateTextField: UITextField!
    @IBOutlet weak var companyZipCodeTextField: UITextField!
    @IBOutlet weak var chargeSalesTaxSwitch: UISwitch!
    @IBOutlet weak var taxRateTextField: UITextField!
    @IBOutlet weak var saveInfoButton: BrettButton!
    
    var loadedCompany: [Company] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Style The View
        AddBorders().addAllBorders(with: K.bakeShopBlueberry, andWidth: 2.0, view: companyInfoTitleLabel)
        AddBorders().addAllBorders(with: K.bakeShopBlueberry, andWidth: 2.0, view: nameStackView)
        AddBorders().addAllBorders(with: K.bakeShopBlueberry, andWidth: 2.0, view: addressStackView)
        AddBorders().addAllBorders(with: K.bakeShopBlueberry, andWidth: 2.0, view: cityStackView)
        AddBorders().addAllBorders(with: K.bakeShopBlueberry, andWidth: 2.0, view: stateStackView)
        AddBorders().addAllBorders(with: K.bakeShopBlueberry, andWidth: 2.0, view: zipStackView)
        AddBorders().addAllBorders(with: K.bakeShopBlueberry, andWidth: 2.0, view: taxStackView)
        AddBorders().addAllBorders(with: K.bakeShopBlueberry, andWidth: 2.0, view: taxRateStackView)
        companyInfoTitleLabel.layer.masksToBounds = true
        saveInfoButton.tintColor = K.bakeShopBlueberry
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadCompanyInfo()
        loadTextFields()
    }
    
    func loadTextFields() {
        if loadedCompany != [] {
            let comp = loadedCompany[0]
            companyNameTextField.text = comp.name
            companyAddressTextField.text = comp.address
            companyCityTextField.text = comp.city
            companyStateTextField.text = comp.state
            companyZipCodeTextField.text = comp.zipCode
            if comp.withholdTax == true {
                chargeSalesTaxSwitch.isOn = true
            } else {
                chargeSalesTaxSwitch.isOn = false
            }
            taxRateTextField.text = "\(comp.taxRate)%"
        }
    }
    
    @IBAction func saveInfoPressed(_ sender: BrettButton) {
        let companyInfo: Company
        if loadedCompany != [] {
            companyInfo = loadedCompany[0]
        } else {
            companyInfo = Company(context: K.companyInfoContext)
        }
        companyInfo.name = companyNameTextField.text
        companyInfo.address = companyAddressTextField.text
        companyInfo.city = companyCityTextField.text
        companyInfo.state = companyStateTextField.text
        companyInfo.zipCode = companyZipCodeTextField.text
        if chargeSalesTaxSwitch.isOn == true {
            companyInfo.withholdTax = true
        } else {
            companyInfo.withholdTax = false
        }
        let stringTaxRate = taxRateTextField.text?.replacingOccurrences(of: "%", with: "")
        companyInfo.taxRate = (stringTaxRate! as NSString).floatValue
        saveCompanyInfo()
        loadCompanyInfo()
        navigationController?.popViewController(animated: true)
    }
    
    //MARK: CoreData CRUD Methods
    
    func saveCompanyInfo() {
        do {
            try K.companyInfoContext.save()
        } catch {
            print("Error saving Recipe: \(error)")
        }
    }
    
    func loadCompanyInfo() {
        let request: NSFetchRequest<Company> = Company.fetchRequest()
        do {
            loadedCompany = try K.companyInfoContext.fetch(request)
        } catch {
            print("Error loading Recipe: \(error)")
        }
    }
    
}
