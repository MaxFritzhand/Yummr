//
//  AuthenticationManager.swift
//  PlopIt
//
//  Created by Raivis Olehno on 16/01/2022.
//

import Foundation
import LocalAuthentication

enum BiometricType {
  case none
  case touchID
  case faceID
}

class AuthenticationManager: NSObject {
    
    let context = LAContext()
    var loginReason = "Quick Log in"
    
    func biometricType() -> BiometricType {
        let _ = context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
        switch context.biometryType {
        case .none:
            return .none
        case .touchID:
            return .touchID
        case .faceID:
            return .faceID
        @unknown default:
            fatalError()
        }
    }
    
    func canEvaluatePolicy() -> Bool {
      return context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
    }
    
    func authenticateUser(withCompletion completion: @escaping (_ isAvailable: Bool) -> (), withFailure failure: @escaping (String) -> ()) {
        
        guard canEvaluatePolicy() else {
            completion(false)
            return
        }
        
        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: loginReason) { (success, evaluateError) in
          if success {
            DispatchQueue.main.async {
              // User authenticated successfully, take appropriate action
                completion(true)
            }
          } else {
            let message: String
            switch evaluateError {
            case LAError.authenticationFailed?:
                message = "There was a problem verifying your identity."
            case LAError.userCancel?:
                message = "You pressed cancel."
            case LAError.userFallback?:
                message = "You pressed password."
            case LAError.biometryNotAvailable?:
                completion(false)
                return
            case LAError.biometryNotEnrolled?:
                completion(false)
                return
            case LAError.biometryLockout?:
                completion(false)
                return
            default:
                completion(false)
                return
            }
            failure(message)
            }
        }
        
    }

}


