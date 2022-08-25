//
//  UpdateEventImageObject.swift
//  SMF-iOS
//
//  Created by Swapnil_Dhotre on 6/20/22.
//

import UIKit

class UpdateEventImageObject: Hashable {
    var image: UIImage!
    let url: URL!
    let identifier = UUID()
    
    var indexPath: IndexPath!
    var isLoaded = false
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
    
    static func == (lhs: UpdateEventImageObject, rhs: UpdateEventImageObject) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    
    init(image: UIImage, url: URL) {
        self.image = image
        self.url = url
    }
}
