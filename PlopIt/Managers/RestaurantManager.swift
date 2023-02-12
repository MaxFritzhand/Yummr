//
//  RestaurantManager.swift
//  PlopIt
//
//  Created by Raivis Olehno on 20/01/2022.
//

import UIKit
import FirebaseFirestore

@objc protocol PIRestaurantConsumer: class, NSObjectProtocol {
    @objc optional func didAddRestaurantItem()
    @objc optional func didFailToAddRestaurantItem()
    @objc optional func didUpdateRestaurantItem()
    @objc optional func didFailToUpdateRestaurantItem()

}

class RestaurantManager: Manager {
    let db = Firestore.firestore()
    let restaurantService = RestaurantService()
    
   /*static let shared OwnerRestaurant = Restaurant{
        let instance = Singleton()
        // Setup code
        return instance
    }()*/
    
    func getRestaurants(withSuccess success:@escaping ([Restaurant]) -> (), withFailure failure: @escaping(String) -> ()) {
        restaurantService.getRestaurants(withSuccess: success, withFailure: failure)
    }
    
    func getMenuItems(restaurantID: String, withSuccess success:@escaping ([MenuItem]) -> (), withFailure failure: @escaping(String) -> ()) {
        restaurantService.getMenuItems(restaurantID: restaurantID, withSuccess: success, withFailure: failure)
    }
    
    
    func deleteMenuItem(menuItemDocumentID: String) {
        restaurantService.deleteMenuItem(menuItemDocumentID: menuItemDocumentID)
    }
    
    func updateItemPublishedBool( menuItemDocumentID: String, isPublished: Bool ) {
        restaurantService.updateItemPublishedBool(menuItemDocumentID: menuItemDocumentID, isPublished: isPublished)
    }
    
    func getPublishedMenuItems(restaurantID: String, withSuccess success:@escaping ([MenuItem]) -> (), withFailure failure: @escaping(String) -> ()) {
        restaurantService.getPublishedMenuItems(restaurantID: restaurantID, withSuccess: success, withFailure: failure)
    }
    
    func addNewMenuItem(menuItemDocumentID: String, menuItem: String, menuHeaderID: Int, itemDescription: String, itemPrice: String, thumbnailURL: String, restaurantID: String) {
        restaurantService.addNewMenuItem(menuItemDocumentID: menuItemDocumentID, menuItem: menuItem, menuHeaderID: menuHeaderID, itemDescription: itemDescription, itemPrice: itemPrice, thumbnailURL: thumbnailURL, restaurantID: restaurantID) {
            self.informConsumersDidAddRestaurantItem()
        } withFailure: { error in
            DispatchQueue.main.async {
                API.shared.bannerManager.showErrorNotification(withMessage: error)
            }
        }
    }
    
    func updateMenuItem(menuDocumentID: String, menuItem: String, menuHeaderID: Int, itemDescription: String, itemPrice: String, thumbnailURL: String, isPublished: Bool) {
        restaurantService.updateMenuItem(menuItemDocumentID: menuDocumentID, menuItem: menuItem, menuHeaderID: menuHeaderID, itemDescription: itemDescription, itemPrice: itemPrice, thumbnailURL: thumbnailURL, isPublished: isPublished) {
            self.informConsumersDidUpdateRestaurantMenuItem()
        } withFailure: { error in
            self.informConsumersFailedToAddRestaurantMenuItem()
        }

    }
    func updateRestaurantInfo(restaurantID: String, restaurantName: String, addressStreet: String, addressCity: String, addressState: String, addressZip: String, restaurantDescription: String, phoneNumber: String, priceRange: String, websiteURL: String, hourArray: [String], dietaryDict: [String:Bool], genreDict: [String:Bool], restaurantHeaderImageURL: String, restaurantThumbnailImageURL: String) {
            restaurantService.updateRestaurantInfo(restaurantID: restaurantID, restaurantName: restaurantName, addressStreet: addressStreet, addressCity: addressCity, addressState: addressState, addressZip: addressZip, restaurantDescription: restaurantDescription, phoneNumber: phoneNumber, priceRange: priceRange, websiteURL: websiteURL, hourArray: hourArray, dietaryDict: dietaryDict, genreDict: genreDict, restaurantHeaderImageURL: restaurantHeaderImageURL, restaurantThumbnailImageURL: restaurantThumbnailImageURL) {
                self.informConsumersDidUpdateRestaurantMenuItem()
            } withFailure: { error in
                self.informConsumersFailedToAddRestaurantMenuItem()
            }

        }
    
    func createEmptyMenuItemDocument() -> DocumentReference {
        let newMenuItemRef = restaurantService.createEmptyMenuItemDocument()
        return newMenuItemRef
    }


    //MARK: CONSUMERS
    
    func informConsumersDidAddRestaurantItem() {
            let consumersEnumerator = self.consumers?.objectEnumerator().allObjects
            if consumersEnumerator != nil {
                for consumer in consumersEnumerator! {
                    if (consumer as! PIRestaurantConsumer).responds(to: #selector(PIRestaurantConsumer.didAddRestaurantItem)) {
                        (consumer as! PIRestaurantConsumer).didAddRestaurantItem!()
                    }
                }
            }
        }
        
        func informConsumersFailedToAddRestaurantMenuItem() {
            let consumersEnumerator = self.consumers?.objectEnumerator().allObjects
            if consumersEnumerator != nil {
                for consumer in consumersEnumerator! {
                    if (consumer as! PIRestaurantConsumer).responds(to: #selector(PIRestaurantConsumer.didFailToAddRestaurantItem)) {
                        (consumer as! PIRestaurantConsumer).didFailToAddRestaurantItem!()
                    }
                }
            }
        }
        
        func informConsumersDidUpdateRestaurantMenuItem() {
            let consumersEnumerator = self.consumers?.objectEnumerator().allObjects
            if consumersEnumerator != nil {
                for consumer in consumersEnumerator! {
                    if (consumer as! PIRestaurantConsumer).responds(to: #selector(PIRestaurantConsumer.didUpdateRestaurantItem)) {
                        (consumer as! PIRestaurantConsumer).didUpdateRestaurantItem!()
                    }
                }
            }
        }
        
        func informConsumersDidFailToUpdateRestaurantMenuItem() {
            let consumersEnumerator = self.consumers?.objectEnumerator().allObjects
            if consumersEnumerator != nil {
                for consumer in consumersEnumerator! {
                    if (consumer as! PIRestaurantConsumer).responds(to: #selector(PIRestaurantConsumer.didFailToUpdateRestaurantItem)) {
                        (consumer as! PIRestaurantConsumer).didFailToUpdateRestaurantItem!()
                    }
                }
            }
        }

}
