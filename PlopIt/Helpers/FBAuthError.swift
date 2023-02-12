//
//  FBError.swift
//  Signin With Apple
//
//  Created by Stewart Lynch on 2020-03-18.
//  Copyright © 2020 CreaTECH Solutions. All rights reserved.
//

import Foundation


// MARK: - SignIn with Apple Erors
enum SignInWithAppleAuthError: Error {
    case noAuthDataResult
    case noIdentityToken
    case noIdTokenString
    case noAppleIDCredential
}

extension SignInWithAppleAuthError: LocalizedError {
    // This will provide me with a specific localized description for the SignInWithAppleAuthError
    var errorDescription: String? {
        switch self {
        case .noAuthDataResult:
            return NSLocalizedString("No Auth Data Result", comment: "")
        case .noIdentityToken:
            return NSLocalizedString("Unable to fetch identity token", comment: "")
        case .noIdTokenString:
            return NSLocalizedString("Unable to serialize token string from data", comment: "")
        case .noAppleIDCredential:
            return NSLocalizedString("Unable to create Apple ID Credential", comment: "")
        }
    }
}

// MARK: - Signin in with email errors
enum AuthError {
    case notFilled
    case invalidEmail
    case passwordNotMatched
    case unknownError
    case serverError
}

enum UserError {
    case notFilled
    case photoNotExist
    case cantGetUserInfo
    case cantUnwrapToMUser
}

extension AuthError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .notFilled:
            return NSLocalizedString("Fill all fields!", comment: "")
        case .invalidEmail:
            return NSLocalizedString("Fill correct email!", comment: "")
        case .passwordNotMatched:
            return NSLocalizedString("Passwords are not the same!", comment: "")
        case .unknownError:
            return NSLocalizedString("Unknown error", comment: "")
        case .serverError:
            return NSLocalizedString("Server return error!", comment: "")
        }
    }
}

extension UserError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .notFilled:
            return NSLocalizedString("Fill all fields!", comment: "")
        case .photoNotExist:
            return NSLocalizedString("Fill photo!", comment: "")
        case .cantGetUserInfo:
            return NSLocalizedString("Can't load user info from firebase!", comment: "")
        case .cantUnwrapToMUser:
            return NSLocalizedString("Can't Unwrap To MUser!", comment: "")
        }
    }
}




