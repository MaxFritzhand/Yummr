//
//  ARFullScreenViewController.swift
//  PlopIt
//
//  Created by Raivis Olehno on 13/02/2022.
//

import UIKit
import ARKit
import RealityKit
import SceneKit.ModelIO


class ARFullScreenViewController: PIViewController {
    
    @IBOutlet weak var ARView: ARSCNView!
    @IBOutlet weak var descriptionView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var foodButton: UIButton!
    @IBOutlet weak var beveragesButton: UIButton!
    @IBOutlet weak var dessertsButton: UIButton!
    @IBOutlet weak var promotionsButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet var foodTypeButtons: [UIButton]!
    @IBOutlet var contentView: UIView!
    

    var hasSelectedButton = false
    var isSelected = false
    var menuItems: MenuItem
    var foodMenuItems: [MenuItem] = []
    var restaurant: Restaurant
    var itemArray = [SCNNode]()
    
    init(withMenuItem menuItem:  MenuItem, withRestaurant restaurant: Restaurant) {
        self.menuItems = menuItem
        self.restaurant = restaurant
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
       API.shared.arManager.configureARView(view: ARView)
       addTapGestureToAlertView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        ARView.session.pause()
    }
    
    func setupView() {
        descriptionView.addCornerRadius(value: 14)
        titleLabel.text = menuItems.menuItem
        descriptionLabel.text = menuItems.itemDescription
        backButton.setTitle(self.restaurant.restaurantName ?? "NO RESTAURANT NAME", for: .normal)
        foodTypeButtons.forEach({$0.addCornerRadius(value: 6)})
        setupCollectionView()
        setupButtons()
    }
    
    func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.registerNibArray(withNames: ["MenuItemCollectionViewCell"])
        API.shared.restaurantManager.getMenuItems(restaurantID: restaurant.restaurantID!) { menuItems in
            self.foodMenuItems = menuItems
            self.collectionView.reloadData()
        } withFailure: { error in
            API.shared.bannerManager.showErrorNotification(withMessage: "Failed to fetch restaurant items")
        }
    }
    
    func setupButtons() {
        foodButton.addCornerRadius(value: 6)
        foodButton.backgroundColor = Style.buttonBackgroundColour
        foodButton.setTitleColor(UIColor.white, for: .normal)
        
        beveragesButton.addCornerRadius(value: 6)
        beveragesButton.backgroundColor = Style.buttonBackgroundColour
        beveragesButton.setTitleColor(UIColor.white, for: .normal)
        
        dessertsButton.addCornerRadius(value: 6)
        dessertsButton.backgroundColor = Style.buttonBackgroundColour
        dessertsButton.setTitleColor(UIColor.white, for: .normal)
        
        promotionsButton.addCornerRadius(value: 6)
        promotionsButton.backgroundColor = Style.buttonBackgroundColour
        promotionsButton.setTitleColor(UIColor.white, for: .normal)
    }
    
    func getDocumentsPath() -> MDLAsset {
        let downloadedScenePath = API.shared.arManager.getDocumentsDirectory().appendingPathComponent("\(menuItems.menuItem!).usdz")
        let asset = MDLAsset(url: downloadedScenePath)
        asset.loadTextures()
        return MDLAsset(url: downloadedScenePath)
    }

    @objc func addShipToSceneView() {
        let mdlAsset = getDocumentsPath()
        mdlAsset.loadTextures()
        let modelRootNode = SCNScene(mdlAsset: mdlAsset).rootNode
        modelRootNode.position = API.shared.arManager.getFocusNodePosition()
        itemArray.append(modelRootNode)
        ARView.scene.rootNode.addChildNode(modelRootNode)
    }
    
    func removeOldItem() {
        if !itemArray.isEmpty {
            for item in itemArray {
                item.geometry?.firstMaterial?.normal.contents = nil
                item.geometry?.firstMaterial?.diffuse.contents = nil
                item.geometry?.firstMaterial?.metalness.contents = nil
                item.geometry?.firstMaterial?.roughness.contents = nil
                item.geometry = nil
                item.removeFromParentNode()
                self.addShipToSceneView()
            }
        }
        itemArray.remove(at: 0)
    }
    
    func addTapGestureToAlertView() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.showSimpleAlert(_:)))
        ARView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func showSimpleAlert(_ sender: Any) {
        let alert = UIAlertController(title: "Place here?", message: "Place your item here.", preferredStyle: UIAlertController.Style.alert)
        
       alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: { _ in
           //Cancel Action
           
       }))
       
       alert.addAction(UIAlertAction(title: "Confirm", style: UIAlertAction.Style.default) {UIAlertAction in
            print("Confirm Pressed")
           if !self.itemArray.isEmpty {
               self.removeOldItem()
           } else {
               self.addShipToSceneView()
           }
       })
        
       self.present(alert, animated: true, completion: nil)
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        let fileURL  = API.shared.arManager.getDocumentsDirectory().appendingPathComponent("\(menuItems.menuItem!).usdz")
        do {
            try FileManager.default.copyItem(at: location, to: fileURL)

            print("Successfuly Saved File \(fileURL)")
        } catch {
            print("Error Saving: \(error)")
        }
    }
    
    func updateFoodView(titleLabelText: String, descriptionLabelText: String) {
        titleLabel.text = titleLabelText
        descriptionLabel.text = descriptionLabelText
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func categoryButtonTapped(_ sender: Any) {
        print("Category Button Tapped")
    }
    
    @IBAction func shareButtonTapped(_ sender: Any) {
        print("Share Button Tapped")
    }
    
    @IBAction func foodTypeTapped(_ sender: UIButton) {
        setupButtons()
        hasSelectedButton = true
        sender.backgroundColor = Style.selectedButtonBackgroundColour
        sender.setTitleColor(.white, for: .normal)
        
        switch sender.tag {
        case 0:
            print("0")
        case 1:
            print("1")
        case 2:
            print("2")
        default:
            print("3")
        }
    }
}

extension ARFullScreenViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        API.shared.arManager.downloadSceneTask(newModel: foodMenuItems[indexPath.item].modelURL!)
        print(foodMenuItems[indexPath.item].menuItem!)
        updateFoodView(titleLabelText: foodMenuItems[indexPath.item].menuItem!, descriptionLabelText: foodMenuItems[indexPath.item].itemDescription!)
        
        let cell = collectionView.cellForItem(at: indexPath)
            cell?.layer.borderColor = UIColor.orange.cgColor
            cell?.layer.borderWidth = 2
            cell?.isSelected = true

        }

        func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.layer.borderColor = UIColor.clear.cgColor
        cell?.layer.borderWidth = 2
        cell?.isSelected = false
        }


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return foodMenuItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MenuItemCollectionViewCell", for: indexPath) as? MenuItemCollectionViewCell else {
            fatalError()
        }
        cell.update(menuItem: foodMenuItems[indexPath.item])
        return cell
    }
}



