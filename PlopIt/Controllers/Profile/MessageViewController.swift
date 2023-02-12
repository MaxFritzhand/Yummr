//
//  MessageViewController.swift
//  PlopIt
//
//  Created by e on 3/22/22.
//

import UIKit
import SwiftUI

class MessageViewController: PIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    //@IBOutlet weak var backButtonView: UIView!
    
    var restaurant: Restaurant
    var foodMenuItems: [MenuItem] = []
    var approvalArray: [[MenuItem]] = [[],[],[]]   // denied first, pending second, and approved third
    let sections: [String] = ["Denied Models", "Pending Models", "Approved Models waiting to be published"]
    weak var viewController: UIViewController?
    
    init(withRestaurantData restaurantData:  Restaurant) {
        self.restaurant = restaurantData
        //self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBarFunction()
        API.shared.userManager.addConsumer(consumer: self)
        setupTableView()
        viewController = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "MessageTableViewCell", bundle: nil), forCellReuseIdentifier: "MessageTableViewCellID")
        tableView.layer.cornerRadius = 25
        tableView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    
        API.shared.restaurantManager.getMenuItems(restaurantID: restaurant.restaurantID!) { foodMenuItems in
            self.foodMenuItems = foodMenuItems
            
            let modelTuple = self.populateApprovalArray(foodMenuItems: foodMenuItems)
            print(modelTuple)
            self.approvalArray[0] = modelTuple.0
            self.approvalArray[1] = modelTuple.1
            self.approvalArray[2] = modelTuple.2
    
            print(self.approvalArray)
            self.tableView.reloadData()
        } withFailure: { error in
            API.shared.bannerManager.showErrorNotification(withMessage: error)
        }
        
        //backButtonView.addCornerRadius(value: backButtonView.frame.width/2)
        
    }
    
    func setupNavBarFunction() {
        self.title = "Messages"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController!.navigationBar.barStyle = .black
        
        let appearance = UINavigationBarAppearance()
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.backgroundColor = UIColor(hex: "#FE7700")
        appearance.shadowColor = .clear
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        
    }
    
 
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageTableViewCellID", for: indexPath) as! MessageTableViewCell
        cell.menuItemLabel.text = approvalArray[indexPath.section][indexPath.row].menuItem
        cell.viewController = self
        
        cell.update(with3DHandler: { [self] in
            let modelVC = FoodMenuItemViewController(withMenuItem: self.approvalArray[indexPath.section][indexPath.row], withRestaurant: self.restaurant, withMenuItems: self.foodMenuItems)
                //modelVC.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(modelVC, animated: true)
        }, withItemHandler: {
            let itemVC = AddFoodItemViewController(categoryInitialized: .existingItem, withRestaurantData: self.restaurant, withMenuItem: self.approvalArray[indexPath.section][indexPath.row])
            //itemVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(itemVC, animated: true)
        }, withFoodItem: approvalArray[indexPath.section][indexPath.row], sectionNumber: indexPath.section)
        
        return cell
    }
    
    func populateApprovalArray(foodMenuItems: [MenuItem] ) -> ([MenuItem],[MenuItem],[MenuItem]) {
        for fooditem in foodMenuItems {
            if fooditem.modelApproval == true {
                if fooditem.isPublished == false {
                approvalArray[2].append(fooditem)  // approved models but only append if unpublished too
                }
            } else if fooditem.modelApproval == false {
                approvalArray[0].append(fooditem) // denied models
            } else {
                approvalArray[1].append(fooditem) // pending models
            }
        }
        return (approvalArray[0],approvalArray[1],approvalArray[2])
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let section = self.sections[section]
        return section
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return approvalArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return approvalArray[section].count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(90)
    }
    
}
