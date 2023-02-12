//
//  SearchTableViewCell.swift
//  PlopIt
//
//  Created by Raivis Olehno on 11/01/2022.
//

import UIKit

class SearchTableViewCell: UITableViewCell {

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var textField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = .none
        mainView.addCornerRadius(value: 20)
        textField.setLeftPaddingPoints(37)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

