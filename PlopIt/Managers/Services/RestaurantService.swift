//
//  RestaurantService.swift
//  PlopIt
//
//  Created by Raivis Olehno on 09/01/2022.
//

import Foundation
import FirebaseFirestore
import UIKit
import Amplify
import CodableFirebase

class RestaurantService: NSObject {
    let db = Firestore.firestore()
    
    // FUNCTIONS REGARDING RESTAURANT COLLECTION
    
    func getRestaurants(withSuccess success:@escaping ([Restaurant]) -> (), withFailure failure: @escaping(String) -> ()) {
        db.collection(FirestoreTableInfo.restaurants).getDocuments { querySnapshot, error in
            if error != nil {
                return failure("")
            }
            let restaurants = querySnapshot?.documents
            if let restaurants = restaurants {
                var restaurantArray = [Restaurant]()
                for rest in restaurants {
                    let r = Restaurant(snapshot: rest)
                    
                    if r != nil {
                        restaurantArray.insert(r!, at: 0)
                    }
                }
                success(restaurantArray)
            }
        }
    }
    
    func getRestaurantsDetail(ownerID: String, completion: @escaping(Restaurant) -> Void) {
        
        db.collection("Restaurant").whereField("ownerID", isEqualTo: ownerID).getDocuments { querySnapshot, error in
            if let e = error {
                print(e)
            } else {
                if let safeSnapshot = querySnapshot?.documents[0] {
                    let restaurant = Restaurant.init(snapshot: safeSnapshot)
                    if let safeRestaurant = restaurant {
                        completion(safeRestaurant)
                    }
                }
            }
        }
    }
    
    func appendRestaurantMenuHeader( menuHeader: String, restaurantID: String) {
        db.collection(FirestoreTableInfo.restaurants).document(restaurantID).updateData([
            "menuHeaderArray": FieldValue.arrayUnion([menuHeader])
        ])
    }
    
    func deleteRestaurantMenuHeader( menuHeader: String, restaurantID: String) {
        db.collection(FirestoreTableInfo.restaurants).document(restaurantID).updateData([
            "menuHeaderArray": FieldValue.arrayRemove([menuHeader])
        ])
    }
    
    
    func moveRestaurantMenuHeader( menuHeader: String, restaurantID: String) {
        db.collection(FirestoreTableInfo.restaurants).document(restaurantID).updateData([
            "menuHeaderArray": "newState"
        ])
    }
    
    
    //function that should update the menuheader to appopriate position after done editing
    
//    func moveRestaurantMenuHeader( menuHeader: String, restaurantID: String) {
//        db.collection(FirestoreTableInfo.restaurants).document(restaurantID).updateData([
//            //"menuHeaderArray": FieldValue.
//        ])
//    }
    
  
    
    
    // fetch time on the .edit view
    //add dietary, genre variables for passing
    func updateRestaurantInfo(restaurantID: String, restaurantName: String, addressStreet: String, addressCity: String, addressState: String, addressZip: String, restaurantDescription: String, phoneNumber: String, priceRange: String, websiteURL: String, hourArray: [String], dietaryDict: [String:Bool], genreDict: [String:Bool], restaurantHeaderImageURL: String, restaurantThumbnailImageURL: String, withSuccess success:@escaping () -> (), withFailure failure: @escaping(String) -> ()) {
        db.collection(FirestoreTableInfo.restaurants).document(restaurantID).updateData([
            "restaurantInformation" : [
                "hours": [
                    "Monday" : hourArray[0],
                    "Tuesday" : hourArray[1],
                    "Wednesday" : hourArray[2],
                    "Thursday" : hourArray[3],
                    "Friday" : hourArray[4],
                    "Saturday" : hourArray[5],
                    "Sunday": hourArray[6],
                ],
                "phoneNumber" : phoneNumber,
                "restaurantAddress" : [
                    "city" : addressCity,
                    "latitudeLongitude" : "",
                    "state" : addressState,
                    "street" : addressStreet,
                    "zip" : addressZip,
                ],
                "restaurantDescription" : restaurantDescription,
                "restaurantName" : restaurantName,
                "websiteURL" : websiteURL,
            ],
            "restaurantSettings" : [
                //for testing, change to variable
                "dietary" : dietaryDict,
                "priceRange" : priceRange,
                "restaurantGenre" : genreDict,
                //pass variable for updating
                "restaurantHeaderImageURL" :restaurantHeaderImageURL,
                "restaurantThumbnailImageURL" : restaurantThumbnailImageURL
            ]
        ]) { err in
            if let err = err {
                print("Error updating published field in document: (err)")
                failure("\(err)")
            } else {
                success()
                print("Restaurant has successfully updated. Big Success!")
            }
        }
    }
    
    func getOwnerRestaurants(withEmail email: String, completion: @escaping(Restaurant) -> Void) {
        db.collection("Owners").whereField("email", isEqualTo: email).getDocuments { snapshot, error in
            guard let snapshot = snapshot, error == nil else {
                return
            }
            let docs = snapshot.documents
            let model = try! FirestoreDecoder().decode(Owner.self, from: (docs.first?.data())!)
            self.getRestaurantsDetail(ownerID: model.ownerID) { restaurant in
                completion(restaurant)
            }
        }
    }
    
