//
//  InfoDetailsTableViewCell.swift
//  PlopIt
//
//  Created by Max Fritzhand on 4/23/22.
//

import UIKit

class InfoDetailsTableViewCell: UITableViewCell {

    @IBOutlet weak var detailImage: UIImageView!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var rightLabel: UILabel!
    @IBOutlet weak var rowLabel: UILabel!
    
    @IBOutlet weak var plusSign: UIImageView!
    
    @IBOutlet weak var detailField: UILabel!
    
    @IBOutlet weak var sundayHours: UILabel!
    @IBOutlet weak var mondayHours: UILabel!
    @IBOutlet weak var tuesdayHours: UILabel!
    @IBOutlet weak var wednesdayHours: UILabel!
    @IBOutlet weak var thursdayHours: UILabel!
    @IBOutlet weak var fridayHours: UILabel!
    @IBOutlet weak var saturdayHours: UILabel!

    @IBOutlet weak var mondayView: UIStackView!
    @IBOutlet weak var tuesdayView: UIStackView!
    @IBOutlet weak var wednesdayView: UIStackView!
    @IBOutlet weak var thursdayView: UIStackView!
    @IBOutlet weak var fridayView: UIStackView!
    @IBOutlet weak var saturdayView: UIStackView!
    @IBOutlet weak var sundayView: UIStackView!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
    }
    
    func update(data: DetailRows){
    self.detailImage.image = data.image
    //self.plusSign.image = data.expand
    
        //self.rowLabel.text = data.title
       

    }
}
