//
//  Cookie.swift
//  SMF-iOS
//
//  Created by Swapnil_Dhotre on 4/28/22.
//

import Foundation

class Cookie {
    static var instance: Cookie = Cookie()
    
    private init(){}
    
    // MARK: Set Cookie method
    func setCookie(to session: URLSession) {
        let cookieProperties: [HTTPCookiePropertyKey : Any] = [
            HTTPCookiePropertyKey.domain: APIConfig.domain,
            HTTPCookiePropertyKey.path: "/",
            HTTPCookiePropertyKey.name: APIConstant.jwt_token,
            HTTPCookiePropertyKey.value: "",//AppKeychain.shared[Constant.Keychain.jwt_token] ?? "",
            HTTPCookiePropertyKey.secure: "TRUE",
            HTTPCookiePropertyKey.expires: NSDate(timeIntervalSinceNow: 31556926)
        ]
        if let cookie = HTTPCookie(properties: cookieProperties) {
            session.configuration.httpCookieStorage?.setCookie(cookie)
        }
    }
    
    // MARK: Delete Cookies
    /// This method is used to delete cookies already present in given session.
    func deleteCookie(of session: URLSession){
        let oldCookieArray = session.configuration.httpCookieStorage?.sortedCookies(using: [NSSortDescriptor.init(key: APIConstant.jwt_token, ascending: true)])
        if let oldCookie = oldCookieArray {
            for cookie in oldCookie {
                session.configuration.httpCookieStorage?.deleteCookie(cookie)
            }
        }
    }
    
    // MARK: Reset Cookie method
    /// This method is used to reset Cookie.
    func resetCookie() {
        Cookie.instance = Cookie()
    }
}
