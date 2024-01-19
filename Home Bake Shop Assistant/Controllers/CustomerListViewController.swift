//
//  CustomerViewController.swift
//  Home Bake Shop Assistant
//
//  Created by Brett Buchholz on 12/28/23.
//

import UIKit
import CoreData

class CustomerListViewController: UIViewController {
    
    @IBOutlet weak var customerListTitleLabel: PaddingLabel!
    @IBOutlet weak var createCustomerView: UIView!
    @IBOutlet weak var customerListTableView: UITableView!
    
    var customerList: [Customer] = []
    var segueLoadedCustomer: Customer? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Style The View
        AddBorders().addAllBorders(with: K.bakeShopBlueberry, andWidth: 2.0, view: createCustomerView)
        AddBorders().addAllBorders(with: K.bakeShopBlueberry, andWidth: 2.0, view: customerListTableView)
        AddBorders().addAllBorders(with: K.bakeShopBlueberry, andWidth: 2.0, view: customerListTitleLabel)
        customerListTitleLabel.layer.masksToBounds = true
        customerListTableView.rowHeight = 50
        
        //Register delegates, data sources and Nibs
        customerListTableView.dataSource = self
        customerListTableView.delegate = self
        customerListTableView.register(UINib(nibName: K.customerCellNibName, bundle: nil), forCellReuseIdentifier: K.customerReuseIdentifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadDataAndView()
        navigationController?.navigationBar.tintColor = .systemBackground
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.tintColor = .bakeShopBlack
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.segueIdentifierToCustomerInfo {
            let destinationVC = segue.destination as! EditCustomerViewController
            destinationVC.loadedCustomer = segueLoadedCustomer
        }
    }
    
    //MARK: CoreData CRUD Methods
    
    func saveCustomerInfo() {
        do {
            try K.customerInfoContext.save()
        } catch {
            print("Error saving Recipe: \(error)")
        }
    }
    
    func loadCustomerList() {
        let request: NSFetchRequest<Customer> = Customer.fetchRequest()
        let lastNameSort = NSSortDescriptor(key:"lastName", ascending:true)
        let firstNameSort = NSSortDescriptor(key:"firstName", ascending:true)
        request.sortDescriptors = [lastNameSort, firstNameSort]
        do {
            customerList = try K.customerInfoContext.fetch(request)
        } catch {
            print("Error loading Recipe: \(error)")
        }
    }
    
    func loadDataAndView() {
        DispatchQueue.main.async {
            self.loadCustomerList()
            self.customerListTableView.reloadData()
        }
    }
}

//MARK: TableView DataSource Methods

extension CustomerListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        customerList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = customerListTableView.dequeueReusableCell(withIdentifier: K.customerReuseIdentifier, for: indexPath) as! CustomerTableViewCell
        cell.customerLabel.text = "\(customerList[indexPath.row].lastName ?? "last name"), \(customerList[indexPath.row].firstName ?? "first name")"
        
        return cell
    }
    
}

extension CustomerListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        segueLoadedCustomer = customerList[indexPath.row]
        performSegue(withIdentifier: K.segueIdentifierToCustomerInfo, sender: self)
    }
}

