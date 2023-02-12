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

class FoodMenuItemViewController: PIViewController {

    
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
    @IBOutlet weak var noARImage: UIImageView!
    
    var menuItem: MenuItem
    var foodMenuItems: [MenuItem] = []
    var restaurant: Restaurant
    var selectedDish: String?
    
    init(withMenuItem menuItem:  MenuItem, withRestaurant restaurant: Restaurant, withMenuItems foodMenuItems:  [MenuItem]) {
        self.menuItem = menuItem
        self.restaurant = restaurant
        self.foodMenuItems = foodMenuItems
        self.selectedDish = menuItem.menuItem
        //self.selectedDish = menuItem.documentID
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
        self.navigationController?.isNavigationBarHidden = true
        if menuItem.modelURL != "" && menuItem.modelApproval == true {
            downloadSceneTask(urlString: menuItem.modelURL!)
        } else{
            thumbnailDefault()
        }
        viewInARButton.addCornerRadius(value: 10)
        foodView.addCornerRadius(value: 10)
        homeButtonView.addCornerRadius(value: homeButtonView.frame.width/2)
        foodTitle.text = menuItem.menuItem
        foodDescription.text = menuItem.itemDescription
        restaurantTitle.text = restaurant.restaurantName ?? "RESTAURANT NAME"
        //foodIngredients.text = menuItems.ingredients ?? "No Ingredients"
        foodView.segments = LabelSegment.segments(withTitles: ["Food", "Beverages", "Desserts", "Promotions"], normalBackgroundColor: .clear, normalFont: UIFont(name: "Poppins-SemiBold", size: 13) ,normalTextColor: .black, selectedBackgroundColor: .white,selectedFont: UIFont(name: "Poppins-SemiBold", size: 13) ,selectedTextColor: .black)
    }
    
    func setupAnimation(){
        let animationArray = ["coffee", "donut", "brocolli", "fries", "mushroom", "orange", "taco", "avocado", "bacon", "hamburger", "lemonade", "muffin", "pizza", "apple", "cookie", "cake", "sushi", "milkshake"]
        let n = Int.random(in:0...((animationArray.count)-1))
        loadingView.animation = Animation.named(animationArray[n])
        loadingView.backgroundColor = .clear
        loadingView.contentMode = .scaleToFill
        loadingView.animationSpeed = 1.2
        loadingView.loopMode = .loop
        loadingView.play()
    }
    
    func resetAnimation(){
        let animationArray = ["coffee", "donut", "brocolli", "fries", "mushroom", "orange", "taco", "avocado", "bacon", "hamburger", "lemonade", "muffin", "pizza", "apple", "cookie", "cake", "sushi", "milkshake"]
        let n = Int.random(in:0...((animationArray.count)-1))
        loadingView.animation = Animation.named(animationArray[n])
    }

    
    
    //if user does not have AR, use thumbnail
    func thumbnailDefault(){
      noARImage.isHidden = false

        API.shared.firebaseStorageManager.pullImageFromDatabase(fromURL: menuItem.thumbnailImage!) { image in
            self.noARImage.image = image
        }
    }
    

    func setupCollectionView() {
        foodCollectionView.delegate = self
        foodCollectionView.dataSource = self
        foodCollectionView.registerNibArray(withNames: ["MenuItemCollectionViewCell"])
        self.foodCollectionView.reloadData()
        
        /*API.shared.restaurantManager.getPublishedMenuItems(restaurantID: restaurant.restaurantID!) { menuItems in
            self.foodMenuItems = menuItems
            self.foodCollectionView.reloadData()
        } withFailure: { error in
            API.shared.bannerManager.showErrorNotification(withMessage: "Failed to fetch restaurant items")
        }*/
    }
    
    func updateFoodView(titleLabelText: String, descriptionLabelText: String) {
        foodTitle.text = titleLabelText
        foodDescription.text = descriptionLabelText
        
        
    }
    
