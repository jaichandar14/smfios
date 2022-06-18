//
//  InitialViewController.swift
//  SMF-iOS
//
//  Created by Swapnil_Dhotre on 4/23/22.
//

import UIKit
import Amplify

class InitialViewController: BaseViewController {
    @IBOutlet weak var lblEventPlanner: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var getStarted: UIButton!
    
    @IBOutlet weak var btnGetStarted: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setNavBar(hidden: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        setNavBar(hidden: false)
    }
    
    func styleUI() {
        let eventAttributed = NSMutableAttributedString(string: "Event", attributes: [NSAttributedString.Key.font: _theme.playballFont(size: 30), NSAttributedString.Key.foregroundColor: _theme.primaryColor])
        let plannerAttributed = NSMutableAttributedString(string: " planner", attributes: [NSAttributedString.Key.font: _theme.muliFont(size: 23, style: .muli), NSAttributedString.Key.foregroundColor: _theme.textColor])
        
        let attributed = NSMutableAttributedString()
        attributed.append(eventAttributed)
        attributed.append(plannerAttributed)
        self.lblEventPlanner.attributedText = NSAttributedString(attributedString: attributed)
        
        self.btnGetStarted.backgroundColor = _theme.accentColor
        self.btnGetStarted.titleLabel?.font = _theme.muliFont(size: 18, style: .muliBold)
        self.btnGetStarted.setTitleColor(UIColor.white, for: .normal)
    }
    
    func setDataToUI() {
        // add Stubs
    }
    
    func backButtonAction(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func networkChangeListener(connectivity: Bool, connectionType: String?) {
        print("NetworkChange")
    }

    @IBAction func btnGetStartedAction(_ sender: Any) {
//        let email = "swapnildhotre09@gmail.com"
//        let userAttributes = [AuthUserAttribute(.email, value: email)]
//        let options = AuthSignUpRequest.Options(userAttributes: userAttributes)
//        Amplify.Auth.signUp(username: "swapnildhotre", password: "Swapnil_999", options: options) { result in
//            switch result {
//            case .success(let signUpResult):
//                if case let .confirmUser(deliveryDetails, _) = signUpResult.nextStep {
//                    print("Delivery details \(String(describing: deliveryDetails))")
//                } else {
//                    print("SignUp Complete")
//                }
//
//                DispatchQueue.main.async {
//                    self.navigationController?.pushViewController(LoginViewController(), animated: true)
//                }
//
//            case .failure(let error):
//                print("An error occurred while registering a user \(error)")
//            }
//        }
        
//        Amplify.Auth.confirmSignUp(for: "swapnildhotre", confirmationCode: "686658") { result in
//                switch result {
//                case .success:
//                    print("Confirm signUp succeeded")
//                case .failure(let error):
//                    print("An error occurred while confirming sign up \(error)")
//                }
//            }
        
        self.navigationController?.pushViewController(LoginViewController(), animated: true)
    }
}
