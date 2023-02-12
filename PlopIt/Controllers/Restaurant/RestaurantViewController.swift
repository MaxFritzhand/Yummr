//
//  RestaurantViewController.swift
//  PlopIt
//
//  Created by Raivis Olehno on 11/01/2022.
//

import UIKit
import Kingfisher
import FirebaseStorage
import FirebaseFirestore
import FirebaseFirestoreSwift

class RestaurantViewController: PIViewController {
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var backView: UIView!
    @IBOutlet private weak var backButton: UIButton!
    @IBOutlet weak var arView: UIView!
    @IBOutlet weak var arButton: UIButton!
    @IBOutlet private weak var restaurantImageView: UIImageView!
    @IBOutlet private weak var restaurantName: UILabel!
    @IBOutlet private weak var restaurantDescription: UILabel!
    @IBOutlet private weak var firstGenre: UILabel!
    @IBOutlet private weak var secondGenre: UILabel!
    @IBOutlet private weak var secondDot: UIView!
    @IBOutlet private weak var priceLabel: UILabel!
    @IBOutlet private weak var additionalDetails: UIButton!
    
    
    
    var selectedCategory = 0
    var restaurant: Restaurant
    var menuItem: [MenuItem] = []
//    var owner : Owner
   // var user: User
    var ID: String
    var foodMenuItems: [MenuItem] = []
    var publishedArray: [MenuItem] = []
    var menuHeaderArray: [String] = []
    var sortedFoodArray: [[MenuItem]] = [[]]
    var sectionNumber:Int = 0  //number of sections for table view


    init(withRestaurantData restaurantData:  Restaurant) {
        self.restaurant = restaurantData
//        self.owner = owner
        //self.user = user
        self.menuHeaderArray = restaurantData.menuHeaderArray ?? [""]
        self.ID = restaurantData.restaurantID!
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        API.shared.userManager.addConsumer(consumer: self)
        setupView()
        backView.addCornerRadius(value: backView.frame.width/2)
        backButton.setTitle("", for: .normal)
        arView.addCornerRadius(value: arView.frame.width/2)
        arButton.setTitle("", for: .normal)
        
        
        
        
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerNibArray(withNames: ["ImageTextTableViewCell", "MiddleTextTableViewCell", "MenuItemCollectionViewTableViewCell", "FoodMenuTableViewCell"])
        
        API.shared.restaurantManager.getPublishedMenuItems(restaurantID: self.ID) { foodMenuItems in
            self.foodMenuItems = foodMenuItems
            self.sortedFoodArray = self.sortFood(foodMenuItems: foodMenuItems)
            self.tableView.reloadData()
        } withFailure: { error in
            API.shared.bannerManager.showErrorNotification(withMessage: "Failed to fetch restaurant items")
        }

    }
    
    func setupView() {
        API.shared.firebaseStorageManager.pullImageFromDatabase(fromURL: restaurant.restaurantHeaderImageURL ?? "https://firebasestorage.googleapis.com/v0/b/plopit-aceb3.appspot.com/o/defaultBackgroundHeader.png?alt=media&token=5e5b463a-6feb-420") { imageTest in
            self.restaurantImageView.image = imageTest
        }
        restaurantName.text = restaurant.restaurantName
        restaurantDescription.text = restaurant.restaurantDescription
        priceLabel.text = restaurant.priceRange
        
        firstGenre.text = ""
        secondGenre.text = ""
        secondDot.isHidden = true
        
        var firstSwitch = false
        
        for (genre, check) in restaurant.restaurantGenre ?? [:] {
                if check == true {
                    if firstSwitch == false {
                        firstGenre.text = genre
                        firstSwitch = true
                    } else if firstSwitch == true {
                        secondGenre.text = genre
                        secondDot.isHidden = false
                    }
                }
        }
        
        setupTableView()
    }
//    var db = Firestore.firestore()
//    private func fetchHours(documentId: String){
//let docRef = db.collection("Restaurant").document(documentId)
//
//        docRef.getDocument(as: Restaurant.self) { result in
//            switch result{
//            case .success(let hours):
//                self.hours = hours
//                self.errorMessage = nil
//            case .failure(let error):
//                self.errorMessage = "Error decoding document: \(error.localizedDescription)"
//            }
//        }
//    }
    
    
    //fix withMenuItem variable
    @IBAction func goToARView(_ sender: Any) {
        let vc = ARFullScreenViewController(withMenuItem: menuItem[3], withRestaurant: restaurant, withMenuItems: self.foodMenuItems)
        
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    @IBAction func goToDetailView(_ sender: Any) {
        let vc = InformationDetailsViewController(withRestaurant: restaurant)
        self.present(vc, animated: true, completion: nil)
    
    
    }
    
    
    
    
    func sortFood(foodMenuItems: [MenuItem]) ->  [[MenuItem]] {
        for fooditem in foodMenuItems {
            if fooditem.isPublished == true {
                self.publishedArray.append(fooditem) // published
            }
        }
        if self.menuHeaderArray.count == 0 {
            for foodItem in publishedArray {
                sortedFoodArray[0].append(foodItem)
            }
        } else {
            for _ in (1...self.menuHeaderArray.endIndex) {
                sortedFoodArray.append([])
            }
            
            for foodItem in publishedArray {
                sortedFoodArray[foodItem.menuHeaderID!].append(foodItem)
            }
        }
        return sortedFoodArray
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}

extension RestaurantViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return menuHeaderArray.count + 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return ""
        } else {
            return self.menuHeaderArray[section-1]
        }
    
    }
    /*func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(
            style: .normal,
            title: "Publish",
            handler: { (action, view, completion) in
                //do what you want here
                print("Deleted Row")
                completion(true)
        })

        action.backgroundColor = Colours.publishButton
        let configuration = UISwipeActionsConfiguration(actions: [action])
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }  this is the code that is the swipe to unpublish but we dont need */
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            if self.publishedArray.count != 0 {
            return sortedFoodArray[section-1].count
            } else {return 0}
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let categoryItemsCell = tableView.dequeueReusableCell(withIdentifier: "MenuItemCollectionViewTableViewCell") as? MenuItemCollectionViewTableViewCell else {
                fatalError()
            }
            categoryItemsCell.setupCollectionView(withMenuCategoryItems: menuHeaderArray, selectedCategory: self.selectedCategory) { (index) in
                self.selectedCategory = index
                //Need to figure out refresh logic
                print("Test ID: \(self.selectedCategory)")
                self.tableView.reloadData()
            }
            return categoryItemsCell
        } else {
            guard let foodItemCell = tableView.dequeueReusableCell(withIdentifier: "FoodMenuTableViewCell") as? FoodMenuTableViewCell else {
                fatalError()
            }
            foodItemCell.editButton.isHidden = true
            foodItemCell.viewController = self
            foodItemCell.update(with3DHandler: {
                let modelVC = FoodMenuItemViewController(withMenuItem: self.sortedFoodArray[indexPath.section - 1][indexPath.row], withRestaurant: self.restaurant, withMenuItems: self.publishedArray)
                self.navigationController?.pushViewController(modelVC, animated: true)
            }, withItemHandler: {
                //do nothing
                
            }, withFoodItems: self.sortedFoodArray[indexPath.section - 1][indexPath.row])
            return foodItemCell
        }
    }
}
