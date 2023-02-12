//
//  UserDefaultsManager.swift
//  PlopIt
//
//  Created by Raivis Olehno on 16/01/2022.
//

struct UserDefaultsKeys {
    static let EMAIL_KEY = "Plopit.EMAIL"
    static let MAINTENANCE_REFS = "Plopit.MAINTENANCE_REFS"

}

import UIKit

class UserDefaultsManager: NSObject {
    
    static func getStoredEmail() -> String? {
        return UserDefaults.standard.string(forKey: UserDefaultsKeys.EMAIL_KEY)
    }
    
    static func setStoredEmail(withString string: String) {
        UserDefaults.standard.set(string, forKey: UserDefaultsKeys.EMAIL_KEY)
    }
    
    static func removeUserEmailInKeychain() {
        UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.EMAIL_KEY)
    }
    static func clear() {
        removeUserEmailInKeychain()
    }
    
    func addStoredMaintenanceRef(with ref: String) {
        var array = self.getStoredMaintenanceRefsArray()
        array.append(ref)
        UserDefaults.standard.set(array, forKey: UserDefaultsKeys.MAINTENANCE_REFS)
        UserDefaults.standard.synchronize()
    }
    
    func getStoredMaintenanceRefsArray() -> [String] {
        return  UserDefaults.standard.stringArray(forKey: UserDefaultsKeys.MAINTENANCE_REFS) ?? [String]()
    }
    
}
