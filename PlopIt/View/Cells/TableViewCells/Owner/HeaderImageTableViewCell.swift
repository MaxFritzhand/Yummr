//
//  OwnerTableViewCell.swift
//  PlopIt
//
//  Created by Raeein Bagheri on 2022-03-26.
//

import UIKit
import FirebaseStorage

class HeaderImageTableViewCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var restaurantImage: UIImageView!
    @IBOutlet weak var editButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpImageView()
    }
    
    func setUpImageView() {
        restaurantImage.layer.cornerRadius = 10
        restaurantImage.contentMode = .scaleToFill
    }
    
    func update(withRestaurantData data: Restaurant, title: String) {
        self.title.text = title
        self.restaurantImage.image = UIImage(named: "restaurantDefault")
        if data.restaurantHeaderImageURL != nil {
            let gsReference = Storage.storage().reference(forURL: data.restaurantHeaderImageURL!)
            gsReference.getData(maxSize: 1 * 1024 * 1024) { data, error in
                if let error = error {
                    print(error)
                } else {
                    let image = UIImage(data: data!)
                    self.restaurantImage.image = image
                }
            }
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
