//
//  User.swift
//  PlopIt
//
//  Created by Raivis Olehno on 06/02/2022.
//

import Foundation

//struct User {
//    let email: String
//    let fullName: String
//    let username: String
//
//    init(dic: [String: Any]) {
//        email = dic["email"] as! String
//        fullName = dic["fullName"] as! String
//        username = dic["username"] as! String
//    }
//}

struct User :  Codable{
   
    let email: String?
    let favoriteID: String?
    let fullName: String?
    let username: String?
    let isOwner:Bool?
    let ownerID: String?
    let userID : String?
}
