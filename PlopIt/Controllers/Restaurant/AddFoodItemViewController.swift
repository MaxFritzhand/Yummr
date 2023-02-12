//
//  AddFoodItemViewController.swift
//  PlopIt
//
//  Created by Raivis Olehno on 18/01/2022.
//

import UIKit
import SwiftUI
import FirebaseStorage

enum ItemCategory {
    case newItem
    case existingItem
}

class AddFoodItemViewController: PIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var menuView: ImageTextFieldView!
    @IBOutlet weak var descriptionView: ImageTextFieldView!
    @IBOutlet weak var typeView: ImageTextFieldView!
    @IBOutlet weak var priceView: ImageTextFieldView!
    @IBOutlet weak var ARView: UIView!
    @IBOutlet weak var saveDraftButton: LoadingButton!
    @IBOutlet weak var uploadARScanButton: UIButton!
    @IBOutlet weak var thumnailAddedImageView: UIImageView!
    @IBOutlet weak var submitButton: LoadingButton!
    @IBOutlet weak var createScanButton: LoadingButton!
    @IBOutlet weak var ARViewLabel: UILabel!
    
    
    var imageURL: Data = Data()
    private var url: URL?
    let model = CameraViewModel()
    var restaurant: Restaurant
    var menuItem: MenuItem
    var pickerData: [String] = [String]()
    var selectedMenuHeaderIndex: Int = 0
    var categoryInitialized: ItemCategory = .newItem
    var newThumbnail:Bool = false
    var newScan: Bool = false
    
    init(categoryInitialized: ItemCategory, withRestaurantData restaurantData:  Restaurant, withMenuItem menuItem: MenuItem) {
        self.categoryInitialized = categoryInitialized
        self.restaurant = restaurantData
        self.menuItem = menuItem
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        API.shared.userManager.addConsumer(consumer: self)
        setupView()
        setupPicker()
        // Do any additional setup after loading the view.
    }
    
    //textfield functionality
    func setupView() {
        //navigationController?.navigationBar.isHidden = true
        self.thumnailAddedImageView.alpha = 1
        thumnailAddedImageView.addCornerRadius(value: 10)
        createScanButton.addCornerRadius(value: 13)
        closeButton.addCornerRadius(value: self.closeButton.frame.width/2)
        ARView.addCornerRadius(value: 10)
        ARView.addBorder(withColor: Colours.lightGreyBorder, width: 1)
        uploadARScanButton.setTitle("", for: .normal)
        ARViewLabel.text = "Click to take Thumbnail Image"
        setupTextFields()
        
        if categoryInitialized == .existingItem && menuItem.thumbnailImage != nil {
            API.shared.firebaseStorageManager.pullImageFromDatabase(fromURL: menuItem.thumbnailImage!) { image in
                self.thumnailAddedImageView.image = image
            }
        }
        
    }
   /*
    func setupNavBarFunction() {
        self.title = categoryInitialized == .newItem ? "Add Item" :  "Edit Item"
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController!.navigationBar.barStyle = .black
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(didTapCellButton(_:)))
        navigationItem.rightBarButtonItem?.tintColor = UIColor.white
        
        let appearance = UINavigationBarAppearance()
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.backgroundColor = UIColor(hex: "#FE7700")
        appearance.shadowColor = .clear
        
        let backItem = UIBarButtonItem()
        backItem.title = ""
        backItem.tintColor = UIColor.white
        navigationItem.backBarButtonItem = backItem
        
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        
    }*/
    
    func setupTextFields() {
        menuView.textField.addTarget(self, action: #selector(CreateCustomerAccountViewController.textFieldDidChange(_:)), for: .editingChanged)
        
        priceView.textField.addTarget(self, action: #selector(CreateCustomerAccountViewController.textFieldDidChange(_:)), for: .editingChanged)
        
        /*typeView.textField.addTarget(self, action: #selector(CreateAccountViewController.textFieldDidChange(_:)), for: .editingChanged)*/
        
        /* selectRestaurantView.textField.addTarget(self, action: #selector(CreateAccountViewController.textFieldDidChange(_:)), for: .editingChanged)*/
        
        
        menuView.setup(text: (categoryInitialized == .newItem ? "" :  menuItem.menuItem) ?? "", type: .menuItem, isSeperatorHidden: 0, borderColour: Colours.borderColour5A, borderWidth: 1, mainViewCornerRadius: 10, textFieldBackgroundColour: .clear, textColour: .black, showBorder: false, isEditable: true, checkHandler: { menuItem in
            if menuItem != "" {
                
            }
        })
        
        descriptionView.setup(text: (categoryInitialized == .newItem ? "" :  menuItem.itemDescription) ?? "", type: .description, isSeperatorHidden: 0, borderColour: Colours.borderColour5A, borderWidth: 1, mainViewCornerRadius: 10, textFieldBackgroundColour: .clear, textColour: .black, showBorder: false, isEditable: true, checkHandler: { text in
            if text != "" {
                
            }
        })
        
        /*descriptionView.setup(text: (categoryInitialized == .newItem ? "" :  menuItem.itemDescription) ?? "", type: .description, cornerRadius: 10, textViewHeightConstraint: 70, checkHandler: { text in
         if text != "" {
         self.updateSubmitButton()
         }
         }, textViewTopSpacing: categoryInitialized == .newItem ? 16 : 8)*/
        
        
        priceView.setup(text: (categoryInitialized == .newItem ? "" :  menuItem.price) ?? "", type: .price, isSeperatorHidden: 0, borderColour: Colours.borderColour5A, borderWidth: 1, mainViewCornerRadius: 10, textFieldBackgroundColour: .clear, textColour: .black, showBorder: false, isEditable: true) { (price) in
            if price != "" {
                self.updateSubmitButton()
            }
        }
        
        priceView.textField.keyboardType = .decimalPad
        priceView.textField.delegate = self
        
        typeView.setup(text: (categoryInitialized == .newItem ? "" :  restaurant.menuHeaderArray![menuItem.menuHeaderID!]), type: .foodType, isSeperatorHidden: 0, borderColour: Colours.borderColour5A, borderWidth: 1, mainViewCornerRadius: 10, textFieldBackgroundColour: .clear, textColour: .black, showBorder: false, isEditable: true) { (description) in
            if description != "" {
                self.updateSubmitButton()
            }
        }
       //
        if categoryInitialized == .newItem {
            saveDraftButton.setup(withTapHandler: {
                self.submitDraft()
            }, withTitle: "Save Draft")
            
            submitButton.setup(withTapHandler: {
                self.submitItem()
            }, withTitle: "Submit Item")
        } else {
            saveDraftButton.setup(withTapHandler: {
                self.updateDraft()
            }, withTitle: "Save Changes")
            
            submitButton.isHidden = true
            submitButton.actionButton.isEnabled = false
            
            
            /*submitButton.setup(withTapHandler: {
             self.submitItem()
             }, withTitle: menuItem.isPublished! ? "Submit & Publish" : "Unpublish Item")*/
            
            //menuItem.isPublished! ? submitButton.updateForPublish() : submitButton.updateForDelete()
        }
        
        /* selectRestaurantView.setup(text: "", type: .description, isSeperatorHidden: 0, borderColour: Colours.borderColour5A, borderWidth: 1, mainViewCornerRadius: 10, textFieldBackgroundColour: .clear, textColour: .black, showBorder: false, isEditable: true) { (restaurantType) in
         if restaurantType != "" {
         self.updateSubmitButton()
         }
         }*/
        
        createScanButton.setup(withTapHandler: {
            self.createScan()
        }, withTitle: categoryInitialized == .newItem ? "Create 3D Scan" : "Retake 3D Scan")
        
        categoryInitialized == .newItem ? createScanButton.updateToDisabled() : createScanButton.updateToEnabled()
    }
    
    func hasCompletedAll() -> Bool {
        return menuView.text() != "" && descriptionView.text() != "" && typeView.text() != "" //&& priceView.text() != "" //&& selectRestaurantView.text() != ""
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        self.updateSubmitButton()
        self.updateDraftButton()
    }
    
    func createScan() {
        _ = model.$captureFolderState.sink(receiveValue: { folder in
            self.url = folder?.captureDir
        })
        
        let view = CameraView(model: model).environment(\.uiHostingControllerPresenter, UIHostingControllerPresenter(self))
        let viewController = UIHostingController(rootView: view)
        
        viewController.modalPresentationStyle = .fullScreen
        present(viewController, animated: true, completion: nil)
    }
    
    //if newItem, submitdraft
    func submitDraft() {
        if self.menuView.textField.text != "" {
            let newMenuItemReference = API.shared.restaurantManager.createEmptyMenuItemDocument()
            let newDocumentID = newMenuItemReference.documentID
            
            var newThumbnailURL = ""
            if newThumbnail {
                API.shared.firebaseStorageManager.uploadImageData(data: imageURL, serverFileName: UUID().uuidString, restaurantName: restaurant.restaurantID!) { isSuccess, url in
                    if isSuccess {
                        newThumbnailURL = url ?? ""
                        print("thumbnail uploaded")
                    }
                }
            }
            
            API.shared.restaurantManager.addNewMenuItem(menuItemDocumentID: newDocumentID, menuItem: self.menuView.text(), menuHeaderID: self.selectedMenuHeaderIndex, itemDescription: self.descriptionView.text(), itemPrice: self.priceView.text(),thumbnailURL: newThumbnailURL, restaurantID: self.restaurant.restaurantID!)
            
            let images: [UIImage]? = API.shared.scannerManager.getScannedImageArray(url: self.url)
            let letters = "abcdefghijklmnopqrstuvwxyz"
            let result = String((0..<10).map { _ in letters.randomElement()! })
            
            for image in images! {
                if let data = image.jpegData(compressionQuality: 0.9) {
                    API.shared.awsManager.uploadImage(with: data, restaurantID: self.restaurant.restaurantID!, menuItemID: newDocumentID, randomString: result)
                }
            }
        } else {
            API.shared.bannerManager.showErrorNotification(withMessage: "Please at least enter menu item name")
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func updateDraft() {
        if self.menuView.textField.text != "" {
            var newThumbnailURL = ""
            if newThumbnail {
                API.shared.firebaseStorageManager.uploadImageData(data: imageURL, serverFileName: UUID().uuidString, restaurantName: restaurant.restaurantID!) { isSuccess, url in
                    if isSuccess {
                        newThumbnailURL = url ?? ""
                        print("thumbnail uploaded")
                    }
                }
            }
            
            API.shared.restaurantManager.updateMenuItem(menuDocumentID: menuItem.documentID!, menuItem: self.menuView.text(), menuHeaderID: self.selectedMenuHeaderIndex, itemDescription: self.descriptionView.text(), itemPrice: self.priceView.text(), thumbnailURL: newThumbnailURL, isPublished: false)
            
            let letters = "abcdefghijklmnopqrstuvwxyz"
            let result = String((0..<10).map { _ in letters.randomElement()! })
            
            let images: [UIImage]? = API.shared.scannerManager.getScannedImageArray(url: self.url)
            for image in images! {
                if let data = image.jpegData(compressionQuality: 0.9) {
                    API.shared.awsManager.uploadImage(with: data, restaurantID: self.restaurant.restaurantID!, menuItemID: menuItem.documentID!, randomString: result)
                }
            }
            
            //API.shared.restaurantManager.addRestaurantMenuItem(menuItem: self.menuView.text(), menuHeaderID: self.selectedMenuHeaderIndex, itemDescription: self.descriptionView.text(), itemPrice: self.priceView.text(), modelURL: "", thumbnailURL: "", restaurantID: self.restaurant.restaurantID!)
        } else {
            API.shared.bannerManager.showErrorNotification(withMessage: "Please at least enter menu item name")
        }
        self.navigationController?.popViewController(animated: true)
        API.shared.bannerManager.showSuccessNotification(withTitle: "Hey!", withMessage: "Draft was saved sucessfully!", tapHandler: nil)
    }
    
    func submitItem() {
        if categoryInitialized == .newItem {
            if self.hasCompletedAll() {
                let newMenuItemReference = API.shared.restaurantManager.createEmptyMenuItemDocument()
                let newDocumentID = newMenuItemReference.documentID
                
                var newThumbnailURL = ""
                if newThumbnail {
                    API.shared.firebaseStorageManager.uploadImageData(data: imageURL, serverFileName: UUID().uuidString, restaurantName: restaurant.restaurantID!) { isSuccess, url in
                        if isSuccess {
                            newThumbnailURL = url ?? ""
                            print("thumbnail uploaded")
                        }
                    }
                }
                
                API.shared.restaurantManager.addNewMenuItem(menuItemDocumentID: newDocumentID, menuItem: self.menuView.text(), menuHeaderID: self.selectedMenuHeaderIndex, itemDescription: self.descriptionView.text(), itemPrice: self.priceView.text(), thumbnailURL: newThumbnailURL, restaurantID: self.restaurant.restaurantID!)
                
                let letters = "abcdefghijklmnopqrstuvwxyz"
                let result = String((0..<10).map { _ in letters.randomElement()! })
                
                let images: [UIImage]? = API.shared.scannerManager.getScannedImageArray(url: self.url)
                for image in images! {
                    if let data = image.jpegData(compressionQuality: 0.9) {
                        API.shared.awsManager.uploadImage(with: data, restaurantID: self.restaurant.restaurantID!, menuItemID: newDocumentID, randomString: result)
                    }
                }
            }
            self.dismiss(animated: true, completion: nil)
        } else if categoryInitialized == .existingItem {
            if self.hasCompletedAll() {
                var newThumbnailURL = ""
                if newThumbnail {
                    API.shared.firebaseStorageManager.uploadImageData(data: imageURL, serverFileName: UUID().uuidString, restaurantName: restaurant.restaurantID!) { isSuccess, url in
                        if isSuccess {
                            newThumbnailURL = url ?? ""
                            print("thumbnail uploaded")
                        }
                    }
                }
                
                API.shared.restaurantManager.updateMenuItem(menuDocumentID: menuItem.documentID!, menuItem: self.menuView.text(), menuHeaderID: self.selectedMenuHeaderIndex, itemDescription: self.descriptionView.text(), itemPrice: self.priceView.text(), thumbnailURL: newThumbnailURL, isPublished: true)
                
                let letters = "abcdefghijklmnopqrstuvwxyz"
                let result = String((0..<10).map { _ in letters.randomElement()! })
                
                let images: [UIImage]? = API.shared.scannerManager.getScannedImageArray(url: self.url)
                for image in images! {
                    if let data = image.jpegData(compressionQuality: 0.9) {
                        API.shared.awsManager.uploadImage(with: data, restaurantID: self.restaurant.restaurantID!, menuItemID: menuItem.documentID!, randomString: result)
                    }
                }
            }
            self.submitButton.stopLoading()
            self.navigationController?.popToRootViewController(animated: true)
            self.dismiss(animated: true, completion: nil)
            API.shared.bannerManager.showSuccessNotification(withTitle: "Hey!", withMessage: "Restaurant Item was added sucessfully!", tapHandler: nil)
        } else {
            API.shared.bannerManager.showErrorNotification(withMessage: "Something Went Wrong!")
            self.submitButton.stopLoading()
        }
        self.updateSubmitButton()
        self.navigationController?.popViewController(animated: true)
    }
    
    func updateSubmitButton() {
        if self.hasCompletedAll() {
            self.submitButton.updateToEnabled()
            self.createScanButton.updateToEnabled()
        } else {
            self.submitButton.updateToDisabled()
            self.createScanButton.updateToDisabled()
        }
    }
    
    func updateDraftButton() {
        if menuView.text() != "" {
            self.saveDraftButton.updateToEnabled()
        } else {
            self.saveDraftButton.updateToDisabled()
        }
    }
    
    //this gets called from capturegalleryview but not in add food
    func updateButtons() {
        createScanButton.setup(withTapHandler: {
            API.shared.bannerManager.alertUser(with: "Are you sure you want to re-take scan?", title: "Re-take Scan", vc: self) {
                API.shared.scannerManager.removeOldSessionDirectories(url: self.url)
                self.createScan()
            }
        }, withTitle: "Images Captured")
        self.createScanButton.updateToEnabled()
    }
    
    @objc func didTapCellButton(_ sender: UIButton) {

    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func closeButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //for deprecation, change to PHPPicker
    @IBAction func thumbnailTapped(_ sender: Any) {
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.allowsEditing = true
        vc.delegate = self
        present(vc, animated: true)
    }
    
    //PICKER FUNCTIONALITY
    func setupPicker() {
        let pickerView = UIPickerView()
        typeView.textField.inputView = pickerView
        pickerView.delegate = self
        pickerView.dataSource = self
        setupPickerViewTap()
        pickerData = restaurant.menuHeaderArray!
        pickerData.append("Add Menu Header")
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        guard let image = info[.editedImage] as? UIImage else {
            print("No image found")
            return
        }
        
        thumnailAddedImageView.image = image
        thumnailAddedImageView.addBorder(withColor: .clear)
        
        if let data = image.pngData() {
            imageURL = data
            newThumbnail = true
        }
    }
    
    // Number of columns of data
    func numberOfComponents(in typeView: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data
    func pickerView(_ typeView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(_ typeView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(pickerData.count)
        print(row)
        
        if ( Int(row) == pickerData.count - 1 ) {
            promptForAnswer()
        }
        typeView.textField.text = pickerData[row]
        typeView.showTitle()
        self.selectedMenuHeaderIndex = row
    }
    
    // TODO BUG FIX: GESTURE RECOGNIZER WORKS BUT DOESNT SEEM WORK ON ENTIRE VIEW. only when you tap sides. so thats why ihave showTitle in the didSelectRow and on Tap
    @objc func pickerTapped(_ sender: UITapGestureRecognizer) {
        print("pickerTapped")
        self.typeView.showTitle()
    }
    
    func setupPickerViewTap() {
        let PickerTap = UITapGestureRecognizer(target: self, action: #selector(self.pickerTapped(_:)))
        self.typeView.isUserInteractionEnabled = true
        self.typeView.addGestureRecognizer(PickerTap)
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
            self.typeView.textField.text = answer
            self.typeView.endEditing(true)
            self.pickerData.insert(answer, at: self.pickerData.endIndex - 1)
            API.shared.restaurantManager.restaurantService.appendRestaurantMenuHeader(menuHeader: answer, restaurantID: self.restaurant.restaurantID!)
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {_ in
            self.typeView.textField.text = ""
            self.typeView.endEditing(true)
        })
        
        ac.addAction(submitAction)
        ac.addAction(cancelAction)
        
        self.present(ac, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //priceView delegate to check for valid double ( 2 decimals)
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // User pressed the delete-key to remove a character, this is always valid, return true to allow change
        if string.isEmpty { return true }
        
        // Build the full current string: TextField right now only contains the
        // previous valid value. Use provided info to build up the new version.
        // Can't just concat the two strings because the user might've moved the
        // cursor and delete something in the middle.
        let currentText = textField.text ?? ""
        let replacementText = (currentText as NSString).replacingCharacters(in: range, with: string)
        
        // Use our string extensions to check if the string is a valid double and
        // only has the specified amount of decimal places.
        return replacementText.isValidDouble(maxDecimalPlaces: 2)
    }
    
}


//checks for string validation for valid Double
extension String {
    func isValidDouble(maxDecimalPlaces: Int) -> Bool {
        // Use NumberFormatter to check if we can turn the string into a number
        // and to get the locale specific decimal separator.
        let formatter = NumberFormatter()
        formatter.allowsFloats = true // Default is true, be explicit anyways
        let decimalSeparator = formatter.decimalSeparator ?? "."  // Gets the locale specific decimal separator. If for some reason there is none we assume "." is used as separator.
        
        // Check if we can create a valid number. (The formatter creates a NSNumber, but
        // every NSNumber is a valid double, so we're good!)
        if formatter.number(from: self) != nil {
            // Split our string at the decimal separator
            let split = self.components(separatedBy: decimalSeparator)
            
            // Depending on whether there was a decimalSeparator we may have one
            // or two parts now. If it is two then the second part is the one after
            // the separator, aka the digits we care about.
            // If there was no separator then the user hasn't entered a decimal
            // number yet and we treat the string as empty, succeeding the check
            let digits = split.count == 2 ? split.last ?? "" : ""
            
            // Finally check if we're <= the allowed digits
            return digits.count <= maxDecimalPlaces    // TODO: Swift 4.0 replace with digits.count, YAY!
        }
        
        return false // couldn't turn string into a valid number
    }
}
