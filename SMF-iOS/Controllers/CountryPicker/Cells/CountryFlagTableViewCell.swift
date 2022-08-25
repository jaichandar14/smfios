//
//  CountryFlagTableViewCell.swift
//  SMF-iOS
//
//  Created by Swapnil_Dhotre on 8/23/22.
//

import UIKit

class CountryFlagTableViewCell: UITableViewCell {

    @IBOutlet weak var lblCountryName: UILabel!
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
