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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpLabel()
        
        scheduleTimer()
        
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
                self.lblDidntReceiveOTP.text = "Didn't receive OTP? Click Resend in 00:\(String(format: "%02d", self.secondsRemaining))"
                self.secondsRemaining -= 1
            } else {
                self.secondsRemaining = 30
                self._timer?.invalidate()
                self.lblDidntReceiveOTP.text = "Didn't receive OTP? Click Resend in 00:00"
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
        
        self.btnResend.setTitleColor(UIColor.systemBlue, for: .normal)
        self.btnResend.backgroundColor = UIColor.clear
    }
    
    @IBAction func btnResendTapped(_ sender: UIButton) {
        print("Resend")
        scheduleTimer()
    }
    
    @IBAction func btnSubmitTapped(_ sender: UIButton) {
        let otp = self._otpStackView.getOTP()
//        self._otpStackView.setAllFieldColor(color: _theme.errorColor)
        Amplify.Auth.confirmSignIn(challengeResponse: otp) { result in
                switch result {
                case .success(let signInResult):
                    if signInResult.isSignedIn {
                        print("Confirm sign in succeeded. The user is signed in.")
                    } else {
                        print("Confirm sign in succeeded.")
                        print("Next step: \(signInResult.nextStep)")
                        // Switch on the next step to take appropriate actions.
                        // If `signInResult.isSignedIn` is true, the next step
                        // is 'done', and the user is now signed in.
                    }
                    self.navigationController?.pushViewController(DashboardViewController.create(), animated: true)
                case .failure(let error):
                    print("Confirm sign in failed \(error)")
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
        button.backgroundColor = enabled ? _theme.buttonColor : _theme.buttonDisabledColor
    }
}
