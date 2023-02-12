//
//  RestaurantTableViewCell.swift
//  PlopIt
//
//  Created by Raivis Olehno on 08/01/2022.
//

import UIKit
import Kingfisher
import FirebaseStorage

class RestaurantTableViewCell: UITableViewCell {
    
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var restaurantLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!    //currently is hidden
    @IBOutlet weak var staricon: UIImageView!  //currently is hidden
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var secondGenreLabel: UILabel!
    @IBOutlet weak var firstGenreLabel: UILabel!
    @IBOutlet weak var secondDot: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = .none
        mainView.addCornerRadius(value: 5)
        secondDot.isHidden = true
        staricon.isHidden = true
        ratingLabel.isHidden = true
        //distanceLabel.isHidden = true
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func update(withRestaurantData data: Restaurant) {
        var firstGenre = ""
        var secondGenre = ""
        
        self.mainImageView.image = UIImage(named: "restaurantDefault")
        if data.restaurantThumbnailImageURL != nil {
            let gsReference = Storage.storage().reference(forURL: data.restaurantThumbnailImageURL!)
            gsReference.getData(maxSize: 1 * 1024 * 1024) { data, error in
                if let error = error {
                    print(error)
                } else {
                    let image = UIImage(data: data!)
                    self.mainImageView.image = image
                }
            }
        }
        
        //this is supposed to show just Approved Restaurants on Home Page
        
        let isApproved = UserDefaults.standard.bool(forKey: "isApproved")
        if isApproved == true{
         //hide cell for restaurant that was not approved
            mainView.isHidden = false
        } else if isApproved == false{
          // mainView.isHidden = true
        }
        
        
        
        var firstSwitch = false
        
        for (genre, check) in data.restaurantGenre ?? [:] {
                if check == true {
                    if firstSwitch == false {
                        firstGenre = genre
                        firstSwitch = true
                    } else if firstSwitch == true {
                        secondGenre = genre
                        secondDot.isHidden = false
                    }
                }
        }
        
        restaurantLabel.text = data.restaurantName
        firstGenreLabel.text = firstGenre
        secondGenreLabel.text = secondGenre
        priceLabel.text = data.priceRange
        
    }
    
}