    func getApprovedRestaurants( completion: @escaping([Restaurant]) -> Void) {
        db.collection("Restaurant").whereField("isApproved", isEqualTo: true).getDocuments { querySnapshot, error in
            if error != nil {
                print("error getting approved restaurants")
            }
            let restaurants = querySnapshot?.documents
            if let restaurants = restaurants {
                var restaurantArray = [Restaurant]()
                for rest in restaurants {
                    let r = Restaurant(snapshot: rest)
                    
                    if r != nil {
                        restaurantArray.insert(r!, at: 0)
                    }
                }
                completion(restaurantArray)
            }
        }
    }
    
    func getRestaurantByID(restaurantID: String, completion: @escaping(Restaurant) -> Void) {
        //let resID =
        let docRef = Firestore.firestore().collection("Restaurant").document(restaurantID)
        //let docRef = db.collection("Owners").document(uid)
        
        docRef.getDocument() { (document, error) in
            if let document = document{
                let data = document.data()
                //let restaurant = try! FirestoreDecoder().decode(Owner.self, from: (data)!)
                let restaurant = Restaurant(data: data)
                //let Owner = Owner(email: data!["email"], fullName: data!["fullName"], restaurantID: data!["restaurantID"], userID: data!["userID"], ownerID: data!["ownerID"])
                completion(restaurant!)
            } else{
                print("restaurant document does no exist")
            }
        }
    }
    

    
    // FUNCTIONS REGARDING MENUITEM COLLECTION
    
    func addNewMenuItem(menuItemDocumentID: String, menuItem: String, menuHeaderID: Int, itemDescription: String, itemPrice: String,thumbnailURL: String, restaurantID: String ,withSuccess success:@escaping () -> (), withFailure failure: @escaping(String) -> ()) {
        
        let docData: [String: Any] = [
            "menuItem": menuItem,
            "itemDescription": itemDescription,
            "menuHeaderID": menuHeaderID,
            "itemPrice": itemPrice,
            "restaurantID": restaurantID,
            "lastUpdatedDate": "",
            "modelApproval": false,
            "isPublished": false,
            "thumbnailURL": thumbnailURL,
            "modelURL": "",
            "scaleCompensation": "",
        ]
        
        db.collection(FirestoreTableInfo.menuItems).document(menuItemDocumentID).setData(
            docData) { error in
                if let error = error {
                    failure("\(error.localizedDescription)")
                } else {
                    success()
                }
            }
    }
    
    func getMenuItems(restaurantID: String, withSuccess success:@escaping ([MenuItem]) -> (), withFailure failure: @escaping(String) -> ()) {
        db.collection(FirestoreTableInfo.menuItems).whereField("restaurantID", isEqualTo: restaurantID).getDocuments { querySnapshot, error in
            if error != nil {
                return failure("")
            }
            let menuItems = querySnapshot?.documents
            if let menuItems = menuItems {
                var menuItemArray = [MenuItem]()
                for menuItem in menuItems {
                    let r = MenuItem(snapshot: menuItem)
                    
                    if r != nil {
                        menuItemArray.insert(r!, at: 0)
                    }
                }
                print(menuItemArray)
                success(menuItemArray)
            }
        }
    }
    
    func getPublishedMenuItems(restaurantID: String, withSuccess success:@escaping ([MenuItem]) -> (), withFailure failure: @escaping(String) -> ()) {
        db.collection(FirestoreTableInfo.menuItems)
            .whereField("restaurantID", isEqualTo: restaurantID)
            .whereField("isPublished", isEqualTo: true)
            .getDocuments { querySnapshot, error in
                if error != nil {
                    return failure("")
                }
                let menuItems = querySnapshot?.documents
                if let menuItems = menuItems {
                    var menuItemArray = [MenuItem]()
                    for menuItem in menuItems {
                        let r = MenuItem(snapshot: menuItem)
                        
                        if r != nil {
                            menuItemArray.insert(r!, at: 0)
                        }
                    }
                    print(menuItemArray)
                    success(menuItemArray)
                }
            }
    }
    
    func updateMenuItem(menuItemDocumentID: String,  menuItem: String, menuHeaderID: Int, itemDescription: String, itemPrice: String, thumbnailURL: String, isPublished: Bool, withSuccess success:@escaping () -> (), withFailure failure: @escaping(String) -> ()) {
        db.collection(FirestoreTableInfo.menuItems).document(menuItemDocumentID).updateData(["menuItem" : menuItem, "menuHeaderID" : menuHeaderID, "itemDescription" : itemDescription, "itemPrice" : itemPrice, "thumbnailURL" : thumbnailURL, "isPublished" : isPublished]) { err in
            if let err = err {
                print("Error updating published field in document: (err)")
                failure("\(err)")
            } else {
                success()
                print("Document isPublished successfully changed")
            }
        }
    }
    
    func deleteMenuItem( menuItemDocumentID: String) {
        db.collection(FirestoreTableInfo.menuItems).document(menuItemDocumentID).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
        }
    }
    
    func updateItemPublishedBool( menuItemDocumentID: String, isPublished: Bool ) {
        db.collection(FirestoreTableInfo.menuItems).document(menuItemDocumentID).updateData(["isPublished" : isPublished]) { err in
            if let err = err {
                print("Error updating published field in document: \(err)")
            } else {
                print("Document isPublished successfully changed")
            }
        }
    }
    
    func createEmptyMenuItemDocument() -> DocumentReference {
        let newMenuItemRef = db.collection(FirestoreTableInfo.menuItems).document()
        return newMenuItemRef
    }

}
