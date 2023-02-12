//
//  CreateAccountViewController.swift
//  PlopIt
//
//  Created by Raivis Olehno on 15/01/2022.
//

import UIKit
import Firebase
import FirebaseFirestore

class CreateCustomerAccountViewController: PIViewController {

    
    @IBOutlet weak var signUpButton: LoadingButton!
    @IBOutlet weak var fullNameView: ImageTextFieldView!
    @IBOutlet weak var emailView: ImageTextFieldView!
    @IBOutlet weak var passwordView: ImageTextFieldView!
    @IBOutlet weak var confirmPasswordView: ImageTextFieldView!
    
    @IBOutlet weak var continuebtn: UIButton!
    
    //owner
    
    
    @IBOutlet weak var restaurantForm: UILabel!
    @IBOutlet weak var continueButton: LoadingButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        API.shared.userManager.addConsumer(consumer: self)
        setupView()
        updateLoginButtonIfNeeded()
        // Do any additional setup after loading the view.
    }
    
    func setupView() {
        signUpButton.addCornerRadius(value: 25)
        self.signUpButton.updateToEnabled()
        signUpButton.setup(withTapHandler: {
            self.attemptSignup()
        }, withTitle: "Sign Up")
        

        self.continueButton.updateToEnabled()
        continueButton.setup(withTapHandler: {
            self.ownerSignupButtonTapped()
        }, withTitle: "")
        
        
        fullNameView.textField.addTarget(self, action: #selector(CreateCustomerAccountViewController.textFieldDidChange(_:)), for: .editingChanged)
        emailView.textField.addTarget(self, action: #selector(CreateCustomerAccountViewController.textFieldDidChange(_:)), for: .editingChanged)
        passwordView.textField.addTarget(self, action: #selector(CreateCustomerAccountViewController.textFieldDidChange(_:)), for: .editingChanged)
        confirmPasswordView.textField.addTarget(self, action: #selector(CreateCustomerAccountViewController.textFieldDidChange(_:)), for: .editingChanged)

        fullNameView.setup(text: "", type: .fullname, isSeperatorHidden: 0, textFieldBackgroundColour: .clear, textColour: .black, showBorder: false, isEditable: true) { (fullName) in
            if fullName != "" {
                self.updateLoginButtonIfNeeded()
            }
        }
        emailView.setup(text: "", type: .email, isSeperatorHidden: 0, textFieldBackgroundColour: .clear, textColour: .black, showBorder: false, isEditable: true) { (email) in
            if email != "" {
                self.updateLoginButtonIfNeeded()
            }
        }

        passwordView.setup(text: "", type: .password, isShowPasswordButtonEnabled: 1, isSeperatorHidden: 0, textFieldBackgroundColour: .clear, textColour: .black, showBorder: false, isEditable: true) { (password) in
            if password != "" {
                self.updateLoginButtonIfNeeded()
            }
        }
        
        confirmPasswordView.setup(text: "", type: .password, isShowPasswordButtonEnabled: 1, isSeperatorHidden: 0, textFieldBackgroundColour: .clear, textColour: .black, showBorder: false, isEditable: true) { (confirmPassword) in
            if confirmPassword != "" {
                self.updateLoginButtonIfNeeded()
            }
        }
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        self.updateLoginButtonIfNeeded()
    }
    
    func hasCompletedAll() -> Bool {
        return fullNameView.text() != "" && emailView.text() != "" && passwordView.text() != "" && confirmPasswordView.text() != "" && passwordView.text() == confirmPasswordView.text() && emailView.text().isValidEmail
    }
    
    func attemptSignup() {
        if self.hasCompletedAll() {
         
            
            API.shared.userManager.createAccount(isOwner: false, email: emailView.text(), password: passwordView.text(), confirmPassword: confirmPasswordView.text(), fullName: fullNameView.text(), restaurantName: "", addressStreet: "", addressCity: "", addressState: "", addressZip: "", restaurantDescription: "", phoneNumber: "", priceRange: "", websiteURL: "", hourArray: [], dietaryDict: [:], genreDict: [:], restaurantHeaderImageURL: "", restaurantThumbnailImageURL: "")
            
            
        } else {
            self.signUpButton.stopLoading()
        }
        self.updateLoginButtonIfNeeded()
    }
    
    
    
    func updateLoginButtonIfNeeded() {
        if self.hasCompletedAll() {
            self.signUpButton.updateToEnabled()
            //self.continueButton.updateToEnabled()
            self.restaurantForm.textColor = UIColor(named: "ContinueButton")
            self.continuebtn.isEnabled = true
        
        } else {
            self.signUpButton.updateToDisabled()
            //self.continueButton.updateToDisabled()
            self.restaurantForm.textColor = UIColor(named: "notActiveContinueButton")
            self.continuebtn.isEnabled = false
      
             
        }
    }
    
    func ownerSignupButtonTapped(){
        
        let vc = SignUpInformationRestaurantViewController(fullName: fullNameView.text(), email: emailView.text(), password: passwordView.text(), confirmPassword: confirmPasswordView.text(), restaurantState: .new, withRestaurantData: Restaurant())
       // let vc = SignUpInformationRestaurantViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func continueButton(_ sender: Any) {
        let vc = SignUpInformationRestaurantViewController(fullName: fullNameView.text(), email: emailView.text(), password: passwordView.text(), confirmPassword: confirmPasswordView.text(), restaurantState: .new, withRestaurantData: Restaurant())
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        let vc = LoginViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension CreateCustomerAccountViewController: UserManagerConsumer {
    func userDidSignup() {
        self.signUpButton.stopLoading()
        self.dismiss(animated: true, completion: nil)
    }
    
    func userFailedToSignup(with message: String) {
        self.signUpButton.stopLoading()
        API.shared.bannerManager.showErrorNotification(withMessage: message)
    }
}
