//
//  SignUpInformationRestaurantViewController.swift
//  PlopIt
//
//  Created by Max Fritzhand on 4/13/22.
//

import UIKit
import Foundation
import BetterSegmentedControl


enum RestaurantState {
    case new
    case edit
}

enum PhotoSelectionType {
    case frontPage
    case header
}

class SignUpInformationRestaurantViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    //restaurant information
    @IBOutlet weak var restaurantView: ImageTextFieldView!
    @IBOutlet weak var addressStreetView: ImageTextFieldView!
    @IBOutlet weak var addressCityView: ImageTextFieldView!
    @IBOutlet weak var addressStateView: ImageTextFieldView!
    @IBOutlet weak var addressZipView: ImageTextFieldView!
    @IBOutlet weak var descriptionView: ImageTextFieldView!
    @IBOutlet weak var phoneNumberView: ImageTextFieldView!
    @IBOutlet weak var priceView: UISegmentedControl!
    @IBOutlet weak var restaurantSignupLabel: UILabel!
    @IBOutlet weak var restaurantLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    
    
    
    
    
    
    @IBOutlet weak var menuHeaderView: UIStackView!
    @IBOutlet weak var menuHeader: UITableView!
    @IBOutlet weak var addHeader: UIButton!
    @IBOutlet weak var editButton: UIButton!
    
    
    
    //@IBOutlet weak var pricingView: ImageTextFieldView!
    
    @IBOutlet weak var websiteView: ImageTextFieldView!
    @IBOutlet weak var genreView: ImageTextFieldView!
    @IBOutlet weak var dietaryView: ImageTextFieldView!
    @IBOutlet weak var frontPageHeaderView: UIView!
    @IBOutlet weak var uploadFrontPageHeaderButton: UIButton!
    @IBOutlet weak var frontPageAddedImageView: UIImageView!
    
    @IBOutlet weak var menuHeaderAddedImageView: UIImageView!
    @IBOutlet weak var uploadMenuButton: UIButton!
    
    @IBOutlet weak var hoursOpenMonday: UIDatePicker!
    @IBOutlet weak var hoursOpenTuesday: UIDatePicker!
    @IBOutlet weak var hoursOpenWednesday: UIDatePicker!
    @IBOutlet weak var hoursOpenThursday: UIDatePicker!
    @IBOutlet weak var hoursOpenFriday: UIDatePicker!
    @IBOutlet weak var hoursOpenSaturday: UIDatePicker!
    @IBOutlet weak var hoursOpenSunday: UIDatePicker!
    @IBOutlet weak var hoursClosedMonday: UIDatePicker!
    @IBOutlet weak var hoursClosedTuesday: UIDatePicker!
    @IBOutlet weak var hoursClosedWednesday: UIDatePicker!
    @IBOutlet weak var hoursClosedThursday: UIDatePicker!
    @IBOutlet weak var hoursClosedFriday: UIDatePicker!
    @IBOutlet weak var hoursClosedSaturday: UIDatePicker!
    @IBOutlet weak var hoursClosedSunday: UIDatePicker!
    @IBOutlet weak var hoursToggle: UISwitch!
    @IBOutlet weak var hoursView: UIStackView!
    @IBOutlet weak var mondayView: UIStackView!
    @IBOutlet weak var tuesdayView: UIStackView!
    @IBOutlet weak var wednesdayView: UIStackView!
    @IBOutlet weak var thursdayView: UIStackView!
    @IBOutlet weak var fridayView: UIStackView!
    @IBOutlet weak var saturdayView: UIStackView!
    @IBOutlet weak var sundayView: UIStackView!
    @IBOutlet weak var mondayToggle: UISwitch!
    @IBOutlet weak var tuesdayToggle: UISwitch!
    @IBOutlet weak var wednesdayToggle: UISwitch!
    @IBOutlet weak var thursdayToggle: UISwitch!
    @IBOutlet weak var fridayToggle: UISwitch!
    @IBOutlet weak var saturdayToggle: UISwitch!
    @IBOutlet weak var sundayToggle: UISwitch!
    @IBOutlet weak var signUpButton: LoadingButton!
    
    var pictureSelectionType = PhotoSelectionType.frontPage
    
    var frontPageURL: Data = Data()
    var menuHeaderURL: Data = Data()
    var genrePickerDictData: [String: Bool] = [:]
    var dietaryPickerDictData: [String: Bool] = [:]
    
    //0, 1, 2 correspond to $, $$, $$$
     ///0 is .new, menuitem.price is .edit restaurant.priceRange
    var dollar = ""
    
    //var dollar = 0
    //var dollar = restaurantState == .new ? 0 : 2
    
    //testing data
    var menuHeaderLabel = [
    "Breakfast",
    "Lunch",
    "Dinner",
    "Dessert"
    ]
    
    //Firebase menu header data
    var menuHeaderData: [String] = [String]()
   
    
    

    var fullName: String
    var email: String
    var password: String
    var confirmPassword: String
    var restaurant: Restaurant
    var restaurantState: RestaurantState = .new
    
    init(fullName: String, email: String, password: String, confirmPassword: String, restaurantState: RestaurantState, withRestaurantData restaurantData: Restaurant){
        self.fullName = fullName
        self.email = email
        self.password = password
        self.confirmPassword = confirmPassword
        self.restaurant = restaurantData
        self.restaurantState = restaurantState
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
  
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        API.shared.userManager.addConsumer(consumer: self)
        
        DispatchQueue.main.async {
            self.setupView()
        }
        setupPickers()
        updateLoginButtonIfNeeded()
        // Do any additional setup after loading the view.
        
    }
    var cost = 0
    func setupView() {
        
        signUpButton.addCornerRadius(value: 25)
        self.signUpButton.updateToEnabled()
        
        let nib = UINib(nibName: "MenuHeaderTableViewCell", bundle: nil)
        menuHeader.register(nib, forCellReuseIdentifier: "MenuHeaderTableViewCell")
        menuHeader.delegate = self
        menuHeader.dataSource = self
        menuHeaderData = restaurant.menuHeaderArray!
        
        
        
        if restaurantState == .new{
            navigationController?.navigationBar.isHidden = true
            signUpButton.setup(withTapHandler: {
                self.attemptSignup()
            }, withTitle: "Sign Up")
            priceView.selectedSegmentIndex = 1
            
          menuHeaderView.isHidden = true
       
            
        } else {
            signUpButton.setup(withTapHandler: {
                self.updateRestaurantInfo()
            }, withTitle: "Update Changes")
            restaurantLabel.text = "Restaurant Details"
            restaurantSignupLabel.text = "Edit restaurant information below"
            convertStringtoDate()
            backButton.isHidden = true
            //get the appropriate scale slide
            priceSlider(restaurant.priceRange!)
            //dollar = restaurant.priceRange!
            //priceView.selectedSegmentIndex = cost
            print(cost)
            menuHeaderView.isHidden = false
           

        }
        

        self.frontPageAddedImageView.alpha = 1
        frontPageAddedImageView.addCornerRadius(value: 10)
        frontPageHeaderView.addCornerRadius(value: 10)
        frontPageHeaderView.addBorder(withColor: Colours.lightGreyBorder, width: 1)
        self.menuHeaderAddedImageView.alpha = 1
        menuHeaderAddedImageView.addCornerRadius(value: 10)
        menuHeaderAddedImageView.addCornerRadius(value: 10)
        menuHeaderAddedImageView.addBorder(withColor: Colours.lightGreyBorder, width: 1)
        
        uploadFrontPageHeaderButton.setTitle("", for: .normal)
        uploadMenuButton.setTitle("", for: .normal)
        
        //the logic on this may be able to be performed better via, condense the duplicated function down to one..
        if restaurantState == .edit && (restaurant.restaurantHeaderImageURL != nil) || restaurant.restaurantThumbnailImageURL != nil {
            API.shared.firebaseStorageManager.pullImageFromDatabase(fromURL: restaurant.restaurantHeaderImageURL!) { image in
                if image != nil {
                    self.menuHeaderAddedImageView.image = image
                    
                }
            }
            API.shared.firebaseStorageManager.pullImageFromDatabase(fromURL: restaurant.restaurantThumbnailImageURL!) { image in
                if image != nil {
                    self.frontPageAddedImageView.image = image
                    
                }
            }
        }
        
        restaurantView.textField.addTarget(self, action: #selector(SignUpInformationRestaurantViewController.textFieldDidChange(_:)), for: .editingChanged)
        addressStreetView.textField.addTarget(self, action: #selector(SignUpInformationRestaurantViewController.textFieldDidChange(_:)), for: .editingChanged)
        addressCityView.textField.addTarget(self, action: #selector(SignUpInformationRestaurantViewController.textFieldDidChange(_:)), for: .editingChanged)
        addressStateView.textField.addTarget(self, action: #selector(SignUpInformationRestaurantViewController.textFieldDidChange(_:)), for: .editingChanged)
        addressZipView.textField.addTarget(self, action: #selector(SignUpInformationRestaurantViewController.textFieldDidChange(_:)), for: .editingChanged)
        descriptionView.textField.addTarget(self, action: #selector(SignUpInformationRestaurantViewController.textFieldDidChange(_:)), for: .editingChanged)
        phoneNumberView.textField.addTarget(self, action: #selector(SignUpInformationRestaurantViewController.textFieldDidChange(_:)), for: .editingChanged)
        
  
       
        //add CustomDropClass -->look at editItemdetail
        /*
         foodTypeView.setup(text: menuItems.menuHeaderType ?? "", cornerRadius: 10, optionArray: ["Food", "Dessert"], optionIds: [1,2])
         */
        restaurantView.setup(text: (restaurantState == .new ? "" : restaurant.restaurantName) ?? "", type: .restaurant, isSeperatorHidden: 0, textFieldBackgroundColour: .clear, textColour: .black, showBorder: false, isEditable: true) { (restaurantView) in
            if restaurantView != "" {
                self.updateLoginButtonIfNeeded()
            }
        }
        //change address field types in restaurant.swift
        addressStreetView.setup(text: (restaurantState == .new ? "" : restaurant.street) ?? "", type: .street, isSeperatorHidden: 0, textFieldBackgroundColour: .clear, textColour: .black, showBorder: false, isEditable: true) { (addressStreetView) in
            if addressStreetView != "" {
                self.updateLoginButtonIfNeeded()
            }
        }
        
        addressCityView.setup(text: (restaurantState == .new ? "" : restaurant.city) ?? "", type: .city, isSeperatorHidden: 0, textFieldBackgroundColour: .clear, textColour: .black, showBorder: false, isEditable: true) { (addressCityView) in
            if addressCityView != "" {
                self.updateLoginButtonIfNeeded()
            }
        }
        
        addressStateView.setup(text: (restaurantState == .new ? "" : restaurant.state) ?? "", type: .state, isSeperatorHidden: 0, textFieldBackgroundColour: .clear, textColour: .black, showBorder: false, isEditable: true) { (addressStateView) in
            if addressStateView != "" {
                self.updateLoginButtonIfNeeded()
            }
        }
        addressZipView.setup(text: (restaurantState == .new ? "" : restaurant.zip) ?? "", type: .zip, isSeperatorHidden: 0, textFieldBackgroundColour: .clear, textColour: .black, showBorder: false, isEditable: true) { (addressStateView) in
            if addressStateView != "" {
                self.updateLoginButtonIfNeeded()
            }
        }
        
        descriptionView.setup(text: (restaurantState == .new ? "" : restaurant.restaurantDescription) ?? "", type: .description, isSeperatorHidden: 0, textFieldBackgroundColour: .clear, textColour: .black, showBorder: false, isEditable: true) { (descriptionView) in
            if descriptionView != "" {
                self.updateLoginButtonIfNeeded()
            }
        }
        phoneNumberView.setup(text: (restaurantState == .new ? "" : restaurant.phoneNumber) ?? "", type: .businessMobile, isSeperatorHidden: 0, textFieldBackgroundColour: .clear, textColour: .black, showBorder: false, isEditable: true) { (phoneNumberView) in
            if phoneNumberView != "" {
                self.updateLoginButtonIfNeeded()
            }
        }
        // pricingView.setIndex(0)
       
/*
        pricingView.setup(text: (restaurantState == .new ? "" : restaurant.priceRange) ?? "", type: .isExpensive, isSeperatorHidden: 0, textFieldBackgroundColour: .clear, textColour: .black, showBorder: false, isEditable: true) { (pricingView) in
            if pricingView != "" {
                self.updateLoginButtonIfNeeded()
            }
        }
 */
        websiteView.setup(text: (restaurantState == .new ? "" : restaurant.websiteURL) ?? "", type: .websiteURL, isSeperatorHidden: 0, textFieldBackgroundColour: .clear, textColour: .black, showBorder: false, isEditable: true) { (websiteView) in
            if websiteView != "" {
                self.updateLoginButtonIfNeeded()
            }
        }
        //change to dictionary
        genreView.setup(text: (restaurantState == .new ? "" : getGenre()) , type: .genre, isSeperatorHidden: 0, textFieldBackgroundColour: .clear, textColour: .black, showBorder: false, isEditable: true) { (genreView) in
            if genreView != "" {
                self.updateLoginButtonIfNeeded()
            }
        }
        dietaryView.setup(text: (restaurantState == .new ? "" : getDietaryOptions()) , type: .dietary, isSeperatorHidden: 0, textFieldBackgroundColour: .clear, textColour: .black, showBorder: false, isEditable: true) { (dietaryView) in
            if dietaryView != "" {
                self.updateLoginButtonIfNeeded()
            }
        }
        
    }
    func priceSlider (_ text: String){
        switch text {
              case "$":
                  cost = 0
                priceView.selectedSegmentIndex = 0
              case "$$":
                  cost = 1
            priceView.selectedSegmentIndex = 1
              case "$$$":
                  cost = 2
            priceView.selectedSegmentIndex = 2
              default:
                  cost = 1
            priceView.selectedSegmentIndex = 1
              }

    }
    
    @IBAction func pricingSwitcher(_ sender: UISegmentedControl) {
        
        if sender.selectedSegmentIndex == 0{
            dollar = "$"
            priceSlider(dollar)
        }
        else if sender.selectedSegmentIndex == 1{
            dollar = "$$"
            priceSlider(dollar)
        }
        else if sender.selectedSegmentIndex == 2{
            dollar = "$$$"
            priceSlider(dollar)
        }
    }
    //
//    @objc func navigationSegmentedControlValueChanged(_ sender: UISegmentedControl) {
//        if sender.index == dollar {
//            buttonDisabled()
//        } else {
//            buttonEnabled()
//        }
//    }
//
//    func buttonEnabled() {
//        saveChanges.isUserInteractionEnabled = true
//        saveChanges.alpha = 1
//    }
//    func buttonDisabled() {
//        saveChanges.isUserInteractionEnabled = false
//        saveChanges.alpha = 0.3
//    }

    
    // needs multi selection
    func getGenre() -> String{
        
        //genreView
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
         
        return firstGenre
    }
    
    
    func getDietaryOptions() -> String{
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
        return firstDietary
    }
    
    
    
    
    func setupPickers() {
        let genrePickerView = UIPickerView()
        genreView.textField.inputView = genrePickerView
        genrePickerView.delegate = self
        genrePickerView.dataSource = self
        
        let dietaryPickerView = UIPickerView()
        dietaryView.textField.inputView = dietaryPickerView
        dietaryPickerView.delegate = self
        dietaryPickerView.dataSource = self
        
        // setupPickerViewTap()
        genrePickerDictData = [
            "Japanese" : false,
            "American" : false,
            "Bakery" : false,
            "Chinese" : false,
            "Fast Food" : false,
            "French" : false,
            "Indian" : false,
            "Italian" : false,
            "Mexican" : false,
            "Pizza" : false,
            "Seafood" : false,
            "Steak" : false,
            "Thai" : false,
        ]
        dietaryPickerDictData = [
            "Gluten Free" : false,
            "Halal" : false,
            "Kosher" : false,
            "Vegan" : false,
            "Vegetarian" : false,
        ]
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        self.updateLoginButtonIfNeeded()
    }
    
    //show only for .EDIT mode
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        guard let frontPageImage = info[.editedImage] as? UIImage else {
            print("No front page image found")
            return
        }
        guard let menuHeaderImage = info[.editedImage] as? UIImage else {
            print("No menu header image image found")
            return
        }
        if pictureSelectionType == .frontPage {
            frontPageAddedImageView.image = frontPageImage
            frontPageAddedImageView.addBorder(withColor: .clear)
        }
        
        if pictureSelectionType == .header {
            menuHeaderAddedImageView.image = menuHeaderImage
            menuHeaderAddedImageView.addBorder(withColor: .clear)
        }
        
        
        if let data = frontPageImage.pngData() {
            frontPageURL = data
        }
        if let data = menuHeaderImage.pngData() {
            menuHeaderURL = data
        }
    }

    
    @IBAction func hideHours(_ sender: Any) {
        if hoursToggle.isOn == false{
            hoursView.isHidden = true
            
        } else{
            hoursView.isHidden = false
        }
 
    }
    
    
  
    @IBAction func operationClosed(_ sender: UISwitch) {
        if mondayToggle.isOn == true{
            mondayView.isHidden = true
        } else {
            mondayView.isHidden = false
        }
        if tuesdayToggle.isOn == true{
            tuesdayView.isHidden = true
        } else{
            tuesdayView.isHidden = false
        }
        if wednesdayToggle.isOn == true{
          wednesdayView.isHidden = true
        } else{
            wednesdayView.isHidden = false
        }
        if thursdayToggle.isOn == true{
           thursdayView.isHidden = true
        }  else{
            thursdayView.isHidden = false
        }
        if fridayToggle.isOn == true{
           fridayView.isHidden = true
        } else{
            fridayView.isHidden = false
        }
        if saturdayToggle.isOn == true{
            saturdayView.isHidden = true
        } else {
            saturdayView.isHidden = false
        }
        if sundayToggle.isOn == true{
            sundayView.isHidden = true
        } else {
            sundayView.isHidden = false
        }
    }
    
    
    
     
    //.new
    func convertDatetoString() -> [String] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.none
        dateFormatter.timeStyle = DateFormatter.Style.short
        var monday = ""
        var tuesday = ""
        var wednesday = ""
        var thursday = ""
        var friday = ""
        var saturday = ""
        var sunday = ""
        
        if mondayToggle.isOn == false {
            monday = dateFormatter.string(from: hoursOpenMonday.date) + " - " + dateFormatter.string(from: hoursClosedMonday.date)
        } else {
            monday = "closed"
        }
        
        if tuesdayToggle.isOn == false {
            tuesday = dateFormatter.string(from: hoursOpenTuesday.date) + " - " + dateFormatter.string(from: hoursClosedTuesday.date)
        } else {
            tuesday = "closed"
        }
        
        if wednesdayToggle.isOn == false {
            wednesday = dateFormatter.string(from: hoursOpenWednesday.date) + " - " + dateFormatter.string(from: hoursClosedWednesday.date)
        } else {
            wednesday = "closed"
        }
        
        if thursdayToggle.isOn == false {
            thursday = dateFormatter.string(from: hoursOpenThursday.date) + " - " + dateFormatter.string(from: hoursClosedThursday.date)
        } else {
            thursday = "closed"
        }
        
        if fridayToggle.isOn == false {
            friday = dateFormatter.string(from: hoursOpenFriday.date) + " - " + dateFormatter.string(from: hoursClosedFriday.date)
        } else {
            friday = "closed"
        }
        
        if saturdayToggle.isOn == false {
            saturday = dateFormatter.string(from: hoursOpenSaturday.date) + " - " + dateFormatter.string(from: hoursClosedSaturday.date)
        } else {
            saturday = "closed"
        }
        if sundayToggle.isOn == false {
            sunday = dateFormatter.string(from: hoursOpenSunday.date) + " - " + dateFormatter.string(from: hoursClosedSunday.date)
        } else {
            sunday = "closed"
        }
        
        let hourArray = [monday,tuesday,wednesday,thursday,friday,saturday,sunday]
            return hourArray
  
        }
  
    //.edit
    func convertStringtoDate(){
        
        //let str = "6:00 AM - 10:00 PM"

        //create the string
        let strDay = [restaurant.mondayHours!,
                      restaurant.tuesdayHours!,
                      restaurant.wednesdayHours!,
                      restaurant.thursdayHours!,
                      restaurant.fridayHours!,
                      restaurant.saturdayHours!,
                      restaurant.sundayHours!
                    ]
        
        let strSplitterMon = strDay[0].components(separatedBy: " - ")
        let strSplitterTues = strDay[1].components(separatedBy: " - ")
        let strSplitterWed = strDay[2].components(separatedBy: " - ")
        let strSplitterThur = strDay[3].components(separatedBy: " - ")
        let strSplitterFri = strDay[4].components(separatedBy: " - ")
        let strSplitterSat = strDay[5].components(separatedBy: " - ")
        let strSplitterSun = strDay[6].components(separatedBy: " - ")
        
        let openMonday = strSplitterMon[0]
        let closedMonday = strSplitterMon[1]
        
        let openTuesday = strSplitterTues[0]
        let closedTuesday=strSplitterTues[1]
        
        let openWednesday=strSplitterWed[0]
        let closedWednesday=strSplitterWed[1]
        
        let openThur=strSplitterThur[0]
        let closedThur=strSplitterThur[1]
        
        let openFri=strSplitterFri[0]
        let closedFri=strSplitterFri[1]
        
        let openSat=strSplitterSat[0]
        let closedSat=strSplitterSat[1]
        
        let openSun=strSplitterSun[0]
        let closedSun=strSplitterSun[1]
        
        
        //create Date Formatter
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        
        
        //convert String to Date
        dateFormatter.date(from: openMonday)
       
        
        if mondayToggle.isOn == false {
           
            hoursOpenMonday.date = dateFormatter.date(from: openMonday)!
            hoursClosedMonday.date = dateFormatter.date(from: closedMonday)!
        } else {
            //they are closed monday
            hoursOpenMonday.date = dateFormatter.date(from: "8:00 AM")!
            hoursClosedMonday.date = dateFormatter.date(from: "5:00 PM")!
        }
        
        if tuesdayToggle.isOn == false {
            hoursOpenTuesday.date = dateFormatter.date(from: openTuesday)!
            hoursClosedTuesday.date = dateFormatter.date(from: closedTuesday)!
        } else {
            hoursOpenTuesday.date = dateFormatter.date(from: "8:00 AM")!
            hoursClosedTuesday.date = dateFormatter.date(from: "5:00 PM")!
        }
        
        if wednesdayToggle.isOn == false {
            hoursOpenWednesday.date = dateFormatter.date(from: openWednesday)!
            hoursClosedWednesday.date = dateFormatter.date(from: closedWednesday)!
        } else {
            hoursOpenWednesday.date = dateFormatter.date(from: "8:00 AM")!
            hoursClosedWednesday.date = dateFormatter.date(from: "5:00 PM")!
        }
        
        if thursdayToggle.isOn == false {
            hoursOpenThursday.date = dateFormatter.date(from: openThur)!
            hoursClosedThursday.date = dateFormatter.date(from: closedThur)!
        } else {
            hoursOpenWednesday.date = dateFormatter.date(from: "8:00 AM")!
            hoursClosedWednesday.date = dateFormatter.date(from: "5:00 PM")!
        }
        
        if fridayToggle.isOn == false {
            hoursOpenFriday.date = dateFormatter.date(from: openFri)!
            hoursClosedFriday.date = dateFormatter.date(from: closedFri)!
        } else {
            hoursOpenFriday.date = dateFormatter.date(from: "8:00 AM")!
            hoursClosedFriday.date = dateFormatter.date(from: "5:00 PM")!
        }
        
        if saturdayToggle.isOn == false {
            hoursOpenSaturday.date = dateFormatter.date(from: openSat)!
            hoursClosedSaturday.date = dateFormatter.date(from: closedSat)!
        } else {
            hoursOpenSaturday.date = dateFormatter.date(from: "8:00 AM")!
            hoursClosedSaturday.date = dateFormatter.date(from: "5:00 PM")!
        }
        if sundayToggle.isOn == false {
            hoursOpenSunday.date = dateFormatter.date(from: openSun)!
            hoursClosedSunday.date = dateFormatter.date(from: closedSun)!
        } else {
            hoursOpenSunday.date = dateFormatter.date(from: openSun)!
            hoursClosedSunday.date = dateFormatter.date(from: closedSun)!
        }
        
  
        }
  


    func hasCompletedAll() -> Bool {
        
         return restaurantView.text() != "" && addressStreetView.text() != "" && addressCityView.text() != "" &&  addressStateView.text() != "" &&
         addressZipView.text() != "" &&
         descriptionView.text() != "" && phoneNumberView.text() != ""
         
    }

 
    
    //updating the restaurant
    func updateRestaurantInfo(){
        
        if self.hasCompletedAll() {

            API.shared.restaurantManager.updateRestaurantInfo(restaurantID: self.restaurant.restaurantID!, restaurantName: self.restaurantView.text(), addressStreet: self.addressStreetView.text(), addressCity: self.addressCityView.text(), addressState: self.addressStateView.text(), addressZip: self.addressZipView.text(), restaurantDescription: self.descriptionView.text(), phoneNumber: self.phoneNumberView.text(), priceRange: self.dollar, websiteURL: self.websiteView.text(), hourArray: convertDatetoString(), dietaryDict: self.dietaryPickerDictData, genreDict: self.genrePickerDictData, restaurantHeaderImageURL: self.restaurant.restaurantHeaderImageURL!, restaurantThumbnailImageURL: self.restaurant.restaurantThumbnailImageURL!)
 
        } else {
            self.signUpButton.stopLoading()
        }
        self.updateLoginButtonIfNeeded()
    }
    //sign up as owner
    func attemptSignup() {
        if self.hasCompletedAll() {
            //API.shared.firebaseStorageManager.uploadImageData(data: frontPageURL, serverFileName: UUID().uuidString, restaurantName: restaurant.restaurantID!){ isSuccess, url in
                //if isSuccess{
                //    print("wawa WEEE WAH. Big Success! My name Borat!")
              //  }
            //} //wont have restaurant ID yet
            //API.shared.firebaseStorageManager.uploadImageData(data: menuHeaderURL, serverFileName: UUID().uuidString, restaurantName: restaurant.restaurantID!) { isSuccess, url in
              //  if isSuccess {
                    if self.restaurantState == .new {
                        API.shared.userManager.createAccount(isOwner: true, email: self.email, password: self.password, confirmPassword: self.confirmPassword, fullName: self.fullName, restaurantName: self.restaurantView.text(), addressStreet: self.addressStreetView.text(), addressCity: self.addressCityView.text(), addressState: self.addressStateView.text(), addressZip: self.addressZipView.text(), restaurantDescription: self.descriptionView.text(), phoneNumber: self.phoneNumberView.text(), priceRange: self.dollar, websiteURL: self.websiteView.text(), hourArray: self.convertDatetoString(), dietaryDict: self.dietaryPickerDictData, genreDict: self.genrePickerDictData, restaurantHeaderImageURL: "", restaurantThumbnailImageURL: "")
                    } else {
                        self.updateRestaurantInfo()
                    }
               // }
            //}
        }else {
            self.signUpButton.stopLoading()
        }
        self.updateLoginButtonIfNeeded()
    }
    
    func updateLoginButtonIfNeeded() {
        if self.hasCompletedAll() {
            self.signUpButton.updateToEnabled()
            
            
        } else {
            self.signUpButton.updateToDisabled()
            
            
        }
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Number of columns of data
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        var countrows : Int = genrePickerDictData.count
        if pickerView == dietaryView.textField.inputView{
            countrows = self.dietaryPickerDictData.count
        }
        return countrows
        //dietaryPickerData.count
        
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        var genreArray = [String]()
        var dietaryArray = [String]()
        
        for key in genrePickerDictData.keys {
            genreArray.append(key)
        }
                
        for key in dietaryPickerDictData.keys {
            dietaryArray.append(key)
        }
        
        if pickerView == genreView.textField.inputView{
            return genreArray[row]
            
        } else if pickerView == dietaryView.textField.inputView{
            return dietaryArray[row]
        }
        return ""
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        var genreArray = [String]()
        var dietaryArray = [String]()
        
        for key in genrePickerDictData.keys {
            genreArray.append(key)
        }
                
        for key in dietaryPickerDictData.keys {
            dietaryArray.append(key)
        }
       // self.selectedMenuHeaderIndex = row
        if pickerView == genreView.textField.inputView{
            genreView.textField.text = genreArray[row]
            genreView.showTitle()
            self.genrePickerDictData[genreView.text()] = true
        
        
            
        } else if pickerView == dietaryView.textField.inputView{
            dietaryView.textField.text = dietaryArray[row]
            dietaryView.showTitle()
            self.dietaryPickerDictData[dietaryView.text()] = true
        }
    }
    
    
   
    @IBAction func restaurantThumbnailImageTapped(_ sender: Any) {
        pictureSelectionType = .frontPage
    let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.allowsEditing = true
        vc.delegate = self
        present(vc, animated: true)
    }
    
    @IBAction func restaurantHeaderImageTapped(_ sender: Any) {
        pictureSelectionType = .header
    let bc = UIImagePickerController()
        bc.sourceType = .photoLibrary
        bc.allowsEditing = true
        bc.delegate = self
        present(bc, animated: true)
    }
    

}


extension SignUpInformationRestaurantViewController: UITableViewDelegate, UITableViewDataSource{
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return menuHeaderData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let menuHeaderCell = menuHeader.dequeueReusableCell(withIdentifier: "MenuHeaderTableViewCell", for: indexPath) as! MenuHeaderTableViewCell
        menuHeaderCell.menuLabel.text = menuHeaderData[indexPath.row]
        menuHeaderCell.selectionStyle = .none
        
        return menuHeaderCell
        
    }
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
       // menuHeaderData.swapAt(sourceIndexPath.row, destinationIndexPath.row)
        
        let movedObjTemp = menuHeaderData[sourceIndexPath.item]
        menuHeaderData.remove(at: sourceIndexPath.item)
        //API.shared.restaurantManager.restaurantService.deleteRestaurantMenuHeader(menuHeader: movedObjTemp, restaurantID: self.restaurant.restaurantID!)
        menuHeaderData.insert(movedObjTemp, at: destinationIndexPath.item)
       
        //WORK IN PROGRESS
        if menuHeader.hasActiveDrop == true {
            //let data = menuHeaderData.
            //get all the elements of menuHeders
          //  menuHeaderData.
            
            //overwrite existing elements with new state
            
            //FIX
           // API.shared.restaurantManager.restaurantService.moveRestaurantMenuHeader(menuHeader: movedObjTemp, restaurantID: self.restaurant.restaurantID!)
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        let deletedObj = menuHeaderData[indexPath.item]
        
        if (editingStyle == .delete){
            menuHeaderData.remove(at: indexPath.item)
            menuHeader.deleteRows(at: [indexPath], with: .automatic)
            API.shared.restaurantManager.restaurantService.deleteRestaurantMenuHeader(menuHeader: deletedObj, restaurantID: self.restaurant.restaurantID!)
            
        }
    }
    

    @IBAction func didTapEdit(){
    
        if menuHeader.isEditing{
            menuHeader.isEditing = false
            editButton.setTitle("Edit", for: UIControl.State.normal)
        }
        else {
            menuHeader.isEditing = true
            editButton.setTitle("Done", for: UIControl.State.normal)
        }

    }
    
    //Add New Header
    @IBAction func newHeader(){
        promptForAnswer()
      
    }
    
    
    func promptForAnswer() {
        let ac = UIAlertController(title: "Add New Menu Header", message: nil, preferredStyle: .alert)
        ac.addTextField { field in
            field.placeholder = "Menu Header"
            field.returnKeyType = .done
        }
        
        let submitAction = UIAlertAction(title: "Submit", style: .default, handler: { _ in
            guard let fields = ac.textFields, fields.count == 1 else {

                return
                
            }
            let menuHeaderAnswerField = fields[0]
            guard let answer = menuHeaderAnswerField.text, !answer.isEmpty else {
                print("empty menu Header Answer")
                return
            }
            print(answer)
            //self.typeView.textField.text = answer
            //self.typeView.endEditing(true)
            //self.pickerData.insert(answer, at: self.pickerData.endIndex - 1)
            API.shared.restaurantManager.restaurantService.appendRestaurantMenuHeader(menuHeader: answer, restaurantID: self.restaurant.restaurantID!)
            
        //    API.shared.scannerManager.promptForAnswer(on: self) {
             //   <#code#>
           // }
            //reloads tableview after submit
            self.menuHeader.reloadData()
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {_ in
            //self.typeView.textField.text = ""
            //self.typeView.endEditing(true)
        })
        
        ac.addAction(submitAction)
        ac.addAction(cancelAction)
        
        self.present(ac, animated: true)
    }
    
    
    
    
    

    
}

extension SignUpInformationRestaurantViewController: UserManagerConsumer {
    func userDidSignup() {
        
        self.signUpButton.stopLoading()
        self.dismiss(animated: true, completion: nil)
    }
    
    func userFailedToSignup(with message: String) {
        self.signUpButton.stopLoading()
        API.shared.bannerManager.showErrorNotification(withMessage: message)
    }
}
