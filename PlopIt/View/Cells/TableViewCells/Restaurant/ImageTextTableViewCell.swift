//
//  ImageTextTableViewCell.swift
//  PlopIt
//
//  Created by Raivis Olehno on 11/01/2022.
//

import UIKit
import Kingfisher
import FirebaseStorage

class ImageTextTableViewCell: UITableViewCell {

    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var restaurantName: UILabel!
    @IBOutlet weak var distanceToRestaurantLabel: UILabel!
    @IBOutlet weak var restaurantTypeLabel: UILabel!
    @IBOutlet weak var restuarantCuisineLabel: UILabel!
    @IBOutlet weak var restaurantRatingLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func update(withRestaurantData data: Restaurant) {
        let gsReference = Storage.storage().reference(forURL: data.restaurantThumbnailImageURL!)
        gsReference.getData(maxSize: 1 * 1024 * 1024) { data, error in
            if let error = error {
                print(error)
              } else {
                let image = UIImage(data: data!)
                  self.mainImageView.image = image
              }
        }
        restaurantName.text = data.restaurantName
    }
    
}
