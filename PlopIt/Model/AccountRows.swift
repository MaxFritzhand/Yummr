//
//  ProfileRows.swift
//  PlopIt
//
//  Created by Raivis Olehno on 22/03/2022.
//

import Foundation
import UIKit

struct AccountRows {
    var title: String
    var image: UIImage
    var text: String = ""
    static var userRows: [AccountRows] = [
        AccountRows(title: "Name", image: UIImage(systemName:"person.crop.circle.fill", withConfiguration: UIImage.SymbolConfiguration(scale: .large))!),
        AccountRows(title: "Email Address", image: UIImage(systemName:"envelope.fill", withConfiguration: UIImage.SymbolConfiguration(scale: .large))!),
        AccountRows(title: "Phone Number", image: UIImage(systemName:"phone.fill", withConfiguration: UIImage.SymbolConfiguration(scale: .large))!)
        
    ]
    static func updateInfo(_ user: User) {
        userRows[0].text = user.fullName ?? "Edit Name"
        userRows[1].text = user.email ?? "Edit Email"
        userRows[2].text = "Phone Number"
 
    }
//    static var ownerRows: [AccountRows] = [
//    ]


    
    
}
