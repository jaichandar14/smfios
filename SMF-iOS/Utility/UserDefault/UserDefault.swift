//
//  UserDefault.swift
//  SMF-iOS
//
//  Created by Swapnil_Dhotre on 5/18/22.
//

import Foundation

var UserDefault = _UserDefault()

enum UserDefaultKeys: String {
    case selectedTheme
    case countrySelection
    case userData
}


class _UserDefault {
    subscript(key key: UserDefaultKeys) -> Any? {
        get {
            return UserDefaults.standard.value(forKey: key.rawValue)
        }
        
        set(newValue) {
            UserDefaults.standard.set(newValue, forKey: key.rawValue)
        }
    }
    
    
    subscript(intValueFor intKey: UserDefaultKeys) -> Int {
        get {
            return UserDefaults.standard.integer(forKey: intKey.rawValue)
        }
        
        set(newValue) {
            UserDefaults.standard.set(newValue, forKey: intKey.rawValue)
        }
    }
    
    subscript(stringValueFor stringKey: UserDefaultKeys) -> String? {
        get {
            return UserDefaults.standard.string(forKey: stringKey.rawValue)
        }
        
        set(newValue) {
            UserDefaults.standard.set(newValue, forKey: stringKey.rawValue)
        }
    }
    
    subscript(boolValueFor boolKey: UserDefaultKeys) -> Bool {
        get {
            return UserDefaults.standard.bool(forKey: boolKey.rawValue)
        }
        
        set(newValue) {
            UserDefaults.standard.set(newValue, forKey: boolKey.rawValue)
        }
    }
}
