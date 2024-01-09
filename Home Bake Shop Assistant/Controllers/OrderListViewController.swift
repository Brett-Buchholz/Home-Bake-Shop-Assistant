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
        orderTableView.rowHeight = 50.0
        
        //Register delegates, data sources and Nibs
        orderTableView.delegate = self
        orderTableView.dataSource = self
        orderTableView.register(UINib(nibName: K.orderListCellNibName, bundle: nil), forCellReuseIdentifier: K.orderListReuseIdentifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadOrders()
        updateData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.segueIdentifierToViewOrder {
            let destinationVC = segue.destination as! OrderViewController
            destinationVC.loadedOrder = segueOrder
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
        ordersList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = orderTableView.dequeueReusableCell(withIdentifier: K.orderListReuseIdentifier, for: indexPath) as! OrderListTableViewCell
        cell.delegate = self
        let order = ordersList[indexPath.row]
        let date = order.orderDate!
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/DD/YY"
        let orderDate = dateFormatter.string(from: date)
        let customer = "\(order.toCustomer?.firstName ?? "unknown") \(order.toCustomer?.lastName ?? "unknown")"
        cell.label1.text = "\(order.orderNumber!)"
        cell.label1.textColor = K.bakeShopBlueberry
        cell.label2.text = "\(orderDate)"
        cell.label2.textColor = K.bakeShopBlueberry
        cell.label3.text = "\(customer)"
        cell.label3.textColor = K.bakeShopBlueberry
        cell.label4.text = String(format: "$%.2f", order.orderTotal)
        cell.label4.textColor = K.bakeShopBlueberry
        cell.label1.font =  UIFont(name: "Times New Roman", size: 30)
        cell.label2.font =  UIFont(name: "Times New Roman", size: 30)
        cell.label3.font =  UIFont(name: "Times New Roman", size: 30)
        cell.label4.font =  UIFont(name: "Times New Roman", size: 30)
        
        return cell
    }
    
}

extension OrderListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        segueOrder = ordersList[indexPath.row]
        performSegue(withIdentifier: K.segueIdentifierToViewOrder, sender: self)
    }
}

//MARK: Swipe Cell Kit Functionality

extension OrderListViewController: SwipeTableViewCellDelegate {
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            K.ordersContext.delete(self.ordersList[indexPath.row])
            self.ordersList.remove(at: indexPath.row)
            self.saveOrders()
            self.loadOrders()
            self.updateData()
        }
        
        let editAction = SwipeAction(style: .default, title: "Edit\nIngredient") { action, indexPath in
//            self.segueCollectedWisdom = [self.collectedWisdom[indexPath.row]]
//            self.performSegue(withIdentifier: "editWisdomSegue", sender: self)
        }
        
        // customize the action appearance
        deleteAction.image = UIImage(named: "delete-icon")
//        editAction.backgroundColor = K.fontColor.withAlphaComponent(1.0)
//        editAction.textColor = K.fontColorWhite
//        editAction.font = UIFont(name: "Times New Roman", size: 20.0)
        
        return [deleteAction, editAction]
    }
}
