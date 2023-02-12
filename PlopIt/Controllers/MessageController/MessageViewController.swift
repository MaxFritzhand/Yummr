//
//  MessageViewController.swift
//  PlopIt
//
//  Created by e on 3/22/22.
//

import UIKit

let data1 = [
    [
        "TOP": "Gordon Ramsey",
        "BUTTOM" : "system."
    ],
    [
        "TOP" : "Test1234@aol.com",
        "BUTTOM" : "system."
    ],
    [
        "TOP" : "123-456-789",
        "BUTTOM" : "system."
    ]
]


class MessageViewController: PIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    
    var foodMenuItems: [MenuItem] = []
    
    var approvalArray: [[MenuItem]] = [[],[],[]]   // denied first, pending second, and approved third
    
    let sections: [String] = ["Denied Models", "Pending Models", "Approved Models"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        API.shared.userManager.addConsumer(consumer: self)
        setupTableView()
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "MessageTableViewCell", bundle: nil), forCellReuseIdentifier: "MessageTableViewCellID")
        tableView.layer.cornerRadius = 25
        tableView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        //TODO MAKE RESTAURANT ID NONSTATIC
        API.shared.restaurantManager.getMenuItems(restaurantID: "ksdABXAhwGIwfDzrEQzi") { foodMenuItems in
            self.foodMenuItems = foodMenuItems
            //print(foodMenuItems)
            let modelTuple = self.populateApprovalArray(foodMenuItems: foodMenuItems)
            print(modelTuple)
            self.approvalArray[0] = modelTuple.0
            self.approvalArray[1] = modelTuple.1
            self.approvalArray[2] = modelTuple.2
            //print(foodMenuItems)
            //print("--------------------------")
            print(self.approvalArray)
            self.tableView.reloadData()
        } withFailure: { error in
            API.shared.bannerManager.showErrorNotification(withMessage: error)
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageTableViewCellID", for: indexPath) as! MessageTableViewCell
        cell.menuItem.text = approvalArray[indexPath.section][indexPath.row].menuItem
        
        return cell
    }
    
    func populateApprovalArray(foodMenuItems: [MenuItem] ) -> ([MenuItem],[MenuItem],[MenuItem]) {
        for fooditem in foodMenuItems {
            //print(fooditem.modelApproval)
            if fooditem.modelApproval == true {
                approvalArray[2].append(fooditem) // approved models
            } else if fooditem.modelApproval == false {
                approvalArray[0].append(fooditem) // denied models
            } else {
                approvalArray[1].append(fooditem) // pending models
            }
        }
        //print(approvalArray)
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
