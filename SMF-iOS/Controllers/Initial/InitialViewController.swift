//
//  InitialViewController.swift
//  SMF-iOS
//
//  Created by Swapnil_Dhotre on 4/23/22.
//

import UIKit
import Amplify

class InitialViewController: BaseViewController {
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
        let eventAttributed = NSMutableAttributedString(string: "Festo", attributes: [NSAttributedString.Key.font: _theme.playballFont(size: 30), NSAttributedString.Key.foregroundColor: _theme.primaryColor])
        let plannerAttributed = NSMutableAttributedString(string: " Cloud", attributes: [NSAttributedString.Key.font: _theme.muliFont(size: 23, style: .muli), NSAttributedString.Key.foregroundColor: _theme.textColor])
        
        let attributed = NSMutableAttributedString()
        attributed.append(eventAttributed)
        attributed.append(plannerAttributed)
//        self.lblEventPlanner.attributedText = NSAttributedString(attributedString: attributed)
        
        self.btnGetStarted.backgroundColor = _theme.accentColor
        self.btnGetStarted.titleLabel?.font = _theme.muliFont(size: 16, style: .muliBold)
        self.btnGetStarted.setTitleColor(UIColor.white, for: .normal)
        
        self.lblDescription.text = "View and act on event requests, update availability and much more...\nStep inside..."
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
        UserDefault[boolValueFor: .isAlreadyLaunch] = true
        AmplifyLoginUtility.signOut(completion: { signoutStatus in
            print("SignOutStatus:: \(signoutStatus)")
        })
        self.navigationController?.pushViewController(LoginViewController(), animated: true)
    }
}
