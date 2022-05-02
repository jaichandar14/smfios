//
//  CountryFlagTableViewCell.swift
//  SMF-iOS
//
//  Created by Swapnil_Dhotre on 4/25/22.
//

import UIKit
import DropDown

class CountryFlagTableViewCell: DropDownCell {

    @IBOutlet weak var imageViewFlag: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
