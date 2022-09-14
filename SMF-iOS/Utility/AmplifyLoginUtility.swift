//
//  AmplifyLoginUtility.swift
//  SMF-iOS
//
//  Created by Swapnil_Dhotre on 8/3/22.
//

import Foundation
import Amplify
import AWSPluginsCore

enum LoginStatus {
    case alreadyLogin
    case signedInSuccess
    case signedInFailed(failureReason: String)
    case logout
    case logoutFailed(failureReason: String)
}

enum AuthenticationStatus {
    case authenticationFailed
    case authenticationSuccess(token: String)
}

enum OTPConfirmation {
    case success
    case failure
}

enum UserCreds {
    case success(user: User)
    case failure
}

class AmplifyLoginUtility {
    static var amplifyToken: String = ""
    static var user: User?;
    
    static func signIn(withUserId userId: String, completion: @escaping ((LoginStatus) -> Void)) {
        
        Amplify.Auth.signIn(username: userId, password: nil) { result in
            do {
                let signinResult = try result.get()
                switch signinResult.nextStep {
                case .confirmSignInWithSMSMFACode(let deliveryDetails, let info):
                    print("SMS code send to \(deliveryDetails.destination)")
                    print("Additional info \(info)")
                    completion(LoginStatus.signedInSuccess)
                    // Prompt the user to enter the SMSMFA code they received
                    // Then invoke `confirmSignIn` api with the code
                    
                case .confirmSignInWithCustomChallenge(let info):
                    print("Custom challenge, additional info \(info)")
                    completion(LoginStatus.signedInSuccess)
                    // Prompt the user to enter custom challenge answer
                    // Then invoke `confirmSignIn` api with the answer
                    
                case .confirmSignInWithNewPassword(let info):
                    print("New password additional info \(info)")
                    
                    // Prompt the user to enter a new password
                    // Then invoke `confirmSignIn` api with new password
                    
                case .resetPassword(let info):
                    print("Reset password additional info \(info)")
                    
                    // User needs to reset their password.
                    // Invoke `resetPassword` api to start the reset password
                    // flow, and once reset password flow completes, invoke
                    // `signIn` api to trigger signin flow again.
                    
                case .confirmSignUp(let info):
                    print("Confirm signup additional info \(info)")
                    
                    // User was not confirmed during the signup process.
                    // Invoke `confirmSignUp` api to confirm the user if
                    // they have the confirmation code. If they do not have the
                    // confirmation code, invoke `resendSignUpCode` to send the
                    // code again.
                    // After the user is confirmed, invoke the `signIn` api again.
                case .done:
                    
                    // Use has successfully signed in to the app
                    print("Signin complete")
                }
            } catch {
                print ("Sign in failed \(error)")
            }
            
            
            //            switch result {
            //            case .success(let signInResult):
            //                print("Sign in succeeded")
            //                signInResult.
            //                completion(.signedInSuccess)
            //            case .failure(let error):
            //                print("Sign in failed \(error)")
            //                if let err = error.underlyingError as NSError? {
            //                    print("Cast to nserror:", err)
            //                    completion(.signedInFailed(failureReason: err.localizedDescription))
            //                }
            //
            //                completion(.signedInFailed(failureReason: ""))
            //            }
        }
    }
    
    static func signOut(completion: @escaping ((LoginStatus) -> Void)) {
        Amplify.Auth.signOut { result in
            switch result {
            case .success:
                completion(.logout)
            case .failure(let error):
                print("Sign in failed \(error)")
                completion(.logoutFailed(failureReason: error.localizedDescription))
            }
        }
    }
    
    static func fetchAuthToken(completion: @escaping ((AuthenticationStatus) -> Void)) {
        Amplify.Auth.fetchAuthSession { result in
            do {
                let session = try result.get()
                
                // Get user sub or identity id
                if let identityProvider = session as? AuthCognitoIdentityProvider {
                    let usersub = try identityProvider.getUserSub().get()
                    let identityId = try identityProvider.getIdentityId().get()
                    print("User sub - \(usersub) and identity id \(identityId)")
                }
                
                // Get AWS credentials
                if let awsCredentialsProvider = session as? AuthAWSCredentialsProvider {
                    let credentials = try awsCredentialsProvider.getAWSCredentials().get()
                    print("Access key - \(credentials.accessKey) ")
                }
                
                // Get cognito user pool token
                if let cognitoTokenProvider = session as? AuthCognitoTokensProvider {
                    let tokens = try cognitoTokenProvider.getCognitoTokens().get()
                    print("Id token - \(tokens.idToken) ")
                    UserDefault[stringValueFor: .awsToken] = tokens.idToken
                }
                
                completion(.authenticationSuccess(token: UserDefault[stringValueFor: .awsToken]!))
                
            } catch {
                print("Fetch auth session failed with error - \(error)")
                completion(.authenticationFailed)
            }
        }
    }
    
    static func confirmSignIn(otp: String, completion: @escaping ((OTPConfirmation) -> Void)) {
        Amplify.Auth.confirmSignIn(challengeResponse: otp) { result in
            switch result {
            case .success(let signInResult):
                if signInResult.isSignedIn {
                    print("Confirm sign in succeeded. The user is signed in.")
                    completion(.success)
                } else {
                    print("Confirm sign in succeeded.")
                    print("Next step: \(signInResult.nextStep)")
                    // Switch on the next step to take appropriate actions.
                    // If `signInResult.isSignedIn` is true, the next step
                    // is 'done', and the user is now signed in.
                    completion(.failure)
                }
                break
            case .failure(let error):
                print("Confirm sign in failed \(error)")
                completion(.failure)
                break
            }
        }
    }
    
    static func storeUserData(user: User) {
        self.user = user
        do {
            let data = try JSONEncoder().encode(user)
            UserDefault[key: .userData] = data
            self.amplifyToken = "Bearer \(UserDefault[stringValueFor: .awsToken]!)"
            
        } catch let err {
            print(err.localizedDescription)
        }
    }
    
    static func updateUserData() {
        do {
            self.amplifyToken = "Bearer \(UserDefault[stringValueFor: .awsToken]!)"
            if let data = UserDefault[key: .userData] as? Data {
                self.user = try JSONDecoder().decode(User.self, from: data)
            }
        } catch let err {
            print(err.localizedDescription)
        }
    }
    
    static func fetchUserCredential(completion: @escaping ((UserCreds) -> Void)) {
        LoginViewModel(loginModel: LoginModel()).getAppAuthenticatedUser { user in
            if user != nil {
                self.storeUserData(user: user!)
                completion(.success(user: user!))
            } else {
                completion(.failure)
            }
        }
    }
}
