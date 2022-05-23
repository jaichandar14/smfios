//
//  LoginViewController.swift
//  SMF-iOS
//
//  Created by Swapnil_Dhotre on 4/24/22.
//

import UIKit
import DropDown
import Amplify

class LoginViewController: BaseViewController {
    func styleUI() {
        // add Stubs
    }
    
    func setDataToUI() {
        // add Stubs
    }
    
    
    var loginViewModel: LoginViewModel!
    
    @IBOutlet weak var lblSignIn: UILabel!
    @IBOutlet weak var lblMobile: UILabel!
    @IBOutlet weak var lblMobileError: UILabel!
    @IBOutlet weak var txtMobileNo: UITextField!
    
    @IBOutlet weak var lblOr: UILabel!
    
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblEmailError: UILabel!
    @IBOutlet weak var txtEmail: UITextField!
    
    var dropDown: DropDown!
    @IBOutlet weak var dropDownView: UIView!
    @IBOutlet weak var flagImageView: UIImageView!
    @IBOutlet weak var lblCountryCode: UILabel!
    @IBOutlet weak var downArrowImageView: UIImageView!
    @IBOutlet weak var btnDropDownOverlay: UIButton!
    
    @IBOutlet weak var btnSignIn: UIButton!
    @IBOutlet weak var countrySelectionWidthConstraint: NSLayoutConstraint!
       
    override func viewDidLoad() {
        super.viewDidLoad()

        loginViewModel = LoginViewModel(loginModel: LoginModel())
        
        setUpTextFields()
        setUpDropDown()
        setCountryCode()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setNavBar(hidden: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        setNavBar(hidden: false)
    }
    
    func networkChangeListener(connectivity: Bool, connectionType: String?) {
        print("Connectivity:: \(connectivity) connect type:: \(connectionType ?? "")")
    }
    
    func setUpDropDown() {
        
        DropDown.startListeningToKeyboard()
        DropDown.appearance().backgroundColor = UIColor.white
        
        dropDown = DropDown()
        dropDown.anchorView = dropDownView
        dropDown.width = 200
        dropDown.dataSource = loginViewModel.countries.map({ country in
            return country.title
        })
        
        self.btnDropDownOverlay.setTitle("", for: .normal)
        self.btnDropDownOverlay.backgroundColor = .clear
        
        self.dropDown.cellNib = UINib(nibName: "CountryFlagTableViewCell", bundle: nil)
        
        self.dropDown.customCellConfiguration = { [unowned self] (index: Index, item: String, cell: DropDownCell) in
            guard let cell = cell as? CountryFlagTableViewCell else { return }
            
            cell.imageViewFlag.image = Country.flag(forCountryCode: (self.loginViewModel.countries[index].iso2)).image()
            cell.optionLabel.text = item
        }
                
        self.dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected item: \(item) index:: \(index)")
            if let data = try? JSONEncoder().encode(self.loginViewModel.countries[index]) {
                let string = String(data: data, encoding: .utf8)!
                UserDefault[key: .countrySelection] = string
            }
            
            loginViewModel.countryCode = self.loginViewModel.countries[index].dialCode
            loginViewModel.flagImage = Country.flag(forCountryCode: (self.loginViewModel.countries[index].iso2)).image()
            setCountryCode()
        }
    }
    
    func setCountryCode() {
        self.lblCountryCode.text = loginViewModel.countryCode
        self.flagImageView.image = loginViewModel.flagImage
    }
        
    func setUpTextFields() {
        if txtMobileNo == nil {
            return
        }
        
        setTextField(txtMobileNo, isValid: true)
        txtMobileNo.setLeftPaddingPoints(self.countrySelectionWidthConstraint.constant + 30)
        txtMobileNo.setRightPaddingPoints(10)
        txtMobileNo.keyboardType = .phonePad
        txtMobileNo.delegate = self

        setTextField(txtEmail, isValid: true)
        txtEmail.layer.masksToBounds = true
        txtEmail.layer.borderWidth = 1
        txtEmail.layer.cornerRadius = 8
        txtEmail.layer.borderColor = UIColor.lightGray.cgColor
        
        txtEmail.setLeftPaddingPoints(10)
        txtEmail.setRightPaddingPoints(10)
        txtEmail.keyboardType = .emailAddress
        txtEmail.delegate = self
        
        lblMobileError.isHidden = true
        lblEmailError.isHidden = true
        lblMobileError.textColor = _theme.errorColor
        lblEmailError.textColor = _theme.errorColor
        
        lblMobileError.text = "   \(ErrorConstant.validMobileNoError)"
        lblEmailError.text = "   \(ErrorConstant.validEmailError)"
        
        txtMobileNo.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        txtEmail.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        
        setSignInButton(enabled: false)
    }
    
