//
//  LoadingSplashViewController.swift
//  SMF-iOS
//
//  Created by Swapnil_Dhotre on 8/10/22.
//

import UIKit

class LoadingSplashViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Check if token expired and then navigate - TokenExpired fetch new token")
        AmplifyLoginUtility.fetchAuthToken { authStatus in
            DispatchQueue.main.async {
                switch authStatus {
                case .authenticationSuccess(_):
                    self.authenticationSuccess()
                case .authenticationFailed:
                    Util.setLoginController(navigationController: self.navigationController!)
                }
            }
        }
    }
    
    func authenticationSuccess() {
        AmplifyLoginUtility.updateUserData()
        if AmplifyLoginUtility.user != nil {
            Util.setDashboardController(navigationController: self.navigationController!)
        } else {
            AmplifyLoginUtility.fetchUserCredential { userCreds in
                DispatchQueue.main.async {
                    switch userCreds {
                    case .success(_):                        
                        Util.setDashboardController(navigationController: self.navigationController!)
                        break
                    case .failure:
                        Util.setLoginController(navigationController: self.navigationController!)
                        break
                    }
                }
            }
        }
    }
}
