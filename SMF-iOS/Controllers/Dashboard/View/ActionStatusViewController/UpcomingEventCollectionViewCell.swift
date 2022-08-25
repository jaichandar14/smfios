//
//  UpcomingEventCollectionViewCell.swift
//  SMF-iOS
//
//  Created by Swapnil_Dhotre on 6/19/22.
//

import UIKit

class UpcomingEventCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var eventImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.eventImageView.layer.cornerRadius = 10
        self.eventImageView.setShadowAndRoundedCorner(borderWidth: 0, borderColor: UIColor.gray.withAlphaComponent(0.3).cgColor, shadowColor: UIColor.gray.cgColor, offset: CGSize(width: 0.0, height: 2.0), opacity: 0.4, radius:  3)
    }

}
