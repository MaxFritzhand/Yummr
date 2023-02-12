//
//  Restaurant.swift
//  PlopIt
//
//  Created by Raivis Olehno on 27/01/2022.
//
import FirebaseFirestore
//import FirebaseFirestoreSwift
import Foundation

//
//struct restaurantInformation : Codable{
//    @DocumentID var id : String?
//    var hours : dayHours?
//    var phoneNumber : String
//    var address : addressInfo?
//    var restaurantDescription: String
//    var restaurantName : String
//    var websiteURL : String
//}
//struct dayHours : Codable{
//    var mondayHours : String
//    var tuesdayHours : String
//    var wednesdayHours : String
//    var thursdayHours : String
//    var fridayHours : String
//    var saturdayHours : String
//    var sundayHours : String
//}
//struct addressInfo : Codable{
//    var city : String
//    var latitudeLongitude: String
//    var state : String
//    var street : String
//    var zip : String
//}

struct Restaurant{
    

    
    var restaurantID: String?
    //var businessName: String?
   // var restaurantImage: String?
    var ownerID: String?
    var isApproved: Bool?
    
    var users: [String]?
    
    var menuHeaderArray: [String]?
    //information dictionary
    var information: [String: Any]?
    var restaurantName: String?
    var restaurantDescription: String?
    var websiteURL: String?
    var phoneNumber: String?
    var hours: [String: String]?
    var mondayHours : String?
    var tuesdayHours : String?
    var wednesdayHours : String?
    var thursdayHours : String?
    var fridayHours : String?
    var saturdayHours : String?
    var sundayHours : String?
    
    
    
    var address: [String: String]?
    var street: String?
    var city: String?
    var state: String?
    var zip: String?
    
    //settings dictionary
    //for this to conform properly, need to take out header, etc. from DS
    var settings: [String: String]?
    var dietary: [String: Bool]?
    var glutenFree: Bool?
    var halal: Bool?
    var kosher: Bool?
    var vegan: Bool?
    var vegetarian: Bool?
    
    
    
    var priceRange: String?
    var restaurantGenre: [String: Bool]?
    var american: Bool?
    var bakery: Bool?
    var chinese: Bool?
    var fastFood: Bool?
    var french: Bool?
    var indian: Bool?
    var italian: Bool?
    var japanese: Bool?
    var mexican: Bool?
    var pizza: Bool?
    var seafood: Bool?
    var steak: Bool?
    var thai: Bool?
    
    var restaurantHeaderImageURL: String?
    var restaurantThumbnailImageURL: String?

