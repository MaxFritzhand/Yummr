//
//  User.swift
//  PlopIt
//
//  Created by Raivis Olehno on 06/02/2022.
//

import Foundation

/*struct Owner {
    var email: String?
    var fullName: String?
    var restaurantID: String?
    var userID: String?
    var ownerID : String?

    init?(email: email, fullName: fullName, restaurantID: restauarantID, userID: userID, ownerID: ownerID) {
        self.email = email
        self.fullName = fullName
        self.restaurantID = restaurantID
        self.userID = userID
        self.ownerID = ownerID
    }
}*/

struct Owner: Codable {
    let email: String
    let fullName: String
    let restaurantID: String
    let userID: String
    let ownerID : String

}
