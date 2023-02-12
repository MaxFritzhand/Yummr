//
//  MenuHeaderRows.swift
//  Yummr
//
//  Created by Max Fritzhand on 5/20/22.
//


import Foundation
import UIKit

//providing information on restaurant information

struct MenuHeaderRows {
    var title: String
 

    
    static var menuHeaderRows: [MenuHeaderRows] = [
        
        
        //pull from firestore
        MenuHeaderRows(title: "Brekky"),
        MenuHeaderRows(title: "Lunchh"),
        MenuHeaderRows(title: "Din Din"),
  
        
       
        
    ]
    
    
}


 


 
