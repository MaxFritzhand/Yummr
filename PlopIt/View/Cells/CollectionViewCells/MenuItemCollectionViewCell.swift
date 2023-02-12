//
//  MenuItemCollectionViewCell.swift
//  PlopIt
//
//  Created by Raivis Olehno on 18/02/2022.
//

import UIKit
import FirebaseStorage

class MenuItemCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func update(menuItem: MenuItem) {
        
        titleLabel.text = menuItem.menuItem ?? "NO NAME"
        
        if menuItem.thumbnailImage?.prefix(4) == "gs:/" {
            API.shared.firebaseStorageManager.pullImageFromDatabase(fromURL: menuItem.thumbnailImage ?? "https://www.tomfrancistreeservices.co.uk/wp-content/themes/wp-garden/assets/images/no-image.jpg") { mainImage in
                self.imageView.image = mainImage
            }
        } else {
            self.imageView.kf.setImage(with: URL(string: menuItem.thumbnailImage ?? "https://www.tomfrancistreeservices.co.uk/wp-content/themes/wp-garden/assets/images/no-image.jpg"))
        }
        
        imageView.addCornerRadius(value: 10)
        
    }

}
