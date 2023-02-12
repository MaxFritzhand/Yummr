//
//  Config.swift
//  PlopIt
//
//  Created by Raivis Olehno on 08/01/2022.
//

import UIKit

class Config: NSObject {
    
    static var productId: String {
        return Bundle.main.bundleIdentifier!
    }
    
}
