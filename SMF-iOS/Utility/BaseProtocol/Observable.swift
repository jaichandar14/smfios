//
//  Dynamic.swift
//  SMF-iOS
//
//  Created by Swapnil_Dhotre on 5/19/22.
//

import Foundation

class Observable<T> {
    typealias Listener = (T) -> ()
    
    var listener: Listener?
    
    func bind(_ listener: Listener?) {
        self.listener = listener
    }
    
    func bindAndFire(_ listener: Listener?) {
        self.listener = listener
        listener?(value)
    }
    
    var value: T {
        didSet {
            listener?(value)
        }
    }
    
    init(_ v: T) {
        value = v
    }
}
