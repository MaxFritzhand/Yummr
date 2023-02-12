//
//  MenuViewController.swift
//  PlopIt
//
//  Created by Raivis Olehno on 08/01/2022.
//

import UIKit
import Lottie

class MenuViewController: PIViewController {
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var restaurantTitle: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var editMenu: UIButton!
    @IBOutlet weak var animationView: AnimationView!
    @IBOutlet weak var addItemFirstTime: UIButton!
    @IBOutlet weak var labelFirstTime: UILabel!
    
    @IBOutlet weak var animationViewer: UIView!
    
    @IBOutlet weak var animationstackView: UIStackView!
    
    var foodMenuItems: [MenuItem] = []
    var restaurant: Restaurant
    var selectedCategory = 0
    var menuHeaderArray: [String] = []
    var draftArray: [MenuItem] = []
    var publishedArray: [MenuItem] = []
    var publishedMenuHeaderArray: [[MenuItem]] = [[]]
    var sectionNumber:Int = 0  //number of sections for table view
    var itemCounter: Int = 0

    
    init(withRestaurantData restaurantData:  Restaurant) {
        self.restaurant = restaurantData
        //self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView() {
        API.shared.userManager.addConsumer(consumer: self)
        setupTableView()
    }
    
    
    func setupAnimation(){
        animationView.backgroundColor = .white
        animationView.contentMode = .scaleToFill
        animationView.animationSpeed = 0.75
        animationView.loopMode = .loop
        animationView.play()
    }
    
    func HideAnimation(){
        animationView.isHidden = true
        addItemFirstTime.isHidden = true
        labelFirstTime.isHidden = true
        animationstackView.isHidden = true
        animationViewer.isHidden = true
        
    }
    
    func setupTableView() {
        self.tableView.dataSource = self
        self.tableView.registerNibArray(withNames: ["MenuItemCollectionViewTableViewCell", "FoodMenuTableViewCell"])
        self.tableView.sectionHeaderTopPadding = 0.0
        tableView.contentInset = UIEdgeInsets(top: -1, left: 0, bottom: 0, right: 0)
    
        self.restaurantTitle.text = self.restaurant.restaurantName
        self.menuHeaderArray = self.restaurant.menuHeaderArray!
        if self.restaurant.restaurantThumbnailImageURL != nil {
            API.shared.firebaseStorageManager.pullImageFromDatabase(fromURL: restaurant.restaurantThumbnailImageURL!) { image in
                self.mainImageView.image = image
            }
        } else {
            self.mainImageView.image = UIImage(named: "restaurantDefault")
        }
            
        API.shared.restaurantManager.getMenuItems(restaurantID: self.restaurant.restaurantID!) { foodMenuItems in
            self.foodMenuItems = foodMenuItems
            print(foodMenuItems)
            let foodTuple = self.sortDraftAndPublished(foodMenuItems: foodMenuItems)
            self.sectionNumber = self.getNumberOfSections(foodTuple: foodTuple)
            self.draftArray = foodTuple.0
            self.publishedMenuHeaderArray = foodTuple.1
            for (_, item) in self.publishedMenuHeaderArray.enumerated() {
                for _ in item{
                    self.itemCounter = self.itemCounter + 1
                }
            }
            self.itemCounter = self.itemCounter + self.draftArray.count
            
            if self.itemCounter == 0 {
                self.setupAnimation()
            } else {
                self.HideAnimation()
            }
            self.tableView.reloadData()
        } withFailure: { error in
            API.shared.bannerManager.showErrorNotification(withMessage: error)
        }
    }
    
    func sortDraftAndPublished(foodMenuItems: [MenuItem]) -> ([MenuItem], [[MenuItem]]) {
        self.itemCounter = foodMenuItems.count
        
        for fooditem in foodMenuItems {
            //print(fooditem.modelApproval)
            if fooditem.isPublished == false {
                draftArray.append(fooditem) // drafts
            } else if fooditem.isPublished == true {
                self.publishedArray.append(fooditem) // published
            }
        }
        // logic needs fixed edge cases like, no headers but published item is not appearing
        if self.menuHeaderArray.count == 0 {
            for publishedItem in publishedArray {
                publishedMenuHeaderArray[0].append(publishedItem)
            }
        } else {
            for _ in (1...self.menuHeaderArray.endIndex) {
                publishedMenuHeaderArray.append([])
            }
        
            for publishedItem in publishedArray {
                publishedMenuHeaderArray[publishedItem.menuHeaderID!].append(publishedItem)
            }
        }
        return (draftArray,publishedMenuHeaderArray)
    }

