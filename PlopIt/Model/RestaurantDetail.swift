//
//  RestaurantDetail.swift
//  PlopIt
//
//  Created by Max Fritzhand on 1/27/22.
//


import UIKit

class RestaurantDetail {
    
//    var city = ""
//    var latitudeLongitude = ""
//    var state = ""
//    var street = ""
//    var zip = ""
    
    var city: String
    var latitudeLongitude: String
    var state: String
    var street: String
    var zip: String
       
    
    
    
//    let id: UUID
//    var restaurantImage: UIImage
//    var businessName: String
//    var ownerName: String
//    var reviews: Float
//    var restaurantCategory: String
//    var farAway: Float
    

    init() { }
    
    //initializer need to be fixed
    init(json: [String: Any], modelID: String = "", uniqueMenuID: String = "", documentId: String = "") {
        //documentID = documentId
        self.city = json["city"] as? String ?? ""
        self.latitudeLongitude = json["latitudeLongitude"] as? String ?? ""
        self.state = json["state"] as? String ?? ""
        self.street = json["street"] as? String ?? ""
        self.zip = json["zip"] as? String ?? ""
        
    
    }
}

extension RestaurantDetail {
    static let addressData: [RestaurantDetail] =
    [
        RestaurantDetail(city: "Cincinnati", latitudeLongitude: "51.52, 15.25", state: "OH", street: "tory ln", zip: "12345" ),
        RestaurantDetail(city: "Cincinnati", latitudeLongitude: "51.52, 15.25", state: "OH", street: "tory ln", zip: "12345" ),
        RestaurantDetail(city: "Cincinnati", latitudeLongitude: "51.52, 15.25", state: "OH", street: "tory ln", zip: "12345" ),
        RestaurantDetail(city: "Cincinnati", latitudeLongitude: "51.52, 15.25", state: "OH", street: "tory ln", zip: "12345" ),
        RestaurantDetail(city: "Cincinnati", latitudeLongitude: "51.52, 15.25", state: "OH", street: "tory ln", zip: "12345" ),
        RestaurantDetail(city: "Cincinnati", latitudeLongitude: "51.52, 15.25", state: "OH", street: "tory ln", zip: "12345" ),
        
    ]
}
