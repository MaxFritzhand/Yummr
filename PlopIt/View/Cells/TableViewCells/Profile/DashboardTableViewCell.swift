//
//  DashboardTableViewCell.swift
//  PlopIt
//
//  Created by e on 3/29/22.
//

import UIKit

class DashboardTableViewCell: UITableViewCell {

    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var settingsLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateRows(with data: ProfileRows) {
        self.iconImage.image = data.image
        self.settingsLabel.text = data.title
    }
    
}
