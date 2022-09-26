//
//  OTPScreenViewController.swift
//  SMF-iOS
//
//  Created by Swapnil_Dhotre on 5/1/22.
//

import UIKit
import Amplify

class OTPScreenViewController: BaseViewController {
    func styleUI() {
        // add Stubs
    }
    
    func setDataToUI() {
        // add Stubs
    }
    
    
    @IBOutlet weak var fieldsContainerView: UIView!
    @IBOutlet weak var lblTimerUpdate: UILabel!
    @IBOutlet weak var lblOTPVerification: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblEnterOTP: UILabel!
    @IBOutlet weak var lblDidntReceiveOTP: UILabel!
    
    @IBOutlet weak var btnResend: UIButton!
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var otpView: UIView!
    
    private var _otpStackView: OTPStackView!
    private var _timer: Timer?
    
    var secondsRemaining = 30
    var userName: String = ""
    
    var resendCounter = 0;
    var clearFields: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpLabel()
        
        scheduleTimer()
        
        self.view.backgroundColor = _theme.primaryColor
        
        self._otpStackView = OTPStackView()
        self.otpView.addSubview(self._otpStackView)
        self.setOTPView()
        self._otpStackView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.setNavBar(hidden: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.setNavBar(hidden: false)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.fieldsContainerView.roundCorners([.topLeft, .topRight], radius: 20)
    }
    
