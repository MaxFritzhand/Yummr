//
//  detailTableViewCell.swift
//  PlopIt
//
//  Created by Raeein Bagheri on 2022-03-24.
//

import UIKit

class DetailTableViewCell: UITableViewCell {
    @IBOutlet weak var leftLabel: UILabel!
    @IBOutlet weak var rightLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func update(data: RestaurantDetailRows) {
            
        leftLabel.text = data.title
        if data.text.count > 14 {
            let text = data.text
            rightLabel.text = text[0...9] + "..."
        } else {
            rightLabel.text = data.text
        }
        
    }
}
