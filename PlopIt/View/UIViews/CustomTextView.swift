//
//  CustomTextView.swift
//  PlopIt
//
//  Created by Raivis on 12/04/2022.
//

import UIKit
import STTextView

enum TextViewType {
    case restaurant
    case menuItem
    case description
    case price
    case foodType
    
    var titleText: String {
        var text = ""
        switch self {
        case .description:
            text = "Description"
        default:
            text = ""
        }
        return text
    }
}

class CustomTextView: PIView {
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var textView: STTextView!
    @IBOutlet private weak var errorView: ErrorView!
    @IBOutlet private weak var mainView: UIView!
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet weak var errorViewHeightConstraint: NSLayoutConstraint!
    
    var checkHandler: ((String) -> ())?
    var editHandler: (() -> ())?
    var type: TextViewType = .description
    
    override func addContentView() {
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
    func setupView() {
        textView.delegate = self
        errorView.alpha = 0
        errorViewHeightConstraint.constant = 0
        self.layoutIfNeeded()
    }
    
    func setup(text:String, type: TextViewType = .description ,cornerRadius: CGFloat = 4, isEditable: Bool = true, textViewHeightConstraint: CGFloat = 70, checkHandler: ((String) -> ())? = nil, textViewTopSpacing: CGFloat = 16) {
        self.type = type
        setupView()
        mainView.addBorder(withColor: .black, width: 1)
        mainView.addCornerRadius(value: cornerRadius)
        titleLabel.text = type.titleText
        textView.placeholder = "Description"
        textView.placeholderColor = Colours.placeHolderColour
        textView.text = text
        textView.isUserInteractionEnabled = isEditable
        titleLabel.alpha = text == "" ? 0 : 1
        titleLabel.textColor = .black
        titleLabel.text = type.titleText
        textView.textContainerInset = UIEdgeInsets(top: 10, left: 16, bottom: 0, right: 16)
        self.checkHandler = checkHandler
    }
    
    func text() -> String {
        return textView.text!
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

extension CustomTextView: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if textView.text!.count > 0 {
            self.showTitle()
        } else {
            self.hideTitle()
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
            if textView.textColor == UIColor.lightGray {
                textView.text = nil
                textView.textColor = UIColor.black
            }
        }

}


