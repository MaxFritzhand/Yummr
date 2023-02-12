//
//  ProfileRows.swift
//  PlopIt
//
//  Created by Raivis Olehno on 22/03/2022.
//

import Foundation
import UIKit

struct RestaurantDetailRows {
    var title: String
    var text: String = ""
    static var restaurantDetailRows: [RestaurantDetailRows] = [
        RestaurantDetailRows(title: "RestaurantName"),
        RestaurantDetailRows(title: "Description"),
        RestaurantDetailRows(title: "How Expensive"),
        RestaurantDetailRows(title: "Restaurant Address")
    ]
    static func updateInfo(_ restaurant: Restaurant) {
        restaurantDetailRows[0].text = restaurant.restaurantName ?? ""
        restaurantDetailRows[1].text = restaurant.restaurantDescription ?? ""
        restaurantDetailRows[2].text = (restaurant.priceRange as? String? ?? "$")!
        //restaurantDetailRows[3].text = (restaurant.address!["city"]!) + (restaurant.address!["state"]!) + (restaurant.address!["street"]!) + (restaurant.address!["zip"]!)
        
        var street = (restaurant.street as? String? ?? "")!
        var city = (restaurant.city as? String? ?? "")!
        var state = (restaurant.city as? String? ?? "")!
        var zip = (restaurant.city as? String? ?? "")!
        
        restaurantDetailRows[3].text = street + "" + city + "" + state + "" + zip
    }
}

