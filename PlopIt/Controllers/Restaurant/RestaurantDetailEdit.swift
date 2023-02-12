//
//  RestaurantDetailEdit.swift
//  PlopIt
//
//  Created by Raeein Bagheri on 2022-03-30.
//

import UIKit
import BetterSegmentedControl

class RestaurantDetailEdit: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var middleView: UIView!
    @IBOutlet weak var saveChanges: UIButton!
    
    let txtField: UITextField = UITextField()
    let txtView: UITextView = UITextView()
    let slider: BetterSegmentedControl = BetterSegmentedControl()
    var restaurantID = ""
    var titleText = ""
    var editFieldText = ""
    //0, 1, 2 correspond to $, $$, $$$
    var dollar = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtView.delegate = self
        txtField.delegate = self
        buttonDisabled()
        populate()
    }
    func populate() {
        titleLabel.text = titleText
        setupMiddleView(title: titleText, text: editFieldText)
    }
    
    
    func update(data: RestaurantDetailRows, restaurantID: String) {
        titleText = data.title
        editFieldText = data.text
        self.restaurantID = restaurantID
    }
    func setupMiddleView(title:String, text: String) {

        switch title {
        case "Restaurant Name":
            setUpTextField(text)
        case "Description":
            setUpTextView(text)
        case "How Expensive":
            setupSlider(text)
        case "Restaurant Address":
            setUpTextView(text)
        default:
            print("print")
        }
    }
    
    func setUpTextField(_ text: String) {
        
        txtField.clearButtonMode = .whileEditing
        txtField.text = text
        txtField.translatesAutoresizingMaskIntoConstraints = false
        txtField.addBorder(withColor: .black, width: 1)
        txtField.layer.cornerRadius = 20
        middleView.addSubview(txtField)
        txtField.textAlignment = .center
        txtField.centerYAnchor.constraint(equalTo: middleView.centerYAnchor).isActive = true
        txtField.rightAnchor.constraint(equalTo: middleView.rightAnchor, constant: -24).isActive = true
        txtField.leftAnchor.constraint(equalTo: middleView.leftAnchor, constant: 24).isActive = true
        txtField.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    func setUpTextView(_ text: String) {
        
        txtView.text = text
        txtView.font = UIFont.systemFont(ofSize: 20)
        txtView.translatesAutoresizingMaskIntoConstraints = false
        txtView.addBorder(withColor: .black, width: 1)
        txtView.layer.cornerRadius = 10
        middleView.addSubview(txtView)
        txtView.centerYAnchor.constraint(equalTo: middleView.centerYAnchor).isActive = true
        txtView.rightAnchor.constraint(equalTo: middleView.rightAnchor, constant: -24).isActive = true
        txtView.leftAnchor.constraint(equalTo: middleView.leftAnchor, constant: 24).isActive = true
        txtView.heightAnchor.constraint(equalToConstant: 60).isActive = true
    }
    
    func setupSlider(_ text: String) {
        slider.addTarget(self, action: #selector(RestaurantDetailEdit.navigationSegmentedControlValueChanged(_:)), for: .valueChanged)
        middleView.addSubview(slider)
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.centerYAnchor.constraint(equalTo: middleView.centerYAnchor).isActive = true
        slider.centerXAnchor.constraint(equalTo: middleView.centerXAnchor).isActive = true
        slider.rightAnchor.constraint(equalTo: middleView.rightAnchor, constant: -24).isActive = true
        slider.leftAnchor.constraint(equalTo: middleView.leftAnchor, constant: 24).isActive = true
        slider.heightAnchor.constraint(equalToConstant: 60).isActive = true
        slider.segments = LabelSegment.segments(withTitles: ["$", "$$", "$$$"], normalBackgroundColor: .orange, normalFont: UIFont(name: "Poppins-SemiBold", size: 20) ,normalTextColor: .black, selectedBackgroundColor: .white,selectedFont: UIFont(name: "Poppins-SemiBold", size: 20) ,selectedTextColor: .orange)
        switch text {
        case "$":
            dollar = 0
            slider.setIndex(0)
        case "$$":
            dollar = 1
            slider.setIndex(1)
        case "$$$":
            dollar = 2
            slider.setIndex(2)
        default:
            dollar = 1
            slider.setIndex(1)
        }
        
    }
    @objc func navigationSegmentedControlValueChanged(_ sender: BetterSegmentedControl) {
        if sender.index == dollar {
            buttonDisabled()
        } else {
            buttonEnabled()
        }
    }
    
    func buttonEnabled() {
        saveChanges.isUserInteractionEnabled = true
        saveChanges.alpha = 1
    }
    func buttonDisabled() {
        saveChanges.isUserInteractionEnabled = false
        saveChanges.alpha = 0.3
    }
    
    @IBAction func backButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveChangesPressed(_ sender: UIButton) {
        let services = RestaurantService()
        switch titleLabel.text {
        case "Restaurant Name":
            editFieldText = txtField.text ?? ""
//            services.updateRestaurantName(id: restaurantID, newName: editFieldText) { result in
//                self.showBanner(result: result)
//            }
        case "Description":
            editFieldText = txtView.text ?? ""
//            services.updateRestaurantDescription(id: restaurantID, newDescription: editFieldText) { result in
//                self.showBanner(result: result)
//            }
        case "How Expensive":
            dollar = slider.index
//            services.updateRestaurantExpensive(id: restaurantID, newExpense: numberToDollar(dollar)) { result in
//                self.showBanner(result: result)
//            }
        default:
            print("print")
        }
        
        buttonDisabled()
    }
    
    func showBanner(result: Result<String, Error>) {
        switch result {
        case .success(let message):
            API.shared.bannerManager.showSuccessNotification(withTitle: "Success", withMessage: message)
        case .failure(let error):
            API.shared.bannerManager.showErrorNotification(withMessage: error.localizedDescription)
        }
    }
    
    func numberToDollar(_ number: Int) -> String {
        if number == 0 {
            return "$"
        } else if number == 1 {
            return "$$"
        } else {
            return "$$$"
        }
    }
}

extension RestaurantDetailEdit: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let text = (textView.text as NSString).replacingCharacters(in: range, with: text)
            if !text.isEmpty && text != editFieldText {
                buttonEnabled()
            } else {
                buttonDisabled()
            }
            return true
    }
}

extension RestaurantDetailEdit: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        let text = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let text = (textField.text! as NSString).replacingCharacters(in: range, with: string)
            if !text.isEmpty && text != editFieldText {
                buttonEnabled()
            } else {
                buttonDisabled()
            }
            return true
    }
}
