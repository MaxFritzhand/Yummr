//
//  Validators.swift
//  RealTimeChat
//
//  Created by Roman Korobskoy on 02.02.2022.
//

import Foundation

class Validators {
    
    // для аутентификации
    static func isFilled(email: String?, password: String?, confirmPassword: String?) -> Bool {
        guard let confirmPassword = confirmPassword,
              let password = password,
              let email = email,
              password != "",
              email != "",
              confirmPassword != ""
        else {
            return false
        }
        return true
    }
    
    // для firestore
    static func isFilled(username: String?, description: String?, sex: String?) -> Bool {
        guard let sex = sex,
              let description = description,
              let username = username,
              description != "",
              username != "",
              sex != ""
        else {
            return false
        }
        return true
    }
    
    static func isSimpleEmail(_ email: String) -> Bool {
        let emailRegEx = "^.+@.+\\..{2,}$"
        return check(text: email, regEx: emailRegEx)
    }
    
    private static func check(text: String, regEx: String) -> Bool {
        let predicate = NSPredicate(format: "SELF MATCHES %@", regEx)
        return predicate.evaluate(with: text)
    }
}

