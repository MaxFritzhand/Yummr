//
//  ForgotPasswordViewController.swift
//  PlopIt
//
//  Created by Raivis Olehno on 07/02/2022.
//

import UIKit

class ForgotPasswordViewController: PIViewController {
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var emailView: ImageTextFieldView!
    @IBOutlet weak var buttonView: LoadingButton!
    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    var topText = "Forgot your password"
    var bottomText = "Please enter the address you would like your password reset information sent to"
    var dismissButtonText = "Back to Login"
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
        // Do any additional setup after loading the view.
    
    @objc func refreshLbl() {
        mainLabel.text = "LogOut"
    }
    
    func update(mainText: String, subtitle: String, dismissText: String) {
        topText = mainText
        bottomText = subtitle
        dismissButtonText = dismissText
    }
    
    func setupView() {
        mainLabel.text = topText
        descriptionLabel.text = bottomText
        dismissButton.setTitle(dismissButtonText, for: .normal)
        //Doesn't work
//        dismissButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 30)
        mainView.addCornerRadius(value: 10)
        emailView.setup(text: "", type: .email, isSeperatorHidden: 0, textFieldBackgroundColour: .clear, textColour: .black, showBorder: false, isEditable: true) { (email) in
            self.updateEmailView()
            self.updateLoginButtonIfNeeded()
        }
        
        emailView.textField.addTarget(self, action: #selector(ForgotPasswordViewController.textFieldDidChange(_:)), for: .editingChanged)
        
        buttonView.setup(withTapHandler: {
            self.attemptLogin()
        }, withTitle: "Request reset link")
    }
    
    func attemptLogin() {
        if self.hasCompletedAll() {
            API.shared.userManager.resetPassword(email: emailView.text()) {
                self.navigationController?.popViewController(animated: true)
            } withFailure: { error in
                DispatchQueue.main.async {
                    API.shared.bannerManager.showErrorNotification(withMessage: error)
                }
            }
        } else {
            self.buttonView.stopLoading()
            API.shared.bannerManager.showWarningNotification(withTitle: "Warning!", withMessage: "Please enter your email!")
        }
        self.updateLoginButtonIfNeeded()
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if textField == emailView.textField {
            self.updateEmailView()
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
    
    func hasCompletedAll() -> Bool {
        return emailView.text() != "" && emailView.text().isValidEmail
    }
    
    func updateLoginButtonIfNeeded() {
        if self.hasCompletedAll() {
            self.buttonView.updateToEnabled()
        } else {
            self.buttonView.updateToDisabled()
        }
    }
    
    @IBAction func backToLoginTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
