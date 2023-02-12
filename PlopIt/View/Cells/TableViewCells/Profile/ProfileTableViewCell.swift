////
////  ProfileTableViewCell.swift
////  PlopIt
////
////  Created by Max Fritzhand on 3/20/22.
////
//
import UIKit
//
class ProfileTableViewCell: UITableViewCell {
    @IBOutlet weak var topText: UILabel!
    @IBOutlet weak var bottomText: UILabel!
    @IBOutlet weak var icon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func update(data: AccountRows) {
        topText.text = data.title
        icon.image = data.image
        icon.tintColor = UIColor(hex: "ED7F0E")
        bottomText.text = data.text
    }
}
