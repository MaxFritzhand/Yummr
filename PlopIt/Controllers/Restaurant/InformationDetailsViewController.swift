//
//  InformationDetailsViewController.swift
//  PlopIt
//
//  Created by Max Fritzhand on 4/23/22.
//

import UIKit
import FirebaseAuth
import SwiftProtobuf
import FirebaseFirestore
import Firebase
import MessageUI


enum UserView {
    case customer
    case owner
}



class InformationDetailsViewController: PIViewController, MFMailComposeViewControllerDelegate {
    
    
    @IBOutlet weak var informationTableView: UITableView!
    @IBOutlet weak var restaurantDetails: UILabel!
    var restaurant: Restaurant
 //var owner: Owner
    //var user: User
    
    init(withRestaurant restaurant: Restaurant){
        self.restaurant = restaurant
        //self.owner = owner
        //self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    //cell.rowLabel = InfoDetailsTableViewCell.todayDay()
    var expandedIndexSet : IndexSet = []
    
     
    var label = ["Address", "Time", "Dietary"]
  
 

    override func viewDidLoad() {
        super.viewDidLoad()
        informationTableView.delegate = self
        informationTableView.dataSource = self
        restaurantDetails.text = restaurant.restaurantName
        setupTableView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         //getCurrentUserInfo()
    }
    
    func setupTableView() {
       informationTableView.register(UINib(nibName: "InfoDetailsTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        informationTableView.register(UINib(nibName: "AddressTableViewCell", bundle: nil), forCellReuseIdentifier: "address")
        informationTableView.isScrollEnabled = true;
        //dynamic expanding of cell
        informationTableView.rowHeight = UITableView.automaticDimension
        informationTableView.estimatedRowHeight = 280
    }
    

    
//    //get the restaurant info details
//    func getRestaurantInfo(){
//        let service = RestaurantService()
//        //service.getRestaurantsDetail(ownerID: <#T##String#>, completion: <#T##(Restaurant) -> Void#>)
//
//    }
    
    
    func getHeaderImage(){
        //fetch header
        
    }
    
    func getThumbnailImage() {
        //fetch thumbnail
    }
    
    func getPrice() -> String{
        //returns single price
        let cell = informationTableView.dequeueReusableCell(withIdentifier: "cell") as! InfoDetailsTableViewCell
        let priceVal = restaurant.priceRange
        cell.rowLabel.text! = priceVal!
        return cell.rowLabel.text!
    }
    
    func getGenre() -> String{
        let cell = informationTableView.dequeueReusableCell(withIdentifier: "cell") as! InfoDetailsTableViewCell
        var firstGenre = ""
        var secondGenre = ""
        var firstSwitch = false
        for (genre, check) in restaurant.restaurantGenre ?? [:] {
                if check == true {
                    if firstSwitch == false {
                        firstGenre = genre
                        firstSwitch = true
                    } else if firstSwitch == true {
                        secondGenre = genre
                        
                    }
                }
        }
        cell.rowLabel.text! = firstGenre + " " + secondGenre
        return cell.rowLabel.text!
    }
    
    func getWebsite() -> String{
        let cell = informationTableView.dequeueReusableCell(withIdentifier: "cell") as! InfoDetailsTableViewCell
        let websiteURL = restaurant.websiteURL
        cell.rowLabel.text! = websiteURL!
        return cell.rowLabel.text!
    }
    
    //Only returns one Value of String
    
    
    func getDietaryOptions() -> String{
        let cell = informationTableView.dequeueReusableCell(withIdentifier: "cell") as! InfoDetailsTableViewCell
        var firstDietary = ""
        var secondDietary = ""
        //var thirdDietary = ""
        var firstSwitch = false
        //let secondSwitch = false
        for (dietary, check) in restaurant.dietary ?? [:] {
                if check == true {
                    if firstSwitch == false {
                        firstDietary = dietary
                        firstSwitch = true
                    } else if firstSwitch  == true {
                        secondDietary = dietary
                    }
                }
        }
        cell.rowLabel.text! = firstDietary + " , " + secondDietary
        return cell.rowLabel.text!
    }
    
    
    
    /*
    func getDietaryOptions() -> String{
    
        let dietaryRestrictions = restaurant.dietary
        let isGlutenFree = restaurant.glutenFree
        let isHalal = restaurant.halal
        let isKosher = restaurant.kosher
        let isVegan = restaurant.vegan
        let isVegetarian = restaurant.vegetarian
        var dietaryOptions = ""
        
//        var GlutenFree = ""
//        var Halal = ""
//        var Kosher = ""
//        var Vegan = ""
//        var Vegetarian = ""
        
        if dietaryRestrictions!.contains(where: { $0.value == true}){
            let cell = informationTableView.dequeueReusableCell(withIdentifier: "cell") as! InfoDetailsTableViewCell
                if isGlutenFree!{
                    dietaryOptions = "Gluten Free"
                    cell.rowLabel.text! = dietaryOptions
                    return cell.rowLabel.text!
                }
                if isHalal!{
                    dietaryOptions = "Halal"
                    cell.rowLabel.text! = dietaryOptions
                    return cell.rowLabel.text!
                }
                if isKosher!{
                    dietaryOptions = "Kosher"
                    cell.rowLabel.text! = dietaryOptions
                    return cell.rowLabel.text!
                }
                if isVegan!{
                    dietaryOptions = "Vegan"
                    cell.rowLabel.text! = dietaryOptions
                    return cell.rowLabel.text!
                }
                if isVegetarian!{
                    dietaryOptions = "Vegetarian"
                    cell.rowLabel.text! = dietaryOptions
                    return cell.rowLabel.text!
                }
        return cell.rowLabel.text!
        } else{
            return dietaryOptions
        }
    }
    */
    func getAddress() -> String{
        let cell = informationTableView.dequeueReusableCell(withIdentifier: "cell") as! InfoDetailsTableViewCell
        let street = restaurant.street! + ", "
        let city = restaurant.city! + ", "
        let state = restaurant.state! + ", "
        let zip = restaurant.zip!
        var addressLabel = ""
        cell.rowLabel.text! = street + city + state + zip
        addressLabel = cell.rowLabel.text!
        return addressLabel

    }
    
    //function that gets today's date
    func todayDay() -> String{
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        let dayOfTheWeekString = dateFormatter.string(from: date)
        let Monday = "Monday: "
        let Tuesday = "Tuesday: "
        let Wednesday = "Wednesday: "
        let Thursday = "Thursday: "
        let Friday = "Friday: "
        let Saturday = "Saturday: "
        let Sunday = "Sunday: "
        
        let cell = informationTableView.dequeueReusableCell(withIdentifier: "cell") as! InfoDetailsTableViewCell
        var todayHours = ""
         //cell.rowLabel.text
        
        if dayOfTheWeekString == "Monday"{
            cell.rowLabel.text = restaurant.mondayHours
            todayHours = Monday + cell.rowLabel.text!
            return todayHours
        }
        if dayOfTheWeekString == "Tuesday"{
            cell.rowLabel.text = restaurant.tuesdayHours
            todayHours = Tuesday + cell.rowLabel.text!
            return todayHours
        }
        if dayOfTheWeekString == "Wednesday"{
            cell.rowLabel.text = restaurant.wednesdayHours
            todayHours = Wednesday + cell.rowLabel.text!
            return todayHours
        }
        if dayOfTheWeekString == "Thursday"{
            cell.rowLabel.text = restaurant.thursdayHours
            todayHours = Thursday + cell.rowLabel.text!
            return todayHours
        }
        if dayOfTheWeekString == "Friday"{
            cell.rowLabel.text = restaurant.thursdayHours
            todayHours = Friday + cell.rowLabel.text!
            return todayHours
        }
        if dayOfTheWeekString == "Saturday"{
            cell.rowLabel.text = restaurant.saturdayHours
            todayHours = Saturday + cell.rowLabel.text!
            return todayHours
        }
        if dayOfTheWeekString == "Sunday"{
            cell.rowLabel.text = restaurant.sundayHours
            todayHours = Sunday + cell.rowLabel.text!
            return todayHours
        } else{
            cell.rowLabel.text = "Closed"
        }
        return cell.rowLabel.text!
    }
    
    
    //var phoneNum = restaurant.phone
    //call phone number
    func phone(phoneNum: String) {
        if let url = URL(string: "tel://\(phoneNum)") {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url as URL)
            }
        }
    }
    
    @IBAction func callBusiness(_ sender: Any) {
        phone(phoneNum: restaurant.phoneNumber!)
    }
    
    
    @IBAction func sendEmail(_ sender: UIButton) {
         
        
        //DYNAMIC
        //let recipientEmail = owner.email
        let recipientEmail = "support@yummr.io"
        let subject = "Yummr Review for " + restaurant.restaurantName!
        let body = "Hello Team " + restaurant.restaurantName! + ","
        
        // Show default mail composer
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([recipientEmail])
            mail.setSubject(subject)
            mail.setMessageBody(body, isHTML: false)
            
            present(mail, animated: true)
        
        // Show third party email composer if default Mail app is not present
        } else if let emailUrl = createEmailUrl(to: recipientEmail, subject: subject, body: body) {
            UIApplication.shared.open(emailUrl)
        }
    }
    
