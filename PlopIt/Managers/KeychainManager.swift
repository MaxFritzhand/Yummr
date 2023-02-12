//
//  KeychainManager.swift
//  PlopIt
//
//  Created by Raivis Olehno on 08/01/2022.
//

import UIKit
import SwiftKeychainWrapper

struct KeychainKeys {
    static let BASIC_AUTH_KEY = "\(Config.productId).BASIC_AUTH_KEY"
    static let PASSWORD_KEY = "Plopit.PASSWORD"
}

class KeychainManager: NSObject {
    
    static func getBasicAuthCredsInKeychain() -> String? {
        return KeychainWrapper.standard.string(forKey: KeychainKeys.BASIC_AUTH_KEY)
    }
    
    static func setBasicAuthCredsInKeychain(withString string: String) {
        KeychainWrapper.standard.set(string, forKey: KeychainKeys.BASIC_AUTH_KEY)
    }
    
    static func setUserPasswordInKeychain(withString string: String) {
        KeychainWrapper.standard.set(string, forKey: KeychainKeys.PASSWORD_KEY)
    }
    
    static func getUserPasswordInKeychain() -> String? {
        return KeychainWrapper.standard.string(forKey: KeychainKeys.PASSWORD_KEY)
    }
    
    static func removeBasicAuthCredsInKeychain() {
        KeychainWrapper.standard.removeObject(forKey: KeychainKeys.BASIC_AUTH_KEY)
    }
    
    static func clear() {
        removeBasicAuthCredsInKeychain()
    }

}
