//
//  LoginViewController.swift
//  PlopIt
//
//  Created by Raivis Olehno on 13/01/2022.
//

import UIKit
import FirebaseAuth
import FirebaseCore
import GoogleSignIn
import FacebookLogin
import FBSDKCoreKit
import CryptoKit
import AuthenticationServices


class LoginViewController: PIViewController {
    
    @IBOutlet weak var emailView: ImageTextFieldView!
    @IBOutlet weak var passwordView: ImageTextFieldView!
    @IBOutlet weak var facebookLoginView: UIView!
    @IBOutlet weak var googleView: UIView!
    @IBOutlet weak var appleView: UIView!
    @IBOutlet weak var loadingView: LoadingButton!
    
    let facebookLoginButton = FBLoginButton(frame: .zero, permissions: ["public_profile", "email"])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        API.shared.userManager.addConsumer(consumer: self)
        setupView()
        // Do any additional setup after loading the view.
        
        facebookLoginButton.delegate = self
        facebookLoginButton.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func setupView() {
        API.shared.userManager.addConsumer(consumer: self)
        facebookLoginView.addBorder(withColor: Colours.facebookButtonBorder, width: 1)
        googleView.addBorder(withColor: Colours.googleButtonBorder, width: 1)
        appleView.addBorder(withColor: .black, width: 1)
        facebookLoginView.addCornerRadius(value: 27.5)
        googleView.addCornerRadius(value: 27.5)
        appleView.addCornerRadius(value: 27.5)
        
        emailView.setup(text: "", type: .email, isSeperatorHidden: 0, textFieldBackgroundColour: .clear, textColour: .black, showBorder: false, isEditable: true) { (email) in
            self.updateEmailView()
            self.updateLoginButtonIfNeeded()
        }
        emailView.textField.addTarget(self, action: #selector(LoginViewController.textFieldDidChange(_:)), for: .editingChanged)
        passwordView.textField.addTarget(self, action: #selector(LoginViewController.textFieldDidChange(_:)), for: .editingChanged)
        passwordView.setup(text: "", type: .password, isShowPasswordButtonEnabled: 1, isSeperatorHidden: 0, textFieldBackgroundColour: .clear, textColour: .black, showBorder: false, isEditable: true) { (password) in
        }
        
        loadingView.setup(withTapHandler: {
            self.attemptLogin()
        }, withTitle: "Login")
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if textField == emailView.textField {
            self.updateEmailView()
        } else {
            self.updatePasswordView()
        }
        self.updateLoginButtonIfNeeded()
    }
    
    func updateEmailView() {
        if self.emailView.text() != "" {
            self.emailView.updateForSuccess()
        } else {
            self.emailView.setupView()
        }
    }
    
    func updatePasswordView() {
        if self.passwordView.text() != "" {
            self.passwordView.updateForSuccess()
        } else {
            self.passwordView.setupView()
        }
    }
    
    func updateTextFieldsWithError() {
        emailView.updateForError()
        passwordView.updateForError()
    }
    
    func hasCompletedAll() -> Bool {
        return emailView.text() != "" && passwordView.text() != "" && emailView.text().isValidEmail
    }
    
    func updateLoginButtonIfNeeded() {
        if self.hasCompletedAll() {
            self.loadingView.updateToEnabled()
        } else {
            self.loadingView.updateToDisabled()
        }
    }
    
    func attemptLogin() {
        if self.hasCompletedAll() {
            API.shared.userManager.login(email: emailView.text(), password: passwordView.text())
            API.shared.bannerManager.showSuccessNotification(withTitle: "Success", withMessage: "Email sign in a success!")
            
        } else {
            self.loadingView.stopLoading()
            API.shared.bannerManager.showWarningNotification(withTitle: "Warning!", withMessage: "Please fill in both email and password")
        }
        self.updateLoginButtonIfNeeded()
    }
        
    @IBAction func forgotPasswordTapped(_ sender: Any) {
        let vc = ForgotPasswordViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func signUpButtonTapped(_ sender: Any) {
        
        let vc = CreateCustomerAccountViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func loginWithGoogle(_ sender: Any) {
        API.shared.userManager.GoogleLogIn(vc: self)
    }
    
    @IBAction func loginWithFacebookTapped(_ sender: Any) {
        facebookLoginButton.sendActions(for: .touchUpInside)
    }
    
    @IBAction func loginWithApple(_ sender: UIButton) {
        API.shared.userManager.userService.startSignInWithAppleFlow(vc: self)
    }
}

extension LoginViewController: UserManagerConsumer {
    func userDidLogIn() {
        self.loadingView.stopLoading()
        self.dismiss(animated: true, completion: nil)
        
        //Face ID Implementation
    }
    
    func userFailedToLogIn(with message: String) {
        self.loadingView.stopLoading()
        self.updateTextFieldsWithError()
        API.shared.bannerManager.showErrorNotification(withMessage: message)
    }
    
    func didGetCurrentUser() {
        self.loadingView.stopLoading()
    }
}
