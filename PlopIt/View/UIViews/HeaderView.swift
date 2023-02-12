//
//  HeaderView.swift
//  PlopIt
//
//  Created by Raivis Olehno on 08/01/2022.
//

import UIKit

class HeaderView: UIView {
    
    public func update(withText text: String) {
        let label = UILabel()
        label.frame = CGRect.init(x: 0, y: 0, width: frame.width-50, height: frame.height)
        label.text = text
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        label.textColor = .black
        addSubview(label)
    }
}
