//
//  OrderViewController.swift
//  Home Bake Shop Assistant
//
//  Created by Brett Buchholz on 1/8/24.
//

import UIKit
import CoreData

class OrderViewController: UIViewController {
    
    @IBOutlet weak var companyNameLabel: PaddingLabel!
    @IBOutlet weak var companyAddressLabel: PaddingLabel!
    @IBOutlet weak var companyCityStateZipLabel: PaddingLabel!
    
    @IBOutlet weak var customerNameLabel: PaddingLabel!
    @IBOutlet weak var customerAddressLabel: PaddingLabel!
    @IBOutlet weak var customerCityStateZipLabel: PaddingLabel!
    @IBOutlet weak var customerPhoneLabel: PaddingLabel!
    
    @IBOutlet weak var orderDateValue: PaddingLabel!
    @IBOutlet weak var orderNumberValue: PaddingLabel!
    
    @IBOutlet weak var subtotalAmountLabel: PaddingLabel!
    @IBOutlet weak var salesTaxLabel: PaddingLabel!
    @IBOutlet weak var salesTaxAmountLabel: PaddingLabel!
    @IBOutlet weak var totalAmountLabel: PaddingLabel!
    
    @IBOutlet weak var topBackgroundView: UIView!
    @IBOutlet weak var headerStackView: UIStackView!
    @IBOutlet weak var orderTableView: UITableView!
    @IBOutlet weak var subtotalStackView: UIStackView!
    @IBOutlet weak var salesTaxStackView: UIStackView!
    @IBOutlet weak var totalsView: UIView!
    
    @IBOutlet weak var editOrderButton: BrettButton!
    @IBOutlet weak var deleteOrderButton: BrettButton!
    @IBOutlet weak var printableInvoiceButton: BrettButton!
    
    var loadedOrder: Order? = nil
    var orderedItems: [OrderedItem] = []
    var loadedCompany: [Company] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Style The View
        AddBorders().addAllBorders(with: K.bakeShopBlueberry, andWidth: 2.0, view: topBackgroundView)
        AddBorders().addAllBorders(with: K.bakeShopBlueberry, andWidth: 2.0, view: orderTableView)
        AddBorders().addTopBorder(with: K.bakeShopBlueberry, andWidth: 2.0, view: headerStackView)
        AddBorders().addLeftBorder(with: K.bakeShopBlueberry, andWidth: 2.0, view: headerStackView)
        AddBorders().addRightBorder(with: K.bakeShopBlueberry, andWidth: 2.0, view: headerStackView)
        if K.interfaceMode == .phone {
            AddBorders().addBottomBorder(with: K.bakeShopBlueberry, andWidth: 2.0, view: totalsView)
            AddBorders().addLeftBorder(with: K.bakeShopBlueberry, andWidth: 2.0, view: totalsView)
            AddBorders().addRightBorder(with: K.bakeShopBlueberry, andWidth: 2.0, view: totalsView)
        }
        editOrderButton.tintColor = K.bakeShopBlueberry
        printableInvoiceButton.tintColor = K.bakeShopBlueberry
        deleteOrderButton.tintColor = K.bakeShopDeleteRed
                
