//
//  ProfileRows.swift
//  PlopIt
//
//  Created by Raivis Olehno on 22/03/2022.
//

import Foundation
import UIKit

struct ProfileRows {
    var title: String
    var image: UIImage
    
    static var userProfileRows: [ProfileRows] = [
        ProfileRows(title: "Favorites", image: UIImage(systemName:"heart.fill")!),
        //ProfileRows(title: "Support", image: UIImage(systemName:"person.fill.questionmark")!),
        ProfileRows(title: "Account", image: UIImage(systemName:"gear")!)
        
    ]

    
//    //Owner
//    static var ownerProfileRows: [ProfileRows] = [
//        ProfileRows(title: "My Restaurant", image: UIImage(systemName:"list.dash.header.rectangle")!),
//        ProfileRows(title: "Messages", image: UIImage(systemName:"bell.fill")!),
//        ProfileRows(title: "Favorites", image: UIImage(systemName:"heart.fill")!),
//        ProfileRows(title: "Support", image: UIImage(systemName:"person.fill.questionmark")!),
//        ProfileRows(title: "Account", image: UIImage(systemName:"gear")!)
//    ]
    
    
    static var ownerProfileRows: [ProfileRows] = [
        ProfileRows(title: "My Restaurant", image: UIImage(systemName:"list.dash.header.rectangle")!),
        ProfileRows(title: "Messages", image: UIImage(systemName:"bell.fill")!),
        ProfileRows(title: "Account", image: UIImage(systemName:"gear")!)
    ]
    
    
}


class Section{
    let title: String
    //let options: [ProfileRows]
    let options: [String]
    var isOpened: Bool = false
    
    init(
        title: String,
        options: [String],
        isOpened: Bool = false
    ){
        self.title = title
        self.options = options
        self.isOpened = isOpened
            
        }
    
    
    
    //var models = [Section]()
    
}



//let imageName = [
//
//    "restaurant" : UIImage(systemName:"list.dash.header.rectangle"),
//    "messages" : UIImage(systemName:"bell.fill"),
//    "favorites" : UIImage(systemName:"heart.fill"),
//     "support" : UIImage(systemName:"person.fill.questionmark"),
//    "profile": UIImage(systemName:"person.fill")
//    ]
