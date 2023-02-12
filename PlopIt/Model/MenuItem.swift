 //
//  MenuItem.swift
//  PlopIt
//
//  Created by Raivis Olehno on 20/01/2022.
//

import FirebaseFirestore

struct MenuItem {
    var menuID: String?
    var menuItem: String?
    var itemDescription: String?
    var price: String?
    var menuHeaderType: String?
    var menuHeaderID: Int?
    var restaurantID: String?
    var thumbnailImage: String?
    var modelURL: String?
    //var restaurantName: String?
    var ingredients: String?
    var modelApproval: Bool?
    var isPublished: Bool?
    var documentID: String?

    init?(snapshot: QueryDocumentSnapshot) {
        let data = snapshot.data()

        let menuID = data["menuID"] as? String
        let menuItem = data["menuItem"] as? String
        let itemDescription = data["itemDescription"] as? String
        let price = data["itemPrice"] as? String
        let menuHeaderType = data["type"] as? String
        let menuHeaderID = data["menuHeaderID"] as? Int
        let restaurantID = data["restaurantID"] as? String
        let thumbnailImage = data["thumbnailURL"] as? String
        let modelURL = data["modelURL"] as? String
        //let restaurantName = data["restaurantName"] as? String
        let ingredients = data["ingredients"] as? String
        let modelApproval = data["modelApproval"] as? Bool
        let isPublished = data["isPublished"] as? Bool
        let documentID = snapshot.reference.documentID

        self.menuID = menuID
        self.menuItem = menuItem
        self.itemDescription = itemDescription
        self.price = price
        self.menuHeaderType = menuHeaderType
        self.menuHeaderID = menuHeaderID
        self.restaurantID = restaurantID
        self.thumbnailImage = thumbnailImage
        self.modelURL = modelURL
        //self.restaurantName = restaurantName
        self.ingredients = ingredients
        self.modelApproval = modelApproval
        self.isPublished = isPublished
        self.documentID = documentID
    }
}

extension MenuItem {
    init() {
    }
}