    private func createEmailUrl(to: String, subject: String, body: String) -> URL? {
        let subjectEncoded = subject.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let bodyEncoded = body.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        let gmailUrl = URL(string: "googlegmail://co?to=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
        let outlookUrl = URL(string: "ms-outlook://compose?to=\(to)&subject=\(subjectEncoded)")
        let yahooMail = URL(string: "ymail://mail/compose?to=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
        let sparkUrl = URL(string: "readdle-spark://compose?recipient=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
        let defaultUrl = URL(string: "mailto:\(to)?subject=\(subjectEncoded)&body=\(bodyEncoded)")
        
        if let gmailUrl = gmailUrl, UIApplication.shared.canOpenURL(gmailUrl) {
            return gmailUrl
        } else if let outlookUrl = outlookUrl, UIApplication.shared.canOpenURL(outlookUrl) {
            return outlookUrl
        } else if let yahooMail = yahooMail, UIApplication.shared.canOpenURL(yahooMail) {
            return yahooMail
        } else if let sparkUrl = sparkUrl, UIApplication.shared.canOpenURL(sparkUrl) {
            return sparkUrl
        }
        
        return defaultUrl
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    
    
      //<---DATA-STRUCTURE-2.0--FOR-TIME------DO-NOT-DELETE--->
    
//    function that see's they are same times. If they are same time, it will hide the appropriate time view and show time view. Cases: A.) BUSINESS with 24/7, B.) Business with same set time per day/per week. C.) Business open from X to X for specific days. (ie. Monday-Wednesday it is open from 9AM to 4PM. D.) Time slots showing Open/Closed time for Breakfast/Lunch/Dinner hours
//    func isSameTime() -> Bool{
//        let date = Date()
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "EEEE"
//        let dayOfTheWeekString = dateFormatter.string(from: date)
//        let Monday = "Monday: "
//        let Tuesday = "Tuesday: "
//        let Wednesday = "Wednesday: "
//        let Thursday = "Thursday: "
//        let Friday = "Friday: "
//        let Saturday = "Saturday: "
//        let Sunday = "Sunday: "
//
//        let cell = informationTableView.dequeueReusableCell(withIdentifier: "cell") as! InfoDetailsTableViewCell
//
//        if restaurant.mondayHours && restaurant.tuesdayHours && restaurant.wednesdayHours && restaurant.thursdayHours && restaurant.fridayHours && restaurant.saturdayHours && restaurant.sundayHours  == true{
//        }
//    }
}

extension InformationDetailsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        informationTableView.deselectRow(at: indexPath, animated: true)
        
        //let cell = informationTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! InfoDetailsTableViewCell
     
        if(expandedIndexSet.contains(indexPath.row)){
            expandedIndexSet.remove(indexPath.row)
           // cell.rightLabel.isHidden = true
        } else {
            expandedIndexSet.insert(indexPath.row)
            //cell.rightLabel.isHidden = true
        }

        informationTableView.reloadRows(at: [indexPath], with: .automatic)
    }
}
//on select for row, make rightLabel view visible

extension InformationDetailsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return DetailRows.restaurantInformationRows.count
    
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = informationTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? InfoDetailsTableViewCell
        else{
            print("failed to get cell")
            return UITableViewCell()
        }
        cell.update(data: DetailRows.restaurantInformationRows[indexPath.row])
        
        
        cell.mondayView.isHidden = true
        cell.tuesdayView.isHidden = true
        cell.wednesdayView.isHidden = true
        cell.thursdayView.isHidden = true
        cell.fridayView.isHidden = true
        cell.saturdayView.isHidden = true
        cell.sundayView.isHidden = true
        
        
    
        let dynamicLabel = [
            getAddress(),
            todayDay(),
            getDietaryOptions(),
            getGenre(),
            getWebsite()
        ]
    
            
        
        //cell.detailImage.image = UIImage(named: avatars[indexPath.row])
        //cell.detailLabel.text = label[indexPath.row]
       // cell.rightLabel.text = rightLabel[indexPath.row]
    
        
        cell.rowLabel.text! = dynamicLabel[indexPath.row]
    
       
    
        
        cell.selectionStyle = .none
        
        if indexPath.row == 1{
            if expandedIndexSet.contains(indexPath.row) {
                //cell.detailLabel.numberOfLines = 0
                //cell.rightLabel.numberOfLines = 0
                
                cell.mondayHours.text = restaurant.mondayHours
                cell.tuesdayHours.text = restaurant.tuesdayHours
                cell.wednesdayHours.text = restaurant.wednesdayHours
                cell.thursdayHours.text = restaurant.thursdayHours
                cell.fridayHours.text = restaurant.fridayHours
                cell.saturdayHours.text = restaurant.saturdayHours
                cell.sundayHours.text = restaurant.sundayHours
        
                
                
                cell.mondayView.isHidden = false
                cell.tuesdayView.isHidden = false
                cell.wednesdayView.isHidden = false
                cell.thursdayView.isHidden = false
                cell.fridayView.isHidden = false
                cell.saturdayView.isHidden = false
                cell.sundayView.isHidden = false
               
            } else {
                //cell.detailLabel.numberOfLines = 3
                //cell.rightLabel.numberOfLines = 3
                
                
                cell.mondayHours.text = restaurant.mondayHours
                cell.tuesdayHours.text = restaurant.tuesdayHours
                cell.wednesdayHours.text = restaurant.wednesdayHours
                cell.thursdayHours.text = restaurant.thursdayHours
                cell.fridayHours.text = restaurant.fridayHours
                cell.saturdayHours.text = restaurant.saturdayHours
                cell.sundayHours.text = restaurant.sundayHours
        
                cell.mondayView.isHidden = true
                cell.tuesdayView.isHidden = true
                cell.wednesdayView.isHidden = true
                cell.thursdayView.isHidden = true
                cell.fridayView.isHidden = true
                cell.saturdayView.isHidden = true
                cell.sundayView.isHidden = true
        
            }
        } else{
            
            
        }
            
        return cell
    }
}
    
