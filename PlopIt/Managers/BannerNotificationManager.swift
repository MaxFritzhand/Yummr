//
//  BannerNotificationManager.swift
//  PlopIt
//
//  Created by Raivis Olehno on 14/01/2022.
//

import UIKit
import NotificationBannerSwift

class BannerNotificationManager: Manager {
    
    func showErrorNotification(withMessage message: String, tapHandler: (() -> ())? = nil) {
        if shouldShowBanner() {
            let view = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
            let imageView = UIImageView(frame: view.frame)
            imageView.image = UIImage(named: "error")!
            view.addSubview(imageView)
            let banner = NotificationBanner(title: "Error", subtitle: message, leftView: view,  style: .danger)
            banner.duration = 1.5
            banner.haptic = .medium
            banner.dismissOnSwipeUp = true
            banner.onTap = {
                if tapHandler != nil {
                   tapHandler!()
                }
            }
            banner.show()
        }
    }
    
    func showSuccessNotification(withTitle title: String, withMessage message: String, tapHandler: (() -> ())? = nil) {
        if shouldShowBanner() {
            let view = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
            let imageView = UIImageView(frame: view.frame)
            imageView.image = UIImage(named: "error")!
            view.addSubview(imageView)
            let banner = NotificationBanner(title: title, subtitle: message, leftView: view,  style: .success)
            banner.duration = 1.5
            banner.haptic = .medium
            banner.dismissOnSwipeUp = true
            banner.onTap = {
                if tapHandler != nil {
                    tapHandler!()
                }
            }
            banner.show()
        }
    }
    
    func showWarningNotification(withTitle title: String, withMessage message: String, tapHandler: (() -> ())? = nil) {
        if shouldShowBanner() {
            let view = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
            let imageView = UIImageView(frame: view.frame)
            imageView.image = UIImage(named: "error")!
            view.addSubview(imageView)
            let banner = NotificationBanner(title: title, subtitle: message, leftView: view,  style: .warning)
            banner.duration = 1.5
            banner.haptic = .medium
            banner.dismissOnSwipeUp = true
            banner.onTap = {
                if tapHandler != nil {
                    tapHandler!()
                }
            }
            banner.show()
        }
    }
    
    func shouldShowBanner() -> Bool {
        return NotificationBannerQueue.default.numberOfBanners == 0
    }
    
    func alertUser(with message: String, title: String, vc: UIViewController, withSuccess success:@escaping() -> ()) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
       // alert.addAction(UIAlertAction(title: "Continue", style: UIAlertAction.Style.default, handler: nil))
        alert.addAction(UIAlertAction(title: "Continue", style: UIAlertAction.Style.default, handler: { action in
            success()
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: { action in
            vc.dismiss(animated: true, completion: nil)
        }))
        // show the alert
        vc.present(alert, animated: true, completion: nil)
    }

}
