//
//  MessageTableViewCell.swift
//  PlopIt
//
//  Created by e on 3/22/22.
//

import UIKit
import SwiftUI

class MessageTableViewCell: UITableViewCell {
    
    @IBOutlet weak var menuItemLabel: UILabel!
    weak var viewController: UIViewController?
    
    var view3DHandler: (() -> ())?
    var viewItemDetail: (() -> ())?
    let model = CameraViewModel()
    private var url: URL?
    
    var menuItem: MenuItem?
    var sectionNumber: Int?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func update(with3DHandler view3DHandler: (() -> ())?, withItemHandler viewItemDetail: (() -> ())?, withFoodItem menuItem: MenuItem, sectionNumber: Int) {
        self.view3DHandler = view3DHandler
        self.viewItemDetail = viewItemDetail
        self.menuItem = menuItem
        self.sectionNumber = sectionNumber
        
        let accessoryButton = UIButton()
        accessoryButton.setImage(UIImage(systemName: "pencil.circle.fill"), for: .normal)
        accessoryButton.frame = CGRect(x: 0, y: 0, width: 60, height: 60)
        accessoryButton.contentMode = .scaleAspectFit
        
        var ActionArray = [UIAction]()
        
        //nav controller no returning
        let editAction = UIAction(title: "Edit", image: UIImage(systemName: "pencil.circle.fill"), handler: { _ in
            if viewItemDetail != nil{
                viewItemDetail!()
            }
        })
        
        //denied models: view, edit, retake,delete
        //pending models: edit, delete
        //approved but waiting to be published: view, edit, publish, delete
        if sectionNumber == 0 {
            ActionArray = [UIAction(title: "View", image: UIImage(systemName: "eye.circle.fill"), handler: { _ in
                if view3DHandler != nil {
                    view3DHandler!()
                    }
            }),
                editAction,
                UIAction(title: "Retake 3D Scan", image: UIImage(systemName: "camera.fill"), handler: { _ in
                    self.createScan()
                    self.submitRetake3DScan(menuItemDocumentID: (self.menuItem?.documentID!)!)
            })]
        } else if sectionNumber == 1 {
            ActionArray = [editAction]
        } else {
            ActionArray = [UIAction(title: "View", image: UIImage(systemName: "eye.circle.fill"), handler: { _ in
                if view3DHandler != nil {
                    view3DHandler!()
                }
            }),
            editAction,
            UIAction(title: "Publish", image: UIImage(systemName: "icloud.and.arrow.up.fill"), handler: { _ in API.shared.UIMenuDropdownManager.publishItem(menuItemDocumentID: self.menuItem!.documentID!)})]
        }
        
        accessoryButton.menu = API.shared.UIMenuDropdownManager.setUIMenu(UIActionArray: ActionArray, menuItemDocumentID: self.menuItem!.documentID!, viewController: self.viewController!)
        
        accessoryButton.showsMenuAsPrimaryAction = true
        self.accessoryView = accessoryButton as UIView
    }
    /*override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }*/
    
    func createScan() {
        _ = model.$captureFolderState.sink(receiveValue: { folder in
            self.url = folder?.captureDir
        })
        
        let view = CameraView(model: model).environment(\.uiHostingControllerPresenter, UIHostingControllerPresenter(self.viewController!))
        let viewHostingController = UIHostingController(rootView: view)
        
        viewHostingController.modalPresentationStyle = .fullScreen
        self.viewController!.present(viewHostingController, animated: true, completion: nil)
    }
    
    func submitRetake3DScan(menuItemDocumentID: String) {
        let images: [UIImage]? = API.shared.scannerManager.getScannedImageArray(url: self.url)
        
        if images != nil {
            for image in images! {
                if let data = image.jpegData(compressionQuality: 0.9) {
                    //API.shared.awsManager.uploadMultipleImages(with: data, restaurant: self.restaurant.restaurantID!, menuItem: menuItemDocumentID)
                }
            }
        }
    }
    
}
