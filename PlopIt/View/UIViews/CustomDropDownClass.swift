//
//  CustomDropDownClass.swift
//  PlopIt
//
//  Created by Raivis on 13/04/2022.
//

import UIKit
import iOSDropDown

enum DropDownType {
    case foodType
    case restaurant
    case test
    
    var titleText: String {
        var text = ""
        switch self {
        case .foodType:
            text = "Food Type"
        case .restaurant:
            text = "This item applies "
        default:
            text = ""
        }
        return text
    }
}

class CustomDropDownClass: PIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet weak var errorView: ErrorView!
    @IBOutlet weak var errorViewHeight: NSLayoutConstraint!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var textfield: DropDown!
    
    var checkHandler: ((String) -> ())?
    var type: DropDownType = .foodType
    
    override func addContentView() {
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
    func setupView() {
        errorView.alpha = 0
        errorViewHeight.constant = 0
        self.layoutIfNeeded()
    }
    
    func setup(text:String,type: DropDownType = .foodType ,cornerRadius: CGFloat = 4, optionArray: [String] = ["1","2","3"], optionIds: [Int] = [1,2,3] ,isEditable: Bool = true, textViewHeightConstraint: CGFloat = 70, checkHandler: ((String) -> ())? = nil) {
        self.type = type
        setupView()
        mainView.addBorder(withColor: .black, width: 1)
        mainView.addCornerRadius(value: cornerRadius)
        titleLabel.text = type.titleText
        textfield.text = text
        textfield.optionArray = optionArray
        textfield.optionIds = optionIds
        textfield.isUserInteractionEnabled = isEditable
        titleLabel.alpha = text == "" ? 0 : 1
        titleLabel.textColor = .black
        titleLabel.text = type.titleText
        textfield.setLeftPaddingPoints(20)
        titleLabel.transform = text == "" ? CGAffineTransform(translationX: 0, y: 10) : .identity
        self.checkHandler = checkHandler
        textfield.addTarget(self, action: #selector(CustomDropDownClass.textFieldDidChange(_:)), for: .editingChanged)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        titleLabel.textColor = .black
        if textField.text!.count > 0 {
            self.showTitle()
        } else {
            self.hideTitle()
        }
    }

    func text() -> String {
        return textfield.text!
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
}
