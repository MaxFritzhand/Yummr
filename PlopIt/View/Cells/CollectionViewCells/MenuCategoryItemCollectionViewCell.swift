//
//  MenuCategoryItemCollectionViewCell.swift
//  PlopIt
//
//  Created by Raivis Olehno on 06/03/2022.
//

import UIKit

class MenuCategoryItemCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func update(withCategoryItem categoryItem: String, selected: Bool) {
        self.titleLabel.text = categoryItem
        self.titleLabel.textColor = selected ? .black : Style.deselectedGreyButton
        
    }

}
