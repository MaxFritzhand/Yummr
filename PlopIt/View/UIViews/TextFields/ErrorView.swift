//
//  ErrorView.swift
//  PlopIt
//
//  Created by Raivis Olehno on 15/01/2022.
//

import UIKit

class ErrorView: PIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var errorView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    
    override func addContentView() {
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
    private func setupView() {
        errorView.addCornerRadius(value: 5.0)
        errorView.addBorder(withColor: Colours.bankingHistoryStatusGrey, width: 1)
        errorView.layer.borderWidth = 1
    }
    
    func setup(with attributedString: NSAttributedString, textColor: UIColor = .red, borderColor: UIColor = .lightGray, isHidden: CGFloat = 1) {
        mainLabel.attributedText = attributedString
        mainLabel.textColor = textColor
        setupView()
        errorView.addBorder(withColor: borderColor, width: 1)
        imageView.alpha = isHidden
    }
    
}