    init?(snapshot: QueryDocumentSnapshot) {
        let data = snapshot.data()
        let restaurantID = data["restaurantID"] as? String
        let ownerID = data["ownerID"] as? String
        let isApproved = data["isApproved"] as? Bool
        let users = data["users"] as? [String]
        let menuHeaderArray = data["menuHeaderArray"] as? [String]
        
        let information = data["restaurantInformation"] as? [String: Any]
        let restaurantName = information!["restaurantName"] as? String
        let restaurantDescription = information!["restaurantDescription"] as? String
        let phoneNumber = information!["phoneNumber"] as? String
        let websiteURL = information!["websiteURL"] as? String
        
        let address = information!["restaurantAddress"] as? [String: String]
        let street = address!["street"] as? String
        let city = address!["city"] as? String
        let state = address!["state"] as? String
        let zip = address!["zip"] as? String
        
        let hours = information!["hours"] as? [String: String]
        let mondayHours = hours!["Monday"]
        let tuesdayHours = hours!["Tuesday"]
        let wednesdayHours = hours!["Wednesday"]
        let thursdayHours = hours!["Thursday"]
        let fridayHours = hours!["Friday"]
        let saturdayHours = hours!["Saturday"]
        let sundayHours = hours!["Sunday"]
        
        let settings = data["restaurantSettings"] as? [String: Any]
        
        let priceRange = settings!["priceRange"] as? String
        let dietary = settings!["dietary"] as? [String: Bool]
        let glutenFree = dietary!["glutenFree"] as? Bool
        let halal = dietary!["halal"] as? Bool
        let kosher = dietary!["kosher"] as? Bool
        let vegan = dietary!["vegan"] as? Bool
        let vegetarian = dietary!["vegetarian"] as? Bool
        
        let restaurantGenre = settings!["restaurantGenre"] as? [String: Bool]
        let american = restaurantGenre!["american"] as? Bool
        let bakery = restaurantGenre!["bakery"] as? Bool
        let chinese = restaurantGenre!["chinese"] as? Bool
        let fastFood = restaurantGenre!["fastFood"] as? Bool
        let french = restaurantGenre!["french"] as? Bool
        let indian = restaurantGenre!["indian"] as? Bool
        let italian = restaurantGenre!["italian"] as? Bool
        let japanese = restaurantGenre!["japanese"] as? Bool
        let mexican = restaurantGenre!["mexican"] as? Bool
        let pizza = restaurantGenre!["pizza"] as? Bool
        let seafood = restaurantGenre!["seafood"] as? Bool
        let steak = restaurantGenre!["steak"] as? Bool
        let thai = restaurantGenre!["thai"] as? Bool
        let restaurantHeaderImageURL = settings!["restaurantHeaderImageURL"] as? String
        let restaurantThumbnailImageURL = settings!["restaurantThumbnailImageURL"] as? String
        
        self.restaurantID = restaurantID
        self.ownerID = ownerID
        self.isApproved = isApproved
        self.users = users
        self.menuHeaderArray = menuHeaderArray
        /*information dictionary, with keys-- hours(Dictionary Keys: Monday,Tuesday,Wednesday,Thursday,Friday,Saturday,Sunday), phoneNumber, restaurantAddress(Dictionary Keys: street,city,state,zip)
        restaurantDescription, restaurantName, websiteURL*/
        //self.information = information
        self.restaurantName = restaurantName
        self.restaurantDescription = restaurantDescription
        self.websiteURL = websiteURL
        self.phoneNumber = phoneNumber
        self.hours = hours
        self.mondayHours = mondayHours
        self.tuesdayHours = tuesdayHours
        self.wednesdayHours = wednesdayHours
        self.thursdayHours = thursdayHours
        self.fridayHours = fridayHours
        self.saturdayHours = saturdayHours
        self.sundayHours = sundayHours
        
        self.address = address
        self.street = street
        self.city = city
        self.state = state
        self.zip = zip
        /*settings dictionary, with keys-- dietary(Dictionary Keys:glutenFree, halal, kosher, vegan, vegetarian Value: Bool), restaurantHeaderImageURL, restaurantThumbnailImageURL
        restaurantGenre(Dictionary Keys: american,bakery,chinese,fastFood,french,indian,italian,japanese,mexican,pizza,seafood,steak,thai Value: Bool)*/
       // self.settings = settings
        self.dietary = dietary
        self.glutenFree = glutenFree
        self.halal = halal
        self.kosher = kosher
        self.vegan = vegan
        self.vegetarian = vegetarian
        self.priceRange = priceRange
        self.restaurantGenre = restaurantGenre
        self.american = american
        self.bakery = bakery
        self.chinese = chinese
        self.fastFood = fastFood
        self.french = french
        self.indian = indian
        self.italian = italian
        self.japanese = japanese
        self.mexican = mexican
        self.pizza = pizza
        self.seafood = seafood
        self.steak = steak
        self.thai = thai
        
        
        self.restaurantHeaderImageURL = restaurantHeaderImageURL
        self.restaurantThumbnailImageURL = restaurantThumbnailImageURL
    }