    @IBAction func signOut(_ sender: UIButton) {
        Amplify.Auth.signOut(options: .init(globalSignOut: true)) { result in
            switch result {
            case .success():
                print("Successfullly signed out")
            case .failure(let error):
                print("Error in signing out \(error)")
            }
        }
    }
    @IBAction func checkStatus(_ sender: Any) {
        Amplify.Auth.fetchAuthSession(options: nil) { result in
            switch result {
            case .success(let authSession):
                print("Already Signed in user:: ")
            case .failure(let error):
                print("Failed to signed in")
                
            }
        }
    }
    @IBAction func btnSignInAction(_ sender: Any) {
        self.hideKeyboard()
        
        self.loginViewModel.getAppAuthenticatedUser { user in
            DispatchQueue.main.async {
                APIConfig.user = user
                self.navigationController?.setViewControllers([DashboardViewController.create()], animated: true)
            }
        }
                
        /*let mobileNo = self.txtMobileNo.text ?? ""
        let emailId = "vigneshwaran.p996@gmail.com"//"jaichandar14@gmail.com" //self.txtEmail.text ?? ""//
        
        let param = ["loginName": mobileNo == "" ? emailId : mobileNo]
        
        print("Is connected: \(Connectivity.shared.isConnected)")
        LoginModel().callLoginAPI(id: "loginAPI", method: .GET, parameters: param, priority: .high) { response, result, error in
                    
            print("Response \(String(describing: response))")
            if let userName = response?[keyPath: "data.userName"] as? String {
                Amplify.Auth.signIn(username: userName) { result in
                    switch result {
                    case .success:
                        print("Sign in succeeded")
                        DispatchQueue.main.async {
                            self.navigationController?.pushViewController(OTPScreenViewController(), animated: true)
                        }
                    case .failure(let error):
                        print("Sign in failed \(error)")
                        if let err = error.underlyingError as NSError? {
                            print("Cast to nserror:", err)
                        }
                    }
                }
//                Amplify.Auth.signIn(username: "chan977295jai", password: "1234") { result in
//                    switch result {
//                    case .success:
//                        print("Sign in succeeded")
//                        DispatchQueue.main.async {
//                            self.navigationController?.pushViewController(OTPScreenViewController(), animated: true)
//                        }
//                    case .failure(let error):
//                        print("Sign in failed \(error)")
//                        if let err = error.underlyingError as NSError? {
//                            print("Cast to nserror:", err)
//                        }
//                    }
//                }
            }
        }*/
    }
    
    @IBAction func btnDropDownAction(_ sender: Any) {
        self.dropDown.show()
    }
}

extension LoginViewController: UITextFieldDelegate {
    @objc func textFieldDidChange(_ textField: UITextField) {
        if textField == self.txtMobileNo {
            self.loginViewModel.setMobileNo(text: textField.text)
            self.setMobileNoError(textField, isError: !self.loginViewModel.isValidMobileNo())
        } else if textField == self.txtEmail {
            self.loginViewModel.setEmail(text: textField.text)
            self.setEmailError(textField, isError: !self.loginViewModel.isValidEmail())
        }
    }
    
    func setEmailError(_ textField: UITextField, isError: Bool) {
        UIView.animate(withDuration: 0.25, animations: {
            self.setSignInButton(enabled: !isError)
            self.setTextField(textField, isValid: !isError)
            self.lblEmailError.isHidden = !isError
        })
    }
    
    func setMobileNoError(_ textField: UITextField, isError: Bool) {
        UIView.animate(withDuration: 0.25, animations: {
            self.setSignInButton(enabled: !isError)
            self.setTextField(textField, isValid: !isError)
            self.lblMobileError.isHidden = !isError
        })
    }
    
    func setTextField(_ textField: UITextField, isValid: Bool) {
        textField.layer.masksToBounds = true
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 8
        textField.layer.borderColor = isValid ? UIColor.lightGray.cgColor : _theme.errorColor.cgColor
    }
    
    func setSignInButton(enabled: Bool) {
        self.btnSignIn.isEnabled = enabled
        self.btnSignIn.backgroundColor = enabled ? _theme.buttonColor : _theme.buttonDisabledColor
    }
}
