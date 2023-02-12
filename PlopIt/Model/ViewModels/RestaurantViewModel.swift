//
//  RestaurantViewModel.swift
//  PlopIt
//
//  Created by Max Fritzhand on 1/27/22.
//

import Foundation
import Firebase
import UIKit

class RestaurantViewModel: BaseVM {
    
//    var menuItem: String = ""
//    var itemDescription: String = ""
//    var price: String = ""
//    var type: String = ""
//    var restaurantID: String = ""
//    var thumbnailImage: String = ""
    //var ModelURL: String = ""
    
    //var menuItems = [MenuItem]()
    
    var restaurantData = [RestaurantData]()
    
    func addRestaurant(completionHandeler: @escaping ((_ success: Bool, _ message: String)->())) {
        var ref: DocumentReference? = nil
        ref = db.collection(FirestoreTableInfo.restaurantData).addDocument(
            data: [
//                "menuItem": menuItem,
//                "itemDescription": itemDescription,
//                "price": price,
//                "type": type,
//                "restaurantID": restaurantID,
//                "thumbnailImage" : thumbnailImage
            ]) { error in
            if let error = error {
                completionHandeler(false, error.localizedDescription)
            } else {
                completionHandeler(true, "Menu Item Added Succesfully!")
            }
        }
    }
    
    func getRestaurant(completionHandeler: @escaping ((_ success: Bool, _ message: String)->())) {
        db.collection(FirestoreTableInfo.restaurantData).getDocuments { querySnapshot, error in
            if let err = error {
                print("Error getting documents: \(err)")
                completionHandeler(false, err.localizedDescription)
            } else {
                guard let restaurantDataJSON = querySnapshot?.documents else{
                    return
                }
               
                for restaurantData in restaurantDataJSON {
                    let restaurantData = RestaurantData(json: restaurantData.data(), documentId: restaurantData.documentID)
                    self.restaurantData.append(restaurantName)
                }
            }
        }
    }
}

