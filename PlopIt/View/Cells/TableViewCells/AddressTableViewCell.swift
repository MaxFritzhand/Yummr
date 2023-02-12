//
//  AddressTableViewCell.swift
//  PlopIt
//
//  Created by Max Fritzhand on 4/23/22.
//

import UIKit

class AddressTableViewCell: UITableViewCell {

    
    @IBOutlet weak var addressLabel: UIImageView!
    @IBOutlet weak var streetLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var zipLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
