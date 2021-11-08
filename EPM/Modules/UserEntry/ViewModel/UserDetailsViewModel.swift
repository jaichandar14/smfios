//
//  UserDetailsViewModel.swift
//  EPM
//
//  Created by lavanya on 05/11/21.
//

import Foundation
class UserDetailsViewModel : NSObject {
    
    //private var apiService : APIService!
    private(set) var userData : UserEntry! {
        didSet {
            self.bindUserEntryViewModelToController()
        }
    }
    
    var bindUserEntryViewModelToController : (() -> ()) = {}
    
    override init() {
        super.init()
        //self.apiService =  APIService()
        callFuncToGetEmpData()
    }
    
    func callFuncToGetEmpData() {
      /* self.apiService.apiToGetEmployeeData { (userData) in
            self.userData = userData
        }*/
    }
}