    func getNumberOfSections(foodTuple: ([MenuItem], [[MenuItem]])) -> Int {
        // 1 for the category cell, and 1 for the draft sections
        var count = 1
        if draftArray.count != 0 {
            count += 1
        }
        count = count + foodTuple.1.count - 1 //get all published headers
        return count
    }
    
    var isEditDisplaying: Bool = false{
        didSet{
            tableView.reloadData()
        }
    }
    
    @IBAction func editMenu(_ sender: Any) {
         
        if isEditDisplaying{
            isEditDisplaying = false
            editMenu.setImage(UIImage(named: "editMenu.png"), for: .normal)
            //isEditDisplaying = !isEditDisplaying
        } else{
            isEditDisplaying = true
            editMenu.setImage(UIImage(named: "editMenu-fill.png"), for: .normal)
            //isEditDisplaying = !isEditDisplaying
        }
    }
    
    func scrollToSection(section: Int) {
        let indexPath = NSIndexPath(row: 0, section: section)
        self.tableView.scrollToRow(at: indexPath as IndexPath, at: .top, animated: true)
    }
    
    @IBAction func addMenuItem(_ sender: Any) {
        let vc = AddFoodItemViewController(categoryInitialized: .newItem, withRestaurantData: self.restaurant, withMenuItem: MenuItem())
        self.present(vc, animated: true, completion: nil)
    }
}

extension MenuViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.sectionNumber
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0  {
            return 1
        } else if section == 1  {
            return draftArray.count
        } else {
            return publishedMenuHeaderArray[section-2].count
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return ""
            
        }else if section == 1 {
            return "Draft Menu Items"
        } else {
            return self.menuHeaderArray[section-2]
        }
    }
    
    //hides first section header and determines height for others
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 1.0 : 32
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
        } else if indexPath.section == 1  {
            guard let foodItemCell = tableView.dequeueReusableCell(withIdentifier: "FoodMenuTableViewCell") as? FoodMenuTableViewCell else {
                fatalError()
            }
            foodItemCell.editButton.isHidden = !isEditDisplaying
            foodItemCell.viewController = self
            
            //swipe gesture to show publish and delete
            foodItemCell.update(with3DHandler: { [self] in
                let modelVC = FoodMenuItemViewController(withMenuItem: self.draftArray[indexPath.row], withRestaurant: self.restaurant, withMenuItems: foodMenuItems)
                self.navigationController?.pushViewController(modelVC, animated: true)
            }, withItemHandler: {
                let itemVC = AddFoodItemViewController(categoryInitialized: .existingItem, withRestaurantData: self.restaurant, withMenuItem: self.draftArray[indexPath.row])
                itemVC.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(itemVC, animated: true)
            }, withFoodItems: draftArray[indexPath.row])
            return foodItemCell
        } else {
            guard let foodItemCell = tableView.dequeueReusableCell(withIdentifier: "FoodMenuTableViewCell") as? FoodMenuTableViewCell else {
                fatalError()
        }
            foodItemCell.editButton.isHidden = !isEditDisplaying
            foodItemCell.viewController = self
            foodItemCell.tableView = self.tableView
            foodItemCell.cellRow = indexPath.row
            foodItemCell.menuItems = self.foodMenuItems
            
            foodItemCell.update(with3DHandler: {
                let modelVC = FoodMenuItemViewController(withMenuItem: self.publishedMenuHeaderArray[indexPath.section - 2][indexPath.row], withRestaurant: self.restaurant, withMenuItems: self.foodMenuItems)
                self.navigationController?.pushViewController(modelVC, animated: true)
            }, withItemHandler: {
                let itemVC = AddFoodItemViewController(categoryInitialized: .existingItem, withRestaurantData: self.restaurant, withMenuItem: self.publishedMenuHeaderArray[indexPath.section-2][indexPath.row])
                itemVC.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(itemVC, animated: true)
            },
            withFoodItems: self.publishedMenuHeaderArray[indexPath.section - 2][indexPath.row])
            return foodItemCell
        }
    }
}

extension MenuViewController: PIRestaurantConsumer {
    func didAddRestaurantItem() {
        print("Added New Item!")
    }
}