        //Register delegates, data sources and Nibs
        orderTableView.dataSource = self
        orderTableView.register(UINib(nibName: K.orderCellNibName, bundle: nil), forCellReuseIdentifier: K.orderReuseIdentifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        orderedItems = loadedOrder?.toOrderedItem?.allObjects as! [OrderedItem]
        orderedItems = orderedItems.sorted {$0.toRecipe!.name! < $1.toRecipe!.name!}
        loadLabelData()
        DispatchQueue.main.async {
            self.orderTableView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.segueIdentifierToEditOrder {
            let destinationVC = segue.destination as! EditOrderViewController
            let originVC = segue.source as! OrderViewController
            destinationVC.segueOrder = loadedOrder
            destinationVC.segueVC = originVC
        }
        if segue.identifier == K.segueIdentifierToPrintableInvoice {
            let destinationVC = segue.destination as! PrintableInvoiceViewController
            destinationVC.loadedOrder = loadedOrder
        }
    }
    
    
    func loadLabelData() {
        loadCompanyInfo()
        if loadedCompany != [] {
            companyNameLabel.text = loadedCompany[0].name
            companyAddressLabel.text = loadedCompany[0].address
            companyCityStateZipLabel.text = "\(loadedCompany[0].city ?? ""), \(loadedCompany[0].state ?? "") \(loadedCompany[0].zipCode ?? "")"
        }
        
        let customer = loadedOrder?.toCustomer
        customerNameLabel.text = "\(customer!.firstName ?? "unknown") \(customer!.lastName ?? "unknown")"
        customerAddressLabel.text = customer?.customerAddress
        customerCityStateZipLabel.text = "\(customer?.customerCity ?? ""), \(customer?.customerState ?? "") \(customer?.customerZipCode ?? "")"
        customerPhoneLabel.text = customer?.customerPhone
        
        let date = loadedOrder?.orderDate
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yy"
        let stringDate = dateFormatter.string(from: date!)
        orderDateValue.text = stringDate
        orderNumberValue.text = loadedOrder?.orderNumber
        
        if loadedOrder?.orderSalesTax == 0 {
            subtotalStackView.isHidden = true
            salesTaxStackView.isHidden = true
        } else {
            subtotalStackView.isHidden = false
            salesTaxStackView.isHidden = false
            salesTaxLabel.text = "Sales Tax (\(loadedCompany[0].taxRate)%)"
            salesTaxAmountLabel.text = StringConverter().convertCurrencyFloatToString(floatCurrency: loadedOrder!.orderSalesTax)
            subtotalAmountLabel.text = StringConverter().convertCurrencyFloatToString(floatCurrency: loadedOrder!.orderSubtotal)
        }
        totalAmountLabel.text = StringConverter().convertCurrencyFloatToString(floatCurrency: loadedOrder!.orderTotal)
    }
    
    @IBAction func editOrderPressed(_ sender: BrettButton) {
        performSegue(withIdentifier: K.segueIdentifierToEditOrder, sender: self)
    }
    
    @IBAction func deleteOrderPressed(_ sender: BrettButton) {
        let alert = UIAlertController(title: "", message: "Are you sure you want to delete this order?", preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "Dismiss", style: .default) { action in
            //Dismiss alert
        }
        alert.addAction(dismissAction)
        let deleteAction = UIAlertAction(title: "Delete", style: .default) { action in
            K.ordersContext.delete(self.loadedOrder!)
            self.saveOrder()
            self.navigationController?.popViewController(animated: true)
        }
        alert.addAction(deleteAction)
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: CoreData CRUD Methods
    
    func saveOrder() {
        do {
            try K.ordersContext.save()
        } catch {
            print("Error saving Ingredients: \(error)")
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

//MARK: TableView DataSource Methods

extension OrderViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        orderedItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = orderTableView.dequeueReusableCell(withIdentifier: K.orderReuseIdentifier, for: indexPath) as! OrderTableViewCell
        let item = orderedItems[indexPath.row]
        cell.qtyLabel.text = "\(item.quantityOrdered)"
        let recipeName = (item.toRecipe!).name
        cell.itemOrderedLabel.text = "\(recipeName!) \(item.batchName!)"
        let floatPrice = item.batchPrice
        cell.batchPriceLabel.text = StringConverter().convertCurrencyFloatToString(floatCurrency: floatPrice)
        let floatSubtotal = item.batchSubtotal
        cell.subtotalLabel.text = StringConverter().convertCurrencyFloatToString(floatCurrency: floatSubtotal)
        let itemNote = item.itemNote
        if itemNote == "" {
            cell.bottomStackView.isHidden = true
        } else {
            cell.itemNoteLabel.text = "    Note: \(itemNote ?? "")"
        }
        
        return cell
    }
    
}