    func downloadSceneTask(urlString: String){
        let delegateQueue = OperationQueue()
        delegateQueue.qualityOfService = .utility
        
        guard let url = URL(string: urlString) else { return }
        let downloadSession = URLSession(configuration: URLSession.shared.configuration, delegate: self, delegateQueue: delegateQueue)
        let downloadTask = downloadSession.downloadTask(with: url)
            
        downloadTask.resume()
    }
    
    @IBAction func foodTypeValueChanged(_ sender: BetterSegmentedControl) {
        //TODO: Create a switch for senders
        print("The selected index is \(sender.index)")
    }
    
    @IBAction func homeButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func viewInARButtonTapped(_ sender: Any) {
        let vc = ARFullScreenViewController(withMenuItem: menuItem, withRestaurant: restaurant, withMenuItems: self.foodMenuItems)
        navigationController?.pushViewController(vc, animated: true)
    }
}


extension FoodMenuItemViewController: UICollectionViewDelegate, UICollectionViewDataSource, URLSessionDownloadDelegate {
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        let fileURL = API.shared.arManager.getDocumentsDirectory().appendingPathComponent("\(selectedDish!).usdz")
        
                       do{
                          try FileManager.default.removeItem(at: fileURL)
                          print("Successfuly Removed File \(fileURL)")
                       }
                       catch {
                           print("Error Removing: \(error)")
                       }
        
                       do {
                           try FileManager.default.copyItem(at: location, to: fileURL)
                           print("Successfuly Saved File \(fileURL)")
                           DispatchQueue.main.async {
                               self.loadingView.isHidden = true
                               
                               //plays new animation
                              self.setupAnimation()
                              
                           }
                          
                           API.shared.arManager.load(ARView: ARSceneView, directory: selectedDish!)
                       } catch {
                           print("Error Saving: \(error)")
                           DispatchQueue.main.async {
                               self.loadingView.isHidden = true
                               API.shared.arManager.load(ARView: self.ARSceneView, directory: self.selectedDish!)
                           }
                       }
                   }
    
    func collectionView(_ foodCollectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
 
        
        API.shared.arManager.removeARObject(ARView: ARSceneView)
        self.loadingView.isHidden = false
        downloadSceneTask(urlString: foodMenuItems[indexPath.item].modelURL!)
        
        print("Menu item: " + foodMenuItems[indexPath.item].menuItem!)
        print("Encoded URL string: " + foodMenuItems[indexPath.item].modelURL!)
        print("Decoded URL string: " + foodMenuItems[indexPath.item].modelURL!.removingPercentEncoding!)
        
        let decodedString = foodMenuItems[indexPath.item].modelURL!.removingPercentEncoding!
        if let index = decodedString.range(of: ".usdz")?.lowerBound {
            let substring = decodedString.prefix(upTo: index)
            print("Substring: " + String(substring).subStringAfterLastForwardSlash)
            selectedDish = String(substring).subStringAfterLastForwardSlash
        }

        updateFoodView(titleLabelText: foodMenuItems[indexPath.item].menuItem!, descriptionLabelText: foodMenuItems[indexPath.item].itemDescription!)
        
        let cell = foodCollectionView.cellForItem(at: indexPath)
            cell?.layer.borderColor = UIColor.orange.cgColor
            cell?.layer.borderWidth = 2
        cell!.isSelected = true
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = foodCollectionView.cellForItem(at: indexPath)
        cell?.layer.borderColor = UIColor.clear.cgColor
        cell?.layer.borderWidth = 2
        cell!.isSelected = false
    }

    func collectionView(_ foodCollectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return foodMenuItems.count
    }
    
    func collectionView(_ foodCollectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = foodCollectionView.dequeueReusableCell(withReuseIdentifier: "MenuItemCollectionViewCell", for: indexPath) as? MenuItemCollectionViewCell else {
            fatalError()
        }
        
//                if cell.isSelected{
//
//                }
        
        cell.update(menuItem: foodMenuItems[indexPath.item])
        return cell
    }
}

extension String {
    var subStringAfterLastForwardSlash : String {
        guard let subrange = self.range(of: "/", options: [.backwards])?.upperBound else { return self }
        return String(self.suffix(from: subrange))
    }
}

