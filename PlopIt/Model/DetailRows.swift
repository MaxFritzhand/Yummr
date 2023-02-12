//
//  DetailRows.swift
//  PlopIt
//
//  Created by Max Fritzhand on 4/23/22.
//

import Foundation
import UIKit

//providing information on restaurant information

struct DetailRows {
    var title: String
    var image: UIImage
    
    
//    func getTime(){
//    cell.rowLabel.text! = InformationDetailsViewController.todayDay()
//    }
    
    static var restaurantInformationRows: [DetailRows] = [
        
        //the above section includes a map, showing distance from you for it
        
        //Name
        //Genre, Price
        
        
        //Restaurant Address for row --> when tapped you are able to copy it
        DetailRows(title: "Address", image: UIImage(systemName:"location.fill")!),
       
        //this would be good to reference the getTime() if possible
        DetailRows(title: "Time", image: UIImage(systemName:"clock.fill")!),
        
        //Dietary Options
        DetailRows(title: "Dietary", image: UIImage(systemName:"leaf.fill")!),
        
        DetailRows(title: "Cuisine", image: UIImage(systemName:"fork.knife")!),
        
        DetailRows(title: "Website", image: UIImage(systemName:"network")!),
        //Rating
       // DetailRows(title: "Rating", image: UIImage(systemName:"gear")!),
        
    ]
    
    
}


 


 
