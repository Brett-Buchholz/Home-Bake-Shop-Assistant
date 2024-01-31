//
//  OrdersViewController.swift
//  Home Bake Shop Assistant
//
//  Created by Brett Buchholz on 12/23/23.
//

import UIKit
import CoreData
import SwipeCellKit

class OrderListViewController: UIViewController {
    
    @IBOutlet weak var orderSegmentedControl: UISegmentedControl!
    @IBOutlet weak var controlView: UIView!
    @IBOutlet weak var orderTableView: UITableView!
    @IBOutlet weak var headerStackView: UIStackView!
    
    var ordersList: [Order] = []
    var segControlList: [Order] = []
    var segueOrder: Order? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Style The View
        AddBorders().addAllBorders(with: K.bakeShopBlueberry, andWidth: 2.0, view: orderTableView)
        AddBorders().addAllBorders(with: K.bakeShopBlueberry, andWidth: 2.0, view: controlView)
        AddBorders().addTopBorder(with: K.bakeShopBlueberry, andWidth: 2.0, view: headerStackView)
        AddBorders().addLeftBorder(with: K.bakeShopBlueberry, andWidth: 2.0, view: headerStackView)
        AddBorders().addRightBorder(with: K.bakeShopBlueberry, andWidth: 2.0, view: headerStackView)
        orderSegmentedControl.setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "Times New Roman Bold", size: 30.0)!, NSAttributedString.Key.foregroundColor: K.bakeShopBlueberry], for: .normal)
        orderTableView.rowHeight = 65.0
        
        //Register delegates, data sources and Nibs
        orderTableView.delegate = self
        orderTableView.dataSource = self
        orderTableView.register(UINib(nibName: K.orderListCellNibName, bundle: nil), forCellReuseIdentifier: K.orderListReuseIdentifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadOrders()
        orderSegmentedControlUpdated(orderSegmentedControl)
        updateData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.segueIdentifierToViewOrder {
            let destinationVC = segue.destination as! OrderViewController
            destinationVC.loadedOrder = segueOrder
        }
    }
    
    func adjustForInventoryUsed() {
        loadOrders()
        let order = ordersList[0]
        
        //saveIngredients()
    }
    
    @IBAction func orderSegmentedControlUpdated(_ sender: UISegmentedControl) {
        
        let pendingOrders = ordersList.filter({ $0.orderComplete == false })
        let completeOrders = ordersList.filter({ $0.orderComplete == true })
        
        switch orderSegmentedControl.selectedSegmentIndex {
        case 1:
            segControlList = completeOrders.sorted {$0.orderNumber! > $1.orderNumber!}
            updateData()
        default:
            segControlList = pendingOrders.sorted {$0.orderNumber! < $1.orderNumber!}
            updateData()
        }
    }
    
    //MARK: CoreData CRUD Methods
    
    func saveOrders() {
        do {
            try K.ordersContext.save()
        } catch {
            print("Error saving Ingredients: \(error)")
        }
    }
    
    func loadOrders() {
        let request: NSFetchRequest<Order> = Order.fetchRequest()
        let orderNumberSort = NSSortDescriptor(key:"orderNumber", ascending:true)
        request.sortDescriptors = [orderNumberSort]
        do {
            ordersList = try K.ordersContext.fetch(request)
        } catch {
            print("Error loading Ingredients: \(error)")
        }
    }
    
    func updateData() {
        DispatchQueue.main.async {
            self.orderTableView.reloadData()
        }
    }
}

//MARK: TableView DataSource Methods

extension OrderListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        segControlList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = orderTableView.dequeueReusableCell(withIdentifier: K.orderListReuseIdentifier, for: indexPath) as! OrderListTableViewCell
        cell.delegate = self
        let order = segControlList[indexPath.row]
        let date = order.orderDate!
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/DD/YY"
        let orderDate = dateFormatter.string(from: date)
        let customer = "\(order.toCustomer?.firstName ?? "unknown") \(order.toCustomer?.lastName ?? "unknown")"
        cell.label1.text = "\(order.orderNumber!)"
        cell.label2.text = "\(orderDate)"
        cell.label3.text = "\(customer)"
        cell.label4.text = String(format: "$%.2f", order.orderTotal)
        
        return cell
    }
    
}

extension OrderListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        segueOrder = segControlList[indexPath.row]
        performSegue(withIdentifier: K.segueIdentifierToViewOrder, sender: self)
    }
}

//MARK: Swipe Cell Kit Functionality

extension OrderListViewController: SwipeTableViewCellDelegate {
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let completeAction = SwipeAction(style: .default, title: "Order\nComplete") { action, indexPath in
            let order = self.segControlList[indexPath.row]
            order.orderComplete = true
            var orderedItemsList: [OrderedItem] = []
            for item in (order.toOrderedItem?.allObjects as! [OrderedItem]) {
                orderedItemsList.append(item)
            }
            for item in orderedItemsList {
                for ingredient in (item.toRecipe?.toRecipeIngredient?.allObjects as! [RecipeIngredient]){
                    let measuredUnits:UnitsOfMeasurement.Units = UnitsOfMeasurement().convertStringToUnits(string: ingredient.units!)
                    let standardUnits:UnitsOfMeasurement.Units = UnitsOfMeasurement().convertStringToUnits(string: (ingredient.inventory?.baseUnit)!)
                    let floatQuantity = Float(item.quantityOrdered) * ingredient.quantity
                    let neededAmount = UnitsConverter(amount: floatQuantity, measuredUnits: measuredUnits, standardUnits: standardUnits).convertUnits()
                    ingredient.inventory?.amountOnHand -= neededAmount
                }
            }
            self.saveOrders()
            self.orderSegmentedControlUpdated(self.orderSegmentedControl)
            self.updateData()
        }
        
        let pendingAction = SwipeAction(style: .default, title: "Order\nPending") { action, indexPath in
            let order = self.segControlList[indexPath.row]
            order.orderComplete = false
            var orderedItemsList: [OrderedItem] = []
            for item in (order.toOrderedItem?.allObjects as! [OrderedItem]) {
                orderedItemsList.append(item)
            }
            for item in orderedItemsList {
                for ingredient in (item.toRecipe?.toRecipeIngredient?.allObjects as! [RecipeIngredient]){
                    let measuredUnits:UnitsOfMeasurement.Units = UnitsOfMeasurement().convertStringToUnits(string: ingredient.units!)
                    let standardUnits:UnitsOfMeasurement.Units = UnitsOfMeasurement().convertStringToUnits(string: (ingredient.inventory?.baseUnit)!)
                    let floatQuantity = Float(item.quantityOrdered) * ingredient.quantity
                    let neededAmount = UnitsConverter(amount: floatQuantity, measuredUnits: measuredUnits, standardUnits: standardUnits).convertUnits()
                    ingredient.inventory?.amountOnHand += neededAmount
                }
            }
            self.saveOrders()
            self.orderSegmentedControlUpdated(self.orderSegmentedControl)
            self.updateData()
        }
        
        // customize the action appearance
        completeAction.backgroundColor = K.bakeShopBlueberry
        pendingAction.backgroundColor = K.bakeShopBlueberry
        completeAction.font = UIFont(name: "Times New Roman", size: 20.0)
        pendingAction.font = UIFont(name: "Times New Roman", size: 20.0)
        
        if orderSegmentedControl.selectedSegmentIndex == 1 {
            return [pendingAction]
        } else {
            return [completeAction]
        }
        
    }
}
