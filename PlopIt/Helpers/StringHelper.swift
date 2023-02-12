//
//  StringHelper.swift
//  PlopIt
//
//  Created by Raivis Olehno on 13/01/2022.
//

import UIKit

class StringHelper: NSObject {
    
    static func authorizationHeader(user: String, password: String) -> (key: String, value: String)? {
        let credential = StringHelper.base64Encode(user: user, password: password)
        return (key: "Authorization", value: "Basic \(credential!)")
    }
    
    static func base64Encode(user: String, password: String) -> String? {
        guard let data = "\(user):\(password)".data(using: .utf8) else { return nil }
        return data.base64EncodedString(options: [])
    }

    static func labelSize(for attributedText: NSAttributedString, considering maxWidth: CGFloat) -> CGSize {
        let constraintBox = CGSize(width: maxWidth, height: .greatestFiniteMagnitude)
        let rect = attributedText.boundingRect(with: constraintBox, options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil).integral
        return rect.size
    }
}
