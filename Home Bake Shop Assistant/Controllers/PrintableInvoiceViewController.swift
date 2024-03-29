//
//  PrintableInvoiceViewController.swift
//  Home Bake Shop Assistant
//
//  Created by Brett Buchholz on 1/11/24.
//

import UIKit
import CoreData
import PDFKit

class PrintableInvoiceViewController: UIViewController, PDFViewDelegate {
    
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
    @IBOutlet weak var subtotalStackView: UIStackView!
    @IBOutlet weak var salesTaxStackView: UIStackView!
    @IBOutlet weak var innerScrollView: UIView!
    @IBOutlet weak var orderTableView: UITableView!
    
    let pdfView = PDFView()
    let newDocument = PDFDocument()
    var loadedOrder: Order? = nil
    var orderedItems: [OrderedItem] = []
    var loadedCompany: [Company] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Style The View
        AddBorders().addAllBorders(with: K.bakeShopBlack, andWidth: 2.0, view: topBackgroundView)
        AddBorders().addAllBorders(with: K.bakeShopBlack, andWidth: 2.0, view: orderTableView)
        AddBorders().addTopBorder(with: K.bakeShopBlack, andWidth: 2.0, view: headerStackView)
        AddBorders().addLeftBorder(with: K.bakeShopBlack, andWidth: 2.0, view: headerStackView)
        AddBorders().addRightBorder(with: K.bakeShopBlack, andWidth: 2.0, view: headerStackView)
        
        //Register delegates, data sources and Nibs
        orderTableView.dataSource = self
        orderTableView.register(UINib(nibName: K.printableInvoiceCellNibName, bundle: nil), forCellReuseIdentifier: K.printableInvoiceReuseIdentifier)
        orderedItems = loadedOrder?.toOrderedItem?.allObjects as! [OrderedItem]
        orderedItems = orderedItems.sorted {$0.toRecipe!.name! < $1.toRecipe!.name!}
        loadLabelData()
        
        //Create an image of the invoice from a view
        let imageView = UIView(frame: CGRect(x: 0, y: 0, width: 850, height: 1100))
        imageView.addSubview(innerScrollView)
        innerScrollView.translatesAutoresizingMaskIntoConstraints = false
        innerScrollView.leftAnchor.constraint(equalTo: imageView.leftAnchor).isActive = true
        innerScrollView.topAnchor.constraint(equalTo: imageView.topAnchor).isActive = true
        innerScrollView.rightAnchor.constraint(equalTo: imageView.rightAnchor).isActive = true
        innerScrollView.bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -25).isActive = true
        imageView.layoutIfNeeded()
        let image = imageView.asImage()
        
        //Use PDFKit to create a pdf invoice
        view.addSubview(pdfView)
        pdfView.document = newDocument
        pdfView.delegate = self
        let page = PDFPage(image: image)!
        newDocument.insert(page, at: 0)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        pdfView.frame = view.bounds
    }
    
    func loadLabelData() {
        loadCompanyInfo()
        if loadedCompany == [] {
            companyNameLabel.text = "Company Name"
            companyAddressLabel.text = " "
            companyCityStateZipLabel.text = " "
        } else {
            companyNameLabel.text = loadedCompany[0].name
            companyAddressLabel.text = loadedCompany[0].address
            companyCityStateZipLabel.text = "\(loadedCompany[0].city ?? ""), \(loadedCompany[0].state ?? "") \(loadedCompany[0].zipCode ?? "")"
        }
        
        let customer = loadedOrder?.toCustomer
        customerNameLabel.text = "\(customer!.firstName ?? "unknown") \(customer!.lastName ?? "unknown")"
        if customer?.customerAddress == "" {
            customerAddressLabel.text = " "
        } else {
            customerAddressLabel.text = customer?.customerAddress
        }
        let custCity = customer?.customerCity ?? ""
        let custState = customer?.customerState ?? ""
        let custZip = customer?.customerZipCode ?? ""
        if custCity == "" && custState == "" && custZip == "" {
            customerCityStateZipLabel.text = " "
        } else if custCity == "" {
            customerCityStateZipLabel.text = "\(custCity) \(custState) \(custZip)"
        } else {
            customerCityStateZipLabel.text = "\(custCity), \(custState) \(custZip)"
        }
        if customer?.customerPhone == "" {
            customerPhoneLabel.text = " "
        } else {
            customerPhoneLabel.text = customer?.customerPhone
        }
        
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
    
    @IBAction func shareInvoicePressed(_ sender: UIBarButtonItem) {
        let shareDocument = newDocument.dataRepresentation()
        let itemToShare = [shareDocument]
        let activityViewController = UIActivityViewController(activityItems: itemToShare as [Any], applicationActivities: nil)
        if UIDevice.current.userInterfaceIdiom == .pad {
                if activityViewController.responds(to: #selector(getter: UIViewController.popoverPresentationController)) {
                    activityViewController.popoverPresentationController?.barButtonItem = sender
                }
            }
        self.present(activityViewController, animated: true, completion: nil)
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

extension PrintableInvoiceViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        orderedItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = orderTableView.dequeueReusableCell(withIdentifier: K.printableInvoiceReuseIdentifier, for: indexPath) as! PrintableInvoiceTableViewCell
        let item = orderedItems[indexPath.row]
        cell.qtyLabel.text = "\(item.quantityOrdered)"
        cell.qtyLabel.textColor = K.bakeShopBlack
        let recipeName = (item.toRecipe!).name
        cell.itemOrderedLabel.text = "\(recipeName!) \(item.batchName!)"
        cell.itemOrderedLabel.textColor = K.bakeShopBlack
        let floatPrice = item.batchPrice
        cell.batchPriceLabel.text = StringConverter().convertCurrencyFloatToString(floatCurrency: floatPrice)
        cell.batchPriceLabel.textColor = K.bakeShopBlack
        let floatSubtotal = item.batchSubtotal
        cell.subtotalLabel.text = StringConverter().convertCurrencyFloatToString(floatCurrency: floatSubtotal)
        cell.subtotalLabel.textColor = K.bakeShopBlack
        let itemNote = item.itemNote
        if itemNote == "" {
            cell.bottomStackView.isHidden = true
        } else {
            cell.itemNoteLabel.text = "    Note: \(itemNote ?? "")"
        }
        cell.itemNoteLabel.textColor = K.bakeShopBlack
        
        return cell
    }
    
}

extension UIView {

    // Using a function since `var image` might conflict with an existing variable
    // (like on `UIImageView`)
    func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}
