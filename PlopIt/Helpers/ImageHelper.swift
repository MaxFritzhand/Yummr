//
//  ImageHelper.swift
//  Crispin_Orthotics
//
//  Created by Raivis Olehno on 15/12/2021.
//

import UIKit

class ImageHelper: NSObject {
    
    static func backImage() -> UIImage {
        return UIImage(named: "back")!
    }
    
    static func logoImage() -> UIImage {
        return UIImage(named: "launchscreenLogo")!
    }
    
    static func saveImage() -> UIImage {
        return UIImage(named: "save")!
    }
    
    static func cancelImage() -> UIImage {
        return UIImage(named: "cancel")!
    }
    
}
