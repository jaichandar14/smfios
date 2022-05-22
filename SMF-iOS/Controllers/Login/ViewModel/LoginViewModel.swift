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
    
    var model: LoginModel {
        return _loginModel
    }
    
    init(loginModel: LoginModel) {
        self._loginModel = loginModel
        
        countries = Country.getCountries()
        
        if let selectedCountry = loginModel.selectedCountry {
            countryCode = selectedCountry.dialCode
            flagImage = Country.flag(forCountryCode: (loginModel.selectedCountry?.iso2 ?? "")).image()
        } else {
            countryCode = countries.first!.dialCode
            flagImage = Country.flag(forCountryCode: countries.first!.iso2).image()
        }
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
    
    func getAppAuthenticatedUser(completion: @escaping (User) -> Void) {
        _loginModel.callAppAuthenticatedUser(id: "Auth", method: .GET, parameters: nil, priority: .high) { response, result, error in
            print("ASDs")
            if let responseData = response?["data"] as? [String: Any], let data = try? JSONSerialization.data(withJSONObject: responseData, options: []) {
                if let user = try? JSONDecoder().decode(User.self, from: data) {
                    completion(user)
                }
            }
        }
    }
}
