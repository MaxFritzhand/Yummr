//
//  ImageTextField.swift
//  PlopIt
//
//  Created by Raivis Olehno on 15/01/2022.
//

import UIKit

enum TextFieldViewType {
    case username
    case fullname

    case emailRequired
    case passwordRequired
    case confirmPassword
    case birthday
    case occupation
    case address
    case city
    case state
    case street
    case zip
    case email
    case password
    case currentMobile
    case newMobile
    case businessMobile
    case websiteURL
    case currentPassword
    case confirmNewPassword
    case newPassword
    case emailOrUsername
    case accountPassword
    case other
    
    //Restaurant Types
    case restaurant
    case menuItem
    case description
    case price
    case isExpensive
    case foodType
    case genre
    case dietary

    
//    var image: UIImage {
//        var image = UIImage()
//        switch self {
//        case .email, .emailRequired, .emailOrUsername:
//            image = ImageHelper.emailImage()
//        case .username, .fullname:
//            image = ImageHelper.usernameImage()
//        case .password, .confirmPassword, .passwordRequired, .currentPassword, .newPassword, .confirmNewPassword:
//            image = ImageHelper.passwordImage()
//        case .birthday:
//            image = ImageHelper.birthdayImage()
//        case .occupation:
//            image = ImageHelper.occupationImage()
//        case .address:
//            image = ImageHelper.addressImage()
//        case .currentMobile, .newMobile:
//            image = ImageHelper.phoneImage()
//        default:
//            print("no case")
//        }
//        return image
//    }
    
    var placeholderText: String {
        var text = ""
        switch self {
        case .emailRequired:
            text = "Email"
        case .restaurant:
            text = "Restaurant"
        case .menuItem:
            text = "Menu Item"
        case .description:
            return "Description"
        case .price:
            return "Price ($)"
        case .isExpensive:
            return "How expensive? ($, $$, $$$)"
        case .foodType:
            return "Menu Section"
        case .genre:
            return "Restaurant Style"
        case .dietary:
            return "Dietary Restrictions"
            
        case .username:
            text = "Username"
        case .passwordRequired:
            text = "Password"
        case .accountPassword:
            text = "Enter account password"
        case .confirmPassword:
            text = "Confirm password"
        case .address:
            text = "Address"
        case .city:
            text = "City"
        case .state:
            text = "State"
        case .street:
            text = "Street"
        case .zip:
            text = "Zip"
        case .occupation:
            text = "Occupation"
        case .birthday:
            text = "Birthday"
        case .fullname:
            text = "Full name"
        case .email:
            text = "Email"
        case .password:
            text = "Password"
        case .currentMobile:
            text = "Current phone number"
        case .newMobile:
            text = "Phone number"
        case .businessMobile:
            text = "Business Phone Number"
        case .websiteURL:
            text = "Restaurant Website"
        case .currentPassword:
            text = "Current password"
        case .newPassword:
            text = "New password"
        case .emailOrUsername:
            text = "Username or email"
        default:
            text = ""
        }
        return text
    }
    
    var titleText: String {
        var text = ""
        switch self {
        case .emailRequired:
            text = "Email"
        case .username:
            text = "Username"
        case .restaurant:
            text = "Restaurant"
        case .menuItem:
            text = "Menu Item"
        case .description:
            return "Description"
        case .price:
            return "Price ($)"
        case .isExpensive:
            return "How expensive? ($, $$, $$$)"
        case .foodType:
            return "Menu Section"
        case .genre:
            return "Restaurant Style"
        case .dietary:
            return "Dietary Restrictions"
        case .passwordRequired:
            text = "Password"
        case .address:
            text = "Address"
        case .city:
            text = "City"
        case .state:
            text = "State"
        case .street:
            text = "Street"
        case .zip:
            text = "Zip"
        case .occupation:
            text = "Occupation"
        case .birthday:
            text = "Birthday"
        case .fullname:
            text = "Full name"
        case .email:
            text = "Email"
        case .password:
            text = "Password"
        case .currentMobile:
            text = "Current phone number"
        case .newMobile:
            text = "Phone number"
        case .businessMobile:
            text = "Business Phone Number"
        case .websiteURL:
            text = "Restaurant Website"
        case .currentPassword:
            text = "Current password"
        case .newPassword:
            text = "New password"
        case .confirmNewPassword:
            text = "* Confirm new password"
        case .emailOrUsername:
            text = "Username or email"
        case .accountPassword:
            text = "Enter account password"
        case .confirmPassword:
            text = "Confirm password"
        default:
            text = ""
        }
        return text
    }
}

class ImageTextFieldView: PIView {

    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textView: UIView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var errorView: ErrorView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var errorViewHeight: NSLayoutConstraint!
    @IBOutlet weak var showPassword: UIButton!
    @IBOutlet weak var seperatorLine: UIView!
    @IBOutlet weak var ErrorViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var textViewHeight: NSLayoutConstraint!
    
    
    var type: TextFieldViewType = .other
    var errorText = ""
    var checkHandler: ((String) -> ())?
    var editHandler: (() -> ())?
        
