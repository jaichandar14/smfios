//
//  AppDelegate.swift
//  SMF-iOS
//
//  Created by Swapnil_Dhotre on 4/22/22.
//

import UIKit
import Amplify
import AmplifyPlugins

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let frame = UIScreen.main.bounds
        self.window = UIWindow(frame: frame)
        
        if #available(iOS 13.0, *) {
            
        } else {
            Util.checkAndUpdateController(window: window!)
        }
        
        /// Do setup for amplify
        do {
            try Amplify.add(plugin: AWSCognitoAuthPlugin())
            try Amplify.configure()
            print("Amplify configured with auth plugin")
        } catch {
            print("An error occurred setting up Amplify: \(error)")
        }
        
        ThemeManager.applyTheme(theme: .defaultTheme)
        
        /// Initialize netowrk change listener
        Connectivity.shared.startNotifier()
        
        listenToAuthEvents()
        
        AmplifyLoginUtility.fetchTokenInfo()
        
        return true
    }
    
    
//    func loadJson(fileName: String) -> ViewQuote? {
//       let decoder = JSONDecoder()
//       guard
//            let url = Bundle.main.url(forResource: fileName, withExtension: "json"),
//            let data = try? Data(contentsOf: url),
//                let obj = try? JSONDecoder().decode(ViewQuote.self, from: data)
//       else {
//            return nil
//       }
//
//       return obj
//    }
    
    func listenToAuthEvents() {
        _ = Amplify.Hub.listen(to: .auth) { payload in
            switch payload.eventName {
            case HubPayload.EventName.Auth.signedIn:
                print("AuthEvents:: User signed in")
                // Update UI
                
            case HubPayload.EventName.Auth.sessionExpired:
                print("AuthEvents:: Session expired")
                AmplifyLoginUtility.fetchAuthToken { authStatus in
                    switch authStatus {
                    case .authenticationFailed:
                        DispatchQueue.main.async {
                            self.showAlertAndLogOut()
                        }
                    case .authenticationSuccess:
                        //                        self?.alreadySignIn()
                        // Do not do anything just new token is fetched
                        break
                    }
                }
                
            case HubPayload.EventName.Auth.signedOut:
                print("AuthEvents:: User signed out")
                // Update UI
                
            case HubPayload.EventName.Auth.userDeleted:
                print("AuthEvents:: User deleted")
                // Update UI
                
            default:
                break
            }
        }
    }
    
    func showAlertAndLogOut() {
        let alert = UIAlertController(title: "Logout", message: "Your session is expired!!!", preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "OK", style: .default, handler: { action in
            alert.dismiss(animated: true) {
                Util.checkAndUpdateController(window: self.window!)
            }
        })
        alert.addAction(ok)
        
        self.window?.rootViewController?.present(alert, animated: true)
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        UserDefaults.standard.synchronize()
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return .portrait
    }
    
    // MARK: UISceneSession Lifecycle
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        print("Application did become active")
        
        AmplifyLoginUtility.didBecomeActive()
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        print("Application did resign active")
        AmplifyLoginUtility.willResignActive()
    }
}

