//
//  LoginViewController.swift
//  SMF-iOS
//
//  Created by Swapnil_Dhotre on 4/24/22.
//

import UIKit
import Amplify
import AWSCognitoIdentityProvider
import AWSMobileClient
import AmplifyPlugins



class LoginViewController: BaseViewController {
    func styleUI() {
        // add Stubs
    }
    
    func setDataToUI() {
        // add Stubs
    }
    
    
    var loginViewModel: LoginViewModel!
    
    @IBOutlet weak var mobileNoBorderView: UIView!
    @IBOutlet weak var lblSignIn: UILabel!
    @IBOutlet weak var lblMobile: UILabel!
    @IBOutlet weak var lblMobileError: UILabel!
    @IBOutlet weak var txtMobileNo: UITextField!
    @IBOutlet weak var mobileNoStackView: UIStackView!
    
    @IBOutlet weak var lblOr: UILabel!
    
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblEmailError: UILabel!
    @IBOutlet weak var txtEmail: UITextField!
    
    @IBOutlet weak var dropDownView: UIView!
    @IBOutlet weak var flagImageView: UIImageView!
    @IBOutlet weak var lblCountryCode: UILabel!
    @IBOutlet weak var downArrowImageView: UIImageView!
    @IBOutlet weak var btnDropDownOverlay: UIButton!
    
    @IBOutlet weak var flagView: UIView!
    @IBOutlet weak var fieldsContainerView: UIView!
    @IBOutlet weak var btnSignIn: UIButton!
    @IBOutlet weak var countrySelectionWidthConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = _theme.primaryColor
        loginViewModel = LoginViewModel(loginModel: LoginModel())
        
        setUpTextFields()
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.fieldsContainerView.roundCorners([.topLeft, .topRight], radius: 20)
    }
    
    func backButtonAction(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func networkChangeListener(connectivity: Bool, connectionType: String?) {
        print("Connectivity:: \(connectivity) connect type:: \(connectionType ?? "")")
    }
    
    func showDropDown() {
        let countryPicker = CountryPickerViewController()
        countryPicker.countryPicked = { (country) in
            if let data = try? JSONEncoder().encode(country) {
                let string = String(data: data, encoding: .utf8)!
                UserDefault[key: .countrySelection] = string
            }
            
            self.loginViewModel.countryCode = country.dialCode
            self.loginViewModel.flagImage = Country.flag(forCountryCode: (country.iso2)).image()
            self.setCountryCode()
        }
        
        self.present(countryPicker, animated: true, completion: nil)
    }
    
    func setCountryCode() {
        self.lblCountryCode.text = loginViewModel.countryCode
        self.flagImageView.image = loginViewModel.flagImage
    }
    
    func setUpTextFields() {
        if txtMobileNo == nil {
            return
        }
        
        setTextField(self.mobileNoBorderView, isValid: true)
        
        txtMobileNo.setLeftPaddingPoints(10)
        txtMobileNo.setRightPaddingPoints(10)
        txtMobileNo.keyboardType = .phonePad
        txtMobileNo.delegate = self
        
        setTextField(txtEmail, isValid: true)
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
        AmplifyLoginUtility.signOut { status in
            print("Signout Status \(status)")
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
        
        CVProgressHUD.showProgressHUD(title: "Please wait...")
        AmplifyLoginUtility.fetchAuthToken { [weak self] authenticationStatus in
            switch authenticationStatus {
            case .authenticationFailed:
                DispatchQueue.main.async {
                    self?.needAuthentication()
                }
            case .authenticationSuccess:
                self?.alreadySignIn()
            }
        }
    }
    
    func needAuthentication() {
        let mobileNo = self.txtMobileNo.text ?? ""
        let emailId = self.txtEmail.text ?? ""//"vigneshwaran.p996@gmail.com"//jaichandar14@gmail.com
        let countryCodeMobileNo = "\(self.loginViewModel.countryCode)\(mobileNo)"
        let urlEncodedString = countryCodeMobileNo.replacingOccurrences(of: "+", with: "%2B")
        
        let param = ["loginName": mobileNo == "" ? emailId : urlEncodedString]
        
        print("Is connected: \(Connectivity.shared.isConnected)")
        LoginModel().callLoginAPI(id: "loginAPI", method: .GET, parameters: param, priority: .high) { [weak self] response, result, error in
            
            print("Response \(String(describing: response))")
            
            if let userName = response?[keyPath: "data.userName"] as? String {
                AmplifyLoginUtility.signIn(withUserId: userName) { [weak self] loginStatus in
                    switch loginStatus {
                    case .alreadyLogin:
                        self?.alreadySignIn()
                        break
                    case .signedInSuccess:
                        DispatchQueue.main.async {
                            CVProgressHUD.hideProgressHUD()
                            self?.navigationController?.pushViewController(OTPScreenViewController(), animated: true)
                        }
                        break
                    case .signedInFailed(_):
                        DispatchQueue.main.async {
                            CVProgressHUD.hideProgressHUD()
                            self?.showAlert(withTitle: "Sign in failed", withMessage: "Something went wrong. Please try again!", isDefault: true, actions: [])
                        }
                        break
                    default:
                        print("Case not handled")
                    }
                }
            } else {
                DispatchQueue.main.async {
                    CVProgressHUD.hideProgressHUD()
                    self?.showAlert(withTitle: "Sign in failed", withMessage: "Something went wrong. Please try again!", isDefault: true, actions: [])
                }
            }
        }
    }
    
    func alreadySignIn() {
        DispatchQueue.main.async {
            AmplifyLoginUtility.updateUserData()
            
            if AmplifyLoginUtility.user != nil {
                
                CVProgressHUD.hideProgressHUD()
                self.navigationController?.setViewControllers([LandingViewController.create()], animated: true)
                
            } else {
                AmplifyLoginUtility.fetchUserCredential { [weak self] userCreds in
                    switch userCreds {
                    case .success(_):
                        DispatchQueue.main.async {
                            CVProgressHUD.hideProgressHUD()
                            self?.navigationController?.setViewControllers([LandingViewController.create()], animated: true)
                        }
                        break
                    case .failure:
                        DispatchQueue.main.async {
                            CVProgressHUD.hideProgressHUD()
                            self?.showAlert(withTitle: "Sign in failed", withMessage: "Something went wrong. Please try again!", isDefault: true, actions: [])
                        }
                        break
                    }
                }
            }
        }
    }
    
    @IBAction func btnDropDownAction(_ sender: Any) {
        showDropDown()
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
            self.setTextField(self.mobileNoBorderView, isValid: !isError)
            self.lblMobileError.isHidden = !isError
        })
    }
    
    func setTextField(_ view: UIView, isValid: Bool) {
        view.layer.masksToBounds = true
        view.layer.borderWidth = 2
        view.layer.cornerRadius = 2
        view.layer.borderColor = isValid ? UIColor.lightGray.cgColor : _theme.errorColor.cgColor
    }
    
    func setSignInButton(enabled: Bool) {
        self.btnSignIn.isEnabled = enabled
        self.btnSignIn.backgroundColor = enabled ? _theme.accentColor : _theme.accentDisabledColor
    }
}
