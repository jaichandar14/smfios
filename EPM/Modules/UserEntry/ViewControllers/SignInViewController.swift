//
//  SignInViewController.swift
//  EPM
//
//  Created by lavanya on 02/11/21.
//

import UIKit
import FlagPhoneNumber

class SignInViewController: UIViewController {
    @IBOutlet weak var MobileTextField: FPNTextField!
    @IBOutlet weak var SignInButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        MobileTextField.delegate = self
        MobileTextField.placeholder = "Phone Number"
        MobileTextField.setCountries(including: [.FR, .ES, .IT, .BE, .LU, .DE])
    }
    @IBAction func signInAction(_ sender: Any) {
    }
    @IBAction func SignUpAction(_ sender: Any) {
        let controller = UIStoryboard.loadViewController(fromStoryBoard: .main, identifier: .signUpVC) as! SignUpViewController
        self.navigationController?.pushViewController(controller, animated: true)
    }
}
extension SignInViewController : FPNTextFieldDelegate {
    func fpnDidSelectCountry(name: String, dialCode: String, code: String) {
        
    }
    
    func fpnDidValidatePhoneNumber(textField: FPNTextField, isValid: Bool) {
        
    }
    
    func fpnDisplayCountryList() {
        
    }
    
    
}
