//
//  String+validation.swift
//  EPM
//
//  Created by lavanya on 29/10/21.
//

import Foundation

extension String {
    public func validateName() ->Bool {
        // Length be 18 characters max and 3 characters minimum, you can always modify.
        let nameRegex = "^\\w{3,25}$"
        let trimmedString = self.trimmingCharacters(in: .whitespaces)
        let validateName = NSPredicate(format: "SELF MATCHES %@", nameRegex)
        let isValidateName = validateName.evaluate(with: trimmedString)
        return isValidateName
    }
    public func validateMobileNumber() -> Bool {
        let phoneNumberRegex = "^[6-9]\\d{9}$"
        let trimmedString = self.trimmingCharacters(in: .whitespaces)
        let validatePhone = NSPredicate(format: "SELF MATCHES %@", phoneNumberRegex)
        let isValidPhone = validatePhone.evaluate(with: trimmedString)
        return isValidPhone
    }
    public func validateEmailId() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let trimmedString = self.trimmingCharacters(in: .whitespaces)
        let validateEmail = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let isValidateEmail = validateEmail.evaluate(with: trimmedString)
        return isValidateEmail
    }
}
