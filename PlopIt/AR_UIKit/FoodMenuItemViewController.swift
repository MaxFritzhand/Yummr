//
//  FoodMenuItemViewController.swift
//  PlopIt
//
//  Created by Raivis Olehno on 12/02/2022.
//

import UIKit
import SceneKit.ModelIO
import ARKit
import BetterSegmentedControl
import Lottie

class FoodMenuItemViewController: PIViewController, URLSessionDownloadDelegate {
    
    @IBOutlet weak var ARSceneView: SCNView!
    @IBOutlet weak var viewInARButton: UIButton!
    @IBOutlet weak var homeButtonView: UIView!
    @IBOutlet weak var restaurantTitle: UILabel!
    @IBOutlet weak var foodTitle: UILabel!
    @IBOutlet weak var foodDescription: UILabel!
    //@IBOutlet weak var foodIngredients: UILabel!
    @IBOutlet weak var foodView: BetterSegmentedControl!
    @IBOutlet weak var foodCollectionView: UICollectionView!
    @IBOutlet weak var loadingView: AnimationView!
    
    
    var menuItems: MenuItem
    var foodMenuItems: [MenuItem] = []
    var restaurant: Restaurant
    
    init(withMenuItem menuItem:  MenuItem, withRestaurant restaurant: Restaurant) {
        self.menuItems = menuItem
        self.restaurant = restaurant
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView() {
        setupAnimation()
        setupCollectionView()
        downloadSceneTask()
        viewInARButton.addCornerRadius(value: 10)
        foodView.addCornerRadius(value: 10)
        homeButtonView.addCornerRadius(value: homeButtonView.frame.width/2)
        foodTitle.text = menuItems.menuItem
        foodDescription.text = menuItems.itemDescription
        restaurantTitle.text = restaurant.restaurantName ?? "RESTAURANT NAME"
        //foodIngredients.text = menuItems.ingredients ?? "No Ingredients"
        foodView.segments = LabelSegment.segments(withTitles: ["Food", "Beverages", "Desserts", "Promotions"], normalBackgroundColor: .clear, normalFont: UIFont(name: "Poppins-SemiBold", size: 13) ,normalTextColor: .black, selectedBackgroundColor: .white,selectedFont: UIFont(name: "Poppins-SemiBold", size: 13) ,selectedTextColor: .black)
    }
    

    
    
    
    func setupAnimation(){
        self.loadingView.isHidden = false
        let animationArray = ["coffee", "donut", "brocolli", "fries", "mushroom", "orange", "taco",
                              "avocado", "bacon", "hamburger", "lemonade", "muffin", "pizza" ]
        let n = Int.random(in:0...((animationArray.count)-1))
        loadingView.animation = Animation.named(animationArray[n])
        loadingView.backgroundColor = .clear
        loadingView.contentMode = .scaleToFill
        loadingView.animationSpeed = 1.2
        loadingView.loopMode = .loop
        loadingView.play()
    }

    func setupCollectionView() {
        foodCollectionView.delegate = self
        foodCollectionView.dataSource = self
        foodCollectionView.registerNibArray(withNames: ["MenuItemCollectionViewCell"])
        API.shared.restaurantManager.getMenuItems(restaurantID: restaurant.restaurantID!) { menuItems in
            self.foodMenuItems = menuItems
            self.foodCollectionView.reloadData()
        } withFailure: { error in
            API.shared.bannerManager.showErrorNotification(withMessage: "Failed to fetch restaurant items")
        }
    }
    func updateFoodView(titleLabelText: String, descriptionLabelText: String) {
        foodTitle.text = titleLabelText
        foodDescription.text = descriptionLabelText
    }
    
    func downloadSceneTask(){
        let delegateQueue = OperationQueue()
        delegateQueue.qualityOfService = .utility
        
        guard let url = URL(string: menuItems.modelURL!) else { return }
        let downloadSession = URLSession(configuration: URLSession.shared.configuration, delegate: self, delegateQueue: delegateQueue)
        let downloadTask = downloadSession.downloadTask(with: url)
            
        downloadTask.resume()
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        let fileURL = API.shared.arManager.getDocumentsDirectory().appendingPathComponent("\(menuItems.menuItem!).usdz")
        do {
            try FileManager.default.copyItem(at: location, to: fileURL)
            print("Successfuly Saved File \(fileURL)")
            DispatchQueue.main.async {
                self.loadingView.isHidden = true
            }
            API.shared.arManager.load(ARView: ARSceneView, directory: menuItems.menuItem!)
            
        } catch {
            print("Error Saving: \(error)")
            DispatchQueue.main.async {
                self.loadingView.isHidden = true
                API.shared.arManager.load(ARView: self.ARSceneView, directory: self.menuItems.menuItem!)
            }
        }
    }
    
    @IBAction func foodTypeValueChanged(_ sender: BetterSegmentedControl) {
        //TODO: Create a switch for senders
        print("The selected index is \(sender.index)")
    }
    
    @IBAction func homeButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func viewInARButtonTapped(_ sender: Any) {
        let vc = ARFullScreenViewController(withMenuItem: menuItems, withRestaurant: restaurant)
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension FoodMenuItemViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ foodCollectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        API.shared.arManager.downloadSceneTask(newModel: foodMenuItems[indexPath.item].modelURL!)
        print(foodMenuItems[indexPath.item].menuItem!)
        updateFoodView(titleLabelText: foodMenuItems[indexPath.item].menuItem!, descriptionLabelText: foodMenuItems[indexPath.item].itemDescription!)
        
        let cell = foodCollectionView.cellForItem(at: indexPath)
            cell?.layer.borderColor = UIColor.orange.cgColor
            cell?.layer.borderWidth = 2
            cell?.isSelected = true
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = foodCollectionView.cellForItem(at: indexPath)
        cell?.layer.borderColor = UIColor.clear.cgColor
        cell?.layer.borderWidth = 2
        cell?.isSelected = false
    }

    
    
//    func collectionView(_ foodCollectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
//        if let cell = foodCollectionView.cellForItem(at: indexPath) {
//            cell.contentView.backgroundColor = nil
//        }
//    }
//
//    func collectionView(_ foodCollectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
//        if let cell = foodCollectionView.cellForItem(at: indexPath) {
//            cell.contentView.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
//        }
//    }
    func collectionView(_ foodCollectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return foodMenuItems.count
    }
    
    func collectionView(_ foodCollectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = foodCollectionView.dequeueReusableCell(withReuseIdentifier: "MenuItemCollectionViewCell", for: indexPath) as? MenuItemCollectionViewCell
        else {
            fatalError()
        }
        
//        if cell.isSelected{
//
//        }
        
        cell.update(menuItem: foodMenuItems[indexPath.item])
        return cell
    }
}