    func backButtonAction(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func networkChangeListener(connectivity: Bool, connectionType: String?) {
        print("NetworkChange")
    }
    
    func scheduleTimer() {
        self.btnResend.isEnabled = false
        _timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { (Timer) in
            if self.secondsRemaining > 0 {
                self.lblTimerUpdate.text = "Click resend in 00:\(String(format: "%02d", self.secondsRemaining))"
                self.secondsRemaining -= 1
            } else {
                self.secondsRemaining = 30
                self._timer?.invalidate()
                self.lblTimerUpdate.text = "Click resend in 00:00"
                self.btnResend.isEnabled = true
            }
        }
    }
    
    func setOTPView() {
        self.otpView.addConstraint(NSLayoutConstraint(item: _otpStackView!, attribute: .centerX, relatedBy: .equal, toItem: self.otpView, attribute: .centerX, multiplier: 1.0, constant: 1))
        self.otpView.addConstraint(NSLayoutConstraint(item: _otpStackView!, attribute: .centerY, relatedBy: .equal, toItem: self.otpView, attribute: .centerY, multiplier: 1.0, constant: 1))
        self._otpStackView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        self._otpStackView.spacing = 20
        self._otpStackView.textColor = _theme.textColor
        self._otpStackView.textBackgroundColor = _theme.backgroundColor
        self._otpStackView.inactiveFieldBorderColor = _theme.textGreyColor
        self._otpStackView.activeFieldBorderColor = _theme.textColor
        self._otpStackView.radius = 10
    }
    
    func setUpLabel() {
        lblOTPVerification.textColor = _theme.textColor
        lblDescription.textColor = _theme.textGreyColor
        lblEnterOTP.textColor = _theme.textColor
        lblDidntReceiveOTP.textColor = _theme.textColor
        lblTimerUpdate.textColor = _theme.textColor
        
        self.lblTimerUpdate.text = ""
        
        self.setButton(self.btnSubmit, enabled: false)
        self.btnResend.setTitleColor(UIColor.systemBlue, for: .normal)
        self.btnResend.setTitleColor(UIColor.systemBlue.withAlphaComponent(0.5), for: .disabled)
        self.btnResend.backgroundColor = UIColor.clear
    }
    
    @IBAction func btnResendTapped(_ sender: UIButton) {
        print("Resend")
        
        self.resendCounter += 1
        if self.resendCounter > 5 {
            self.btnResend.isEnabled = false
            if let view = UIApplication.shared.windows.last {
                view.makeToast(ToastConstant.resendClickMultipleTimes, duration: 3.0)
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.clearFields?()
                self.navigationController?.popViewController(animated: true)
            }
            return
        } else {
            scheduleTimer()
            if let view = UIApplication.shared.windows.last {
                view.makeToast(ToastConstant.resendOTP)
            }
        }
        
        CVProgressHUD.showProgressHUD(title: "Please wait...")
        
        AmplifyLoginUtility.signOut { [weak self] loginStatus in
            print("Logout status:: \(loginStatus)")
            
            AmplifyLoginUtility.signIn(withUserId: self?.userName ?? "") { [weak self] loginStatus in
                switch loginStatus {
                case .alreadyLogin:
                    self?.alreadySignIn()
                    break
                case .signedInSuccess:
                    DispatchQueue.main.async {
                        CVProgressHUD.hideProgressHUD()
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
    
    @IBAction func btnSubmitTapped(_ sender: UIButton) {
        let otp = self._otpStackView.getOTP()
        
        CVProgressHUD.showProgressHUD(title: "Please wait...")
        AmplifyLoginUtility.confirmSignIn(otp: otp) { [weak self] confirmation in
            switch confirmation {
            case .success:
                self?.updateOTPStatus(status: true)
                self?.fetchAuthToken()
                break
            case .failure:
                DispatchQueue.main.async {
                    CVProgressHUD.hideProgressHUD()
                    
                    self?.updateOTPStatus(status: false)
                    self?._otpStackView.textFieldsCollection.forEach({ field in
                        field.text = ""
                    })
                    self?._otpStackView.textFieldsCollection.first?.becomeFirstResponder()
                }
                break
            }
        }
    }
    
    func updateOTPStatus(status: Bool) {
        let param: [String: Any] = [
            "isSuccessful": "\(status)",
            "userName": self.userName
        ]
        OTPViewModel().loginAPIFailed(id: "OTP failure", method: .GET, parameters: param, priority: .high) { [weak self] response, result, error in
            
            print("Response:: \(response)")
            if let error = response?["errorMessage"] as? String {
                self?.showAlert(withTitle: "OTP Failure", withMessage: error, isDefault: false, actions: [
                    UIAlertAction(title: "OK", style: .default, handler: { action in
                        AmplifyLoginUtility.signOut { status in
                            print("Logout Status:: \(status)")
                            DispatchQueue.main.async {
                                self?.navigationController?.popViewController(animated: true)
                            }
                        }
                    })
                ])
            } else {
                if (!status) {
                    self?.showAlert(withTitle: "OTP failed", withMessage: "OTP invalid!", isDefault: true, actions: [])
                }
            }
        }
    }
    
    func fetchAuthToken() {
        AmplifyLoginUtility.fetchAuthToken { [weak self] status in
            switch status {
            case .authenticationSuccess(_):
                AmplifyLoginUtility.updateUserData()
                self?.fetchUserCredential()
                break
            case .authenticationFailed:
                DispatchQueue.main.async {
                    CVProgressHUD.hideProgressHUD()
                    self?.showAlert(withTitle: "OTP failed", withMessage: "Failed to sign-in", isDefault: false, actions: [
                        UIAlertAction(title: "OK", style: .default, handler: { action in
                            AmplifyLoginUtility.signOut { status in
                                print("Logout Status:: \(status)")
                            }
                            //                            self?.navigationController?.popViewController(animated: true)
                        })
                    ])
                }
                break
            }
        }
    }
    
    func fetchUserCredential() {
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
                    self?.showAlert(withTitle: "OTP failed", withMessage: "Failed to sign-in", isDefault: false, actions: [
                        UIAlertAction(title: "OK", style: .default, handler: { action in
                            self?.navigationController?.popViewController(animated: true)
                        })
                    ])
                }
                break
            }
        }
    }
}

extension OTPScreenViewController: OTPDelegate {
    func didChangeValidity(isValid: Bool) {
        setButton(self.btnSubmit, enabled: isValid)
    }
    
    func setButton(_ button: UIButton, enabled: Bool) {
        button.isEnabled = enabled
        button.backgroundColor = enabled ? _theme.accentColor : _theme.accentDisabledColor
    }
}
