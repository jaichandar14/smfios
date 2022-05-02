//
//  LoginViewModel.swift
//  SMF-iOS
//
//  Created by Swapnil_Dhotre on 4/24/22.
//

import Foundation
import UIKit

final class LoginViewModel {
    
    var countries: [Country] = []
    var countryCode: String
    var flagImage: UIImage?
    
    private let _loginModel: LoginModel
    
    init(loginModel: LoginModel) {
        self._loginModel = loginModel
        
        countries = Country.getCountries()
        
        countryCode = loginModel.selectedCountry?.dialCode ?? ""
        flagImage = Country.flag(forCountryCode: (loginModel.selectedCountry?.iso2 ?? "")).image()
    }
    
    func setEmail(text: String?) {
        _loginModel.email = text
    }
    
    func getEmail() -> String? {
        return _loginModel.email
    }
    
    func setMobileNo(text: String?) {
        _loginModel.mobileNo = text
    }
    
    func getMobileNo() -> String? {
        return _loginModel.mobileNo
    }
    
    func isValidEmail() -> Bool {
        return (_loginModel.email ?? "").isValidEmail()
    }
    
    func isValidMobileNo() -> Bool {
        return (_loginModel.mobileNo ?? "").isValidMobileNo()
    }
}
