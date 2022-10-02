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
    case authenticationSuccess(session: AuthSession, token: String)
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
    
    static private let kTimeoutInSeconds: TimeInterval = 60
    static private var timer: Timer?
    
    static func signIn(withUserId userId: String, completion: @escaping ((LoginStatus) -> Void)) {
        
        Amplify.Auth.signIn(username: userId, password: nil) { result in
            do {
                let signinResult = try result.get()
                switch signinResult.nextStep {
                case .confirmSignInWithSMSMFACode(let deliveryDetails, let info):
                    print("SMS code send to \(deliveryDetails.destination)")
                    print("Additional info \(String(describing: info))")
                    completion(LoginStatus.signedInSuccess)
                    // Prompt the user to enter the SMSMFA code they received
                    // Then invoke `confirmSignIn` api with the code
                    
                case .confirmSignInWithCustomChallenge(let info):
                    print("Custom challenge, additional info \(String(describing: info))")
                    completion(LoginStatus.signedInSuccess)
                    // Prompt the user to enter custom challenge answer
                    // Then invoke `confirmSignIn` api with the answer
                    
                case .confirmSignInWithNewPassword(let info):
                    print("New password additional info \(String(describing: info))")
                    
                    // Prompt the user to enter a new password
                    // Then invoke `confirmSignIn` api with new password
                    
                case .resetPassword(let info):
                    print("Reset password additional info \(String(describing: info))")
                    
                    // User needs to reset their password.
                    // Invoke `resetPassword` api to start the reset password
                    // flow, and once reset password flow completes, invoke
                    // `signIn` api to trigger signin flow again.
                    
                case .confirmSignUp(let info):
                    print("Confirm signup additional info \(String(describing: info))")
                    
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
                
                let tokenInfo = fetchTokenInfo()
                self.sceduleTokenUpdateTimer(for: tokenInfo)
                
                completion(.authenticationSuccess(session: session, token: UserDefault[stringValueFor: .awsToken]!))
                
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
    
//    static func startTokenUpdateService() {
//        self.fetchUpdatedToken()
//        self.timer = Timer.scheduledTimer(timeInterval: kTimeoutInSeconds, target: self, selector: #selector(self.fetchUpdatedToken), userInfo: nil, repeats: true)
//    }
//

    
    @objc static func fetchUpdatedToken() {
        AmplifyLoginUtility.fetchAuthToken { authStatus in
            switch authStatus {
            case .authenticationFailed:
                DispatchQueue.main.async {
                    if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                        DispatchQueue.main.async {
                            appDelegate.showAlertAndLogOut()
                        }
                    }
                }
                break
            case .authenticationSuccess:
                //                        self?.alreadySignIn()
                // Do not do anything just new token is fetched
                break
            }
        }
    }
    
    static func willResignActive() {
        AmplifyLoginUtility.stopTokenUpdateService()
        UserDefault[key: .userInactiveStartTime] = Date()
    }
    
    static func didBecomeActive() {
        if let date = UserDefault[key: .userInactiveStartTime] as? Date, let after20Min = Calendar.current.date(byAdding: .second, value: 20, to: date) {
            if Date() > after20Min {
                if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                    DispatchQueue.main.async {
                        appDelegate.showAlertAndLogOut()
                    }
                }
            }
        }
        
        let tokenInfo = AmplifyLoginUtility.fetchTokenInfo()
        AmplifyLoginUtility.sceduleTokenUpdateTimer(for: tokenInfo)
    }
    
    static func fetchTokenInfo() -> TokenInfo? {
        let originalToken = "eyJraWQiOiI1OTV2RlJoWUZLeGVNZytYaU9kVGV1VE9nY1U3QmJWOGVZejlOWXZIcVlRPSIsImFsZyI6IlJTMjU2In0.eyJzdWIiOiJiNmQ2YTVhOS1iYWNhLTQ2YmYtOTBlZS1hMDhjZWIxMmUzYTkiLCJlbWFpbF92ZXJpZmllZCI6dHJ1ZSwiaXNzIjoiaHR0cHM6XC9cL2NvZ25pdG8taWRwLnVzLWVhc3QtMS5hbWF6b25hd3MuY29tXC91cy1lYXN0LTFfV1ExU2RJbEM1IiwicGhvbmVfbnVtYmVyX3ZlcmlmaWVkIjp0cnVlLCJjb2duaXRvOnVzZXJuYW1lIjoiY2hhbjk3NzI5NWphaSIsIm9yaWdpbl9qdGkiOiI3YWE0ZjBkNS1mN2U0LTRiNzktYThkYS02MTFhMDY2MzAwMjkiLCJhdWQiOiI0cWhzc2UyaWQwYWE5YWFmcTlkNDdia2ZxcyIsImV2ZW50X2lkIjoiZDQ1OGU4NDEtZDAyYy00ZmQwLTk0NjItNTg1NWJkNjM0MjhhIiwidG9rZW5fdXNlIjoiaWQiLCJhdXRoX3RpbWUiOjE2NjQ1MzE1OTYsIm5hbWUiOiJqYWkgY2hhbiIsInBob25lX251bWJlciI6Iis5MTg4NzAyMDMxNDEiLCJleHAiOjE2NjQ1MzMzOTYsImlhdCI6MTY2NDUzMTU5NiwianRpIjoiMTBlZjNkYWMtNjc2My00N2QxLThmOTMtYmVkMzJmN2IxNTcxIiwiZW1haWwiOiJqYWljaGFuZGFyMTRAZ21haWwuY29tIn0.TAvmNpEg90t6BoaH-CuEHmR-66QIU1AjffyYxUGfLO9tyYEJ6VvRgABAYEPevvImoMFgwO2p90yRdEXSfF6JLjKN_BG8tLOcXd2qAWtLTu1QcDyLUpcjf-1zxayxhNGWPfZTyf5YiUugSD1qaOKY30hKQs2h4evAT8hgdxtRSzP_yc6b4_jnOkRvR1vsS4DgaLaaNZJTIhDyZU2K9Kv8PSJtgU4DTBcw9x2RW8UpdfO8k1IWAzDvWoVNp2QwZGUHNecdRaMFpbszOOqIjK_0eFd9K6whnebFuDPmv7G_FubkoFZvqkJ2nVbQ7xtq6RQ0TV7CEiyGu2CVHDW3i6g1Fg"
        
        let splits = originalToken.split(separator: ".")
        if splits.count > 2 {
            let token = splits[1]

            let newToken = base64PaddingWithEqual(encoded64: String(token))
            print("\(token.count)" + "\n\n")
            
            if let decodedData = Data(base64Encoded: newToken, options: .ignoreUnknownCharacters) {
                do {
                    let tokenInfo = try JSONDecoder().decode(TokenInfo.self, from: decodedData)
                    print(tokenInfo.exp)
                    
                    return tokenInfo
                } catch let error {
                    print("parsing failure:: \(error)")
                }
            }
        }
        
        return nil
    }
    
    
//                    let dateFormatterGet = DateFormatter()
//                    dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"
//                    print("Date - \(dateFormatterGet.string(from: date))")
    
    static func sceduleTokenUpdateTimer(for tokenInfo: TokenInfo?) {
        if tokenInfo == nil {
            return
        }
        
        let date = Date(timeIntervalSince1970: TimeInterval(tokenInfo!.exp))
        print("date - \(date)")
        let remainingSec = date.timeIntervalSinceReferenceDate - Date().timeIntervalSinceReferenceDate
        
        self.timer?.invalidate()
        self.timer = nil
        
        self.timer = Timer.scheduledTimer(timeInterval: remainingSec + 2, target: self, selector: #selector(self.fetchUpdatedToken), userInfo: nil, repeats: true)
        
    }
    
    static func stopTokenUpdateService() {
        self.timer?.invalidate()
        self.timer = nil
    }
    
    private static func base64PaddingWithEqual(encoded64: String) -> String {
        let remainder = encoded64.count % 4
        if remainder == 0 {
            return encoded64
        } else {
            // padding with equal
            let newLength = encoded64.count + (4 - remainder)
            return encoded64.padding(toLength: newLength, withPad: "=", startingAt: 0)
        }
    }
}

struct TokenInfo: Decodable {
    
      var sub: String
      var email_verified: Bool
      var iss: String
      var phone_number_verified: Bool
      var cognitoUsername: String
      var origin_jti: String
      var aud: String
      var event_id: String
      var token_use: String
      var auth_time: Int32
      var name: String
      var phone_number: String
      var exp: Int32
      var iat: Int32
      var jti: String
      var email: String
    
    enum CodingKeys: String, CodingKey {
        case sub
        case email_verified
        case iss
        case phone_number_verified
        case cognitoUsername = "cognito:username"
        case origin_jti
        case aud
        case event_id
        case token_use
        case auth_time
        case name
        case phone_number
        case exp
        case iat
        case jti
        case email
    }
}