    init?(data: [String : Any]?) {
        //let data = snapshot.data()
        let restaurantID = data!["restaurantID"] as? String
        let ownerID = data!["ownerID"] as? String
        let isApproved = data!["isApproved"] as? Bool
        let users = data!["users"] as? [String]
        let menuHeaderArray = data!["menuHeaderArray"] as? [String]
        
        let information = data!["restaurantInformation"] as? [String: Any]
        let restaurantName = information!["restaurantName"] as? String
        let restaurantDescription = information!["restaurantDescription"] as? String
        let phoneNumber = information!["phoneNumber"] as? String
        let websiteURL = information!["websiteURL"] as? String
        
        let address = information!["restaurantAddress"] as? [String: String]
        let street = address!["street"] as? String
        let city = address!["city"] as? String
        let state = address!["state"] as? String
        let zip = address!["zip"] as? String
        
        let hours = information!["hours"] as? [String: String]
        let mondayHours = hours!["Monday"]
        let tuesdayHours = hours!["Tuesday"]
        let wednesdayHours = hours!["Wednesday"]
        let thursdayHours = hours!["Thursday"]
        let fridayHours = hours!["Friday"]
        let saturdayHours = hours!["Saturday"]
        let sundayHours = hours!["Sunday"]
        
        let settings = data!["restaurantSettings"] as? [String: Any]
        
        let priceRange = settings!["priceRange"] as? String
        let dietary = settings!["dietary"] as? [String: Bool]
        let glutenFree = dietary!["glutenFree"] as? Bool
        let halal = dietary!["halal"] as? Bool
        let kosher = dietary!["kosher"] as? Bool
        let vegan = dietary!["vegan"] as? Bool
        let vegetarian = dietary!["vegetarian"] as? Bool
        
        let restaurantGenre = settings!["restaurantGenre"] as? [String: Bool]
        let american = restaurantGenre!["american"] as? Bool
        let bakery = restaurantGenre!["bakery"] as? Bool
        let chinese = restaurantGenre!["chinese"] as? Bool
        let fastFood = restaurantGenre!["fastFood"] as? Bool
        let french = restaurantGenre!["french"] as? Bool
        let indian = restaurantGenre!["indian"] as? Bool
        let italian = restaurantGenre!["italian"] as? Bool
        let japanese = restaurantGenre!["japanese"] as? Bool
        let mexican = restaurantGenre!["mexican"] as? Bool
        let pizza = restaurantGenre!["pizza"] as? Bool
        let seafood = restaurantGenre!["seafood"] as? Bool
        let steak = restaurantGenre!["steak"] as? Bool
        let thai = restaurantGenre!["thai"] as? Bool
        let restaurantHeaderImageURL = settings!["restaurantHeaderImageURL"] as? String
        let restaurantThumbnailImageURL = settings!["restaurantThumbnailImageURL"] as? String
        
        self.restaurantID = restaurantID
        self.ownerID = ownerID
        self.isApproved = isApproved
        self.users = users
        self.menuHeaderArray = menuHeaderArray
        /*information dictionary, with keys-- hours(Dictionary Keys: Monday,Tuesday,Wednesday,Thursday,Friday,Saturday,Sunday), phoneNumber, restaurantAddress(Dictionary Keys: street,city,state,zip)
        restaurantDescription, restaurantName, websiteURL*/
        //self.information = information
        self.restaurantName = restaurantName
        self.restaurantDescription = restaurantDescription
        self.websiteURL = websiteURL
        self.phoneNumber = phoneNumber
        self.hours = hours
        self.mondayHours = mondayHours
        self.tuesdayHours = tuesdayHours
        self.wednesdayHours = wednesdayHours
        self.thursdayHours = thursdayHours
        self.fridayHours = fridayHours
        self.saturdayHours = saturdayHours
        self.sundayHours = sundayHours
        
        self.address = address
        self.street = street
        self.city = city
        self.state = state
        self.zip = zip
        /*settings dictionary, with keys-- dietary(Dictionary Keys:glutenFree, halal, kosher, vegan, vegetarian Value: Bool), restaurantHeaderImageURL, restaurantThumbnailImageURL
        restaurantGenre(Dictionary Keys: american,bakery,chinese,fastFood,french,indian,italian,japanese,mexican,pizza,seafood,steak,thai Value: Bool)*/
       // self.settings = settings
        self.dietary = dietary
        self.glutenFree = glutenFree
        self.halal = halal
        self.kosher = kosher
        self.vegan = vegan
        self.vegetarian = vegetarian
        self.priceRange = priceRange
        self.restaurantGenre = restaurantGenre
        self.american = american
        self.bakery = bakery
        self.chinese = chinese
        self.fastFood = fastFood
        self.french = french
        self.indian = indian
        self.italian = italian
        self.japanese = japanese
        self.mexican = mexican
        self.pizza = pizza
        self.seafood = seafood
        self.steak = steak
        self.thai = thai
        
        
        self.restaurantHeaderImageURL = restaurantHeaderImageURL
        self.restaurantThumbnailImageURL = restaurantThumbnailImageURL
    }

