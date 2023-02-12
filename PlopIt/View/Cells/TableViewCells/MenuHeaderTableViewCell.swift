//
//  MenuHeaderTableViewCell.swift
//  PlopIt
//
//  Created by Yummr Admin on 5/11/22.
//

import UIKit

class MenuHeaderTableViewCell: UITableViewCell {

    @IBOutlet weak var menuLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func update(data: MenuHeaderRows){
        self.menuLabel.text = data.title
        
    }
    
}
