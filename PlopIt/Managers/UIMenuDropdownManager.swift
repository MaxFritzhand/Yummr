//
//  UIMenuDropdownManager.swift
//  PlopIt
//
//  Created by e on 4/21/22.
//

import Foundation
import UIKit

class UIMenuDropdownManager: Manager {
    
    func setUIMenu(UIActionArray: [UIAction], menuItemDocumentID: String, viewController: UIViewController) -> UIMenu {
        
        let destruct = UIAction(title: "Delete", attributes: .destructive) { _ in
            self.deleteAlert(menuItemDocumentID: menuItemDocumentID, viewController: viewController)
        }
        
        let items = UIMenu(title: "Actions", options: .displayInline, children: UIActionArray)
        
        return UIMenu(title: "", children: [items, destruct])
    }
    
    func deleteAlert(menuItemDocumentID: String, viewController: UIViewController) {
        let ac = UIAlertController(title: "Delete Item", message: "Are you sure you want to delete this item?", preferredStyle: .alert)
        
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: { (action) in
            //
            API.shared.restaurantManager.restaurantService.deleteMenuItem(menuItemDocumentID: menuItemDocumentID)
            //self.menuItems!.remove(at: self.cellRow!)
            //self.tableView!.reloadData()
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {_ in
        })
        
        ac.addAction(deleteAction)
        ac.addAction(cancelAction)
        //self.menuItems?.remove(at: self.cellRow!)
        
        viewController.present(ac, animated: true)
        
        // needs to delete row to remove it
    }
    
    func unpublishItem(menuItemDocumentID: String) {
        API.shared.restaurantManager.restaurantService.updateItemPublishedBool( menuItemDocumentID: menuItemDocumentID, isPublished: false )
        //self.tableView!.reloadData()
    }
    
    func publishItem(menuItemDocumentID: String) {
        API.shared.restaurantManager.restaurantService.updateItemPublishedBool( menuItemDocumentID: menuItemDocumentID, isPublished: true )
        //self.tableView!.reloadData()
    }
    
}