   /* init?(snapshot: DocumentSnapshot) {
        let data = snapshot.data()
        let restaurantID = data!["restaurantID"] as? String
        let ownerID = data!["ownerID"] as? String
        let isApproved = data!["isApproved"] as? Bool
        let users = data!["users"] as? [String]
        let menuHeaderArray = data!["menuHeaderArray"] as? [String]
        
        let information = data!["restaurantInformation"] as? [String: Any]
        let restaurantName = information!["restaurantName"] as? String
        let restaurantDescription = information!["restaurantDescription"] as? String
        let phoneNumber = information!["phoneNumber"] as? String
        let websiteURL = information!["websiteURL"] as? String
        
        let address = information!["restaurantAddress"] as? [String: String]
        let street = address!["street"] as? String
        let city = address!["city"] as? String
        let state = address!["state"] as? String
        let zip = address!["zip"] as? String
        
        let hours = information!["hours"] as? [String: String]
        let mondayHours = hours!["Monday"]
        let tuesdayHours = hours!["Tuesday"]
        let wednesdayHours = hours!["Wednesday"]
        let thursdayHours = hours!["Thursday"]
        let fridayHours = hours!["Friday"]
        let saturdayHours = hours!["Saturday"]
        let sundayHours = hours!["Sunday"]
        
        let settings = data!["restaurantSettings"] as? [String: Any]
        
        let priceRange = settings!["priceRange"] as? String
        let dietary = settings!["dietary"] as? [String: Bool]
        let glutenFree = dietary!["glutenFree"] as? Bool
        let halal = dietary!["halal"] as? Bool
        let kosher = dietary!["kosher"] as? Bool
        let vegan = dietary!["vegan"] as? Bool
        let vegetarian = dietary!["vegetarian"] as? Bool
        
        let restaurantGenre = settings!["restaurantGenre"] as? [String: Bool]
        let american = restaurantGenre!["american"] as? Bool
        let bakery = restaurantGenre!["bakery"] as? Bool
        let chinese = restaurantGenre!["chinese"] as? Bool
        let fastFood = restaurantGenre!["fastFood"] as? Bool
        let french = restaurantGenre!["french"] as? Bool
        let indian = restaurantGenre!["indian"] as? Bool
        let italian = restaurantGenre!["italian"] as? Bool
        let japanese = restaurantGenre!["japanese"] as? Bool
        let mexican = restaurantGenre!["mexican"] as? Bool
        let pizza = restaurantGenre!["pizza"] as? Bool
        let seafood = restaurantGenre!["seafood"] as? Bool
        let steak = restaurantGenre!["steak"] as? Bool
        let thai = restaurantGenre!["thai"] as? Bool
        let restaurantHeaderImageURL = settings!["restaurantHeaderImageURL"] as? String
        let restaurantThumbnailImageURL = settings!["restaurantThumbnailImageURL"] as? String
        
        self.restaurantID = restaurantID
        self.ownerID = ownerID
        self.isApproved = isApproved
        self.users = users
        self.menuHeaderArray = menuHeaderArray
        /*information dictionary, with keys-- hours(Dictionary Keys: Monday,Tuesday,Wednesday,Thursday,Friday,Saturday,Sunday), phoneNumber, restaurantAddress(Dictionary Keys: street,city,state,zip)
        restaurantDescription, restaurantName, websiteURL*/
        //self.information = information
        self.restaurantName = restaurantName
        self.restaurantDescription = restaurantDescription
        self.websiteURL = websiteURL
        self.phoneNumber = phoneNumber
        self.hours = hours
        self.mondayHours = mondayHours
        self.tuesdayHours = tuesdayHours
        self.wednesdayHours = wednesdayHours
        self.thursdayHours = thursdayHours
        self.fridayHours = fridayHours
        self.saturdayHours = saturdayHours
        self.sundayHours = sundayHours
        
        self.address = address
        self.street = street
        self.city = city
        self.state = state
        self.zip = zip
        /*settings dictionary, with keys-- dietary(Dictionary Keys:glutenFree, halal, kosher, vegan, vegetarian Value: Bool), restaurantHeaderImageURL, restaurantThumbnailImageURL
        restaurantGenre(Dictionary Keys: american,bakery,chinese,fastFood,french,indian,italian,japanese,mexican,pizza,seafood,steak,thai Value: Bool)*/
       // self.settings = settings
        self.dietary = dietary
        self.glutenFree = glutenFree
        self.halal = halal
        self.kosher = kosher
        self.vegan = vegan
        self.vegetarian = vegetarian
        self.priceRange = priceRange
        self.restaurantGenre = restaurantGenre
        self.american = american
        self.bakery = bakery
        self.chinese = chinese
        self.fastFood = fastFood
        self.french = french
        self.indian = indian
        self.italian = italian
        self.japanese = japanese
        self.mexican = mexican
        self.pizza = pizza
        self.seafood = seafood
        self.steak = steak
        self.thai = thai
        
        
        self.restaurantHeaderImageURL = restaurantHeaderImageURL
        self.restaurantThumbnailImageURL = restaurantThumbnailImageURL
    }*/

}

extension Restaurant{
    init(){
        
    }
}
