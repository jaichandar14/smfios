//
//  UserEntry.swift
//  EPM
//
//  Created by lavanya on 02/11/21.
//

import Foundation

class UserEntry : Decodable{
    let firstName,lastName,email,mobileNumber : String
   /* enum CodingKeys: String, CodingKey {
        case firstName = ""
        case lastName = ""
        case email = ""
        case mobileNumber = ""
    }*/
}
