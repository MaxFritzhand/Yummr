//
//  FoodMenuTableViewCell.swift
//  PlopIt
//
//  Created by Raivis Olehno on 13/01/2022.
//

import UIKit
import FirebaseStorage
import Kingfisher

class FoodMenuTableViewCell: UITableViewCell {

    @IBOutlet weak var view3DButton: UIButton!
    @IBOutlet weak var itemTitle: UILabel!
    @IBOutlet weak var itemDescription: UILabel!
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var itemPrice: UILabel!
    @IBOutlet weak var ImgButton: UIButton!
    
    var view3DHandler: (() -> ())?
    var viewItemDetail: (() -> ())?
    var documentID = ""
    var isPublished = false
    weak var viewController: UIViewController?
    weak var tableView: UITableView?
    var menuItems: [MenuItem]?
    var cellRow: Int?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        view3DButton.addCornerRadius(value: 10)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        selectionStyle = .none
    }
    
    func update(with3DHandler view3DHandler: (() -> ())?, withItemHandler viewItemDetail: (() -> ())?, withFoodItems data: MenuItem) {
        self.view3DHandler = view3DHandler
        self.itemTitle.text = data.menuItem
        self.itemDescription.text = data.itemDescription
        self.itemPrice.text = "$" + data.price!
        self.viewItemDetail = viewItemDetail
        self.documentID = data.documentID!
        self.isPublished = data.isPublished!
        self.mainImageView.roundCorners(corners: [.topLeft, .bottomLeft], radius: 5)
        
        
        if data.modelURL != "" && data.modelApproval == true {
            view3DButton.setTitle("VIEW IN 3D", for: .normal)
        } else{
            view3DButton.setTitle("VIEW", for: .normal)
        }
        
        
        if data.thumbnailImage?.prefix(4) == "gs:/" {
            API.shared.firebaseStorageManager.pullImageFromDatabase(fromURL: data.thumbnailImage ?? "https://www.tomfrancistreeservices.co.uk/wp-content/themes/wp-garden/assets/images/no-image.jpg") { mainImage in
                self.mainImageView.image = mainImage
            }
        } else {
            self.mainImageView.kf.setImage(with: URL(string: data.thumbnailImage ?? "https://www.tomfrancistreeservices.co.uk/wp-content/themes/wp-garden/assets/images/no-image.jpg"))
        }
        
        editButton.menu = API.shared.UIMenuDropdownManager.setUIMenu(UIActionArray: [(self.isPublished ? UIAction(title: "Unpublish", image: UIImage(systemName: "eye.slash.circle.fill"), handler: { _ in API.shared.UIMenuDropdownManager.unpublishItem(menuItemDocumentID: self.documentID)}) : UIAction(title: "Publish", image: UIImage(systemName: "icloud.and.arrow.up.fill"), handler: { _ in API.shared.UIMenuDropdownManager.publishItem(menuItemDocumentID: self.documentID)})),UIAction(title: "Edit", image: UIImage(systemName: "pencil.circle.fill"), handler: { _ in
                if self.viewItemDetail != nil{
                  self.viewItemDetail!()
                }
        })], menuItemDocumentID: self.documentID, viewController: self.viewController!)
        editButton.showsMenuAsPrimaryAction = true
    }
    
    /*
    func update(with3DHandler view3DHandler: (() -> ())?, withFoodItems data: Food) {
        
     //3d Button update
     
     //for thumbnail, text
     let gsReference = Storage.storage().reference(forURL: data.thumbnailImage)
        gsReference.getData(maxSize: 1 * 1024 * 1024) { data, error in
            if let error = error {
                print(error)
              } else {
                let image = UIImage(data: data!)
                  self.mainImageView.image = image
              }
        }
           itemTitle.text = data.foodName
           itemDescription.text = data.description
    }
     */
    
    @IBAction func view3DTapped(_ sender: Any) {
        if view3DHandler != nil {
            view3DHandler!()
        }
    }
   /*
    @IBAction func viewItemDetail(_ sender: Any) {
        if viewItemDetail != nil{
            viewItemDetail!()

        }
    }*/
    
}