    override func addContentView() {
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
    func setupView() {
        titleLabel.textColor = .black
        textField.textColor = .black
        errorView.alpha = 0
        errorViewHeight.constant = 0
        self.layoutIfNeeded()
        activityIndicator.alpha = 0
        editButton.addCornerRadius(value: 8)

    }
    
    func setup(text: String, type: TextFieldViewType = .other, isShowPasswordButtonEnabled: CGFloat = 0 ,placeholderColour: UIColor = Colours.placeHolderColour, errorText: String = "", isSeperatorHidden: CGFloat = 0,borderColour: UIColor = .clear, borderWidth: CGFloat = 0, mainViewCornerRadius: CGFloat = 4, textViewHeightConstraint: CGFloat = 50, textFieldBackgroundColour: UIColor = .white ,textColour: UIColor = .black, showBorder: Bool = true, isEditable: Bool = true, checkHandler: ((String) -> ())? = nil, editHandler: (() -> ())? = nil, passwordHandler: (() -> ())? = nil, bottomViewConstraint: CGFloat = 0, leftPadding: CGFloat = 16) {
        self.seperatorLine.alpha = isSeperatorHidden
        self.ErrorViewBottomConstraint.constant = bottomViewConstraint
        self.checkHandler = checkHandler
        self.editHandler = editHandler
        self.type = type
        self.errorText = errorText
        setupView()
        textField.isUserInteractionEnabled = isEditable
        textView.backgroundColor = textFieldBackgroundColour
        textView.addBorder(withColor: borderColour, width: borderWidth)
        textViewHeight.constant = textViewHeightConstraint
        showPassword.alpha = isShowPasswordButtonEnabled
        editButton.alpha = editHandler != nil ? 1 : 0
        textField.textColor = textColour
        textView.addCornerRadius(value: mainViewCornerRadius)
        textField.addBorder(withColor: Colours.lightGreyBorder, width: 1)
        textField.addCornerRadius(value: 10)
        textField.setLeftPaddingPoints(20)
        textField.delegate = self
        errorView.alpha = 0
        titleLabel.textColor = .black
        titleLabel.text = type.titleText
        titleLabel.alpha = text == "" ? 0 : 1
        titleLabel.transform = text == "" ? CGAffineTransform(translationX: 0, y: 10) : .identity
        textField.isSecureTextEntry = type == .password || type == .passwordRequired || type == .currentPassword || type == .newPassword || type == .accountPassword
        textField.keyboardType = (type == .currentMobile || type == .newMobile || type == .price) ? .numberPad : .default
        textField.textContentType = .oneTimeCode
        textField.attributedPlaceholder = NSAttributedString(string: type.placeholderText, attributes: [NSAttributedString.Key.foregroundColor: placeholderColour])
        textField.text = text
        textField.addTarget(self, action: #selector(ImageTextFieldView.textFieldDidChange(_:)), for: .editingChanged)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        titleLabel.textColor = .black
        if textField.text!.count > 0 {
            self.showTitle()
        } else {
            self.hideTitle()
        }
    }
    
    @IBAction func passwordToggleButton(_ sender: UIButton) {
        let isSecureTextEntry = textField.isSecureTextEntry
        textField.isSecureTextEntry = isSecureTextEntry ? false : true
        if isSecureTextEntry {
            showPassword.setImage(UIImage(named: "showPassword"), for: .normal)
        } else {
            showPassword.setImage(UIImage(named: "hidePassword"), for: .normal)
        }
    }
    
    func showTitle() {
        UIView.animate(withDuration: 0.2) {
            self.titleLabel.alpha = 1
            self.titleLabel.transform = .identity
        }
    }
    
    func hideTitle() {
        UIView.animate(withDuration: 0.2) {
            self.titleLabel.alpha = 0
            self.titleLabel.transform = CGAffineTransform(translationX: 0, y: 10)
        }
    }
    
    func text() -> String {
        return textField.text!
    }
    
    private func updateView() {
        switch type {
        case .username, .passwordRequired, .emailRequired, .emailOrUsername, .newPassword:
            self.setupView()
            if let checker = self.checkHandler {
                self.activityIndicator.alpha = 1
                self.activityIndicator.startAnimating()
                checker(self.text())
            }
        case .confirmPassword, .newMobile, .confirmNewPassword, .currentPassword:
            self.setupView()
            if let checker = self.checkHandler {
                checker(self.text())
            }
        default:
            self.setupView()
        }
    }
    
    func updateForSuccess() {
        self.activityIndicator.alpha = 0
        self.activityIndicator.stopAnimating()
        titleLabel.textColor = .black
    }
    
    func updateForError() {
        titleLabel.textColor = .red
    }
    
    func updateForError(with message: String) {
        self.activityIndicator.alpha = 0
        self.activityIndicator.stopAnimating()
        
        updateForError()
        
        let attributedString = NSAttributedString(string: message, attributes: [.font: UIFont(name: "Poppins-Medium", size: 12.0)!])
        errorView.setup(with: attributedString, textColor: .black, borderColor: Colours.bankingHistoryStatusGrey)
        errorView.alpha = 1
        errorView.addBorder(withColor: Colours.bankingHistoryStatusGrey, width: 1)
        errorViewHeight.constant = StringHelper.labelSize(for: attributedString, considering: errorView.mainLabel.frame.width).height + 24.0
        self.layoutIfNeeded()
    }
    
    @IBAction func editTapped() {
        if editHandler != nil {
            editHandler!()
        }
    }
    
}

extension ImageTextFieldView: UITextFieldDelegate {
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField == self.textField {
            self.updateView()
        }
        return true
    }
    
}

extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}
