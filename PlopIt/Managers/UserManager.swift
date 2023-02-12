//
//  UserManagerConsumer.swift
//  PlopIt
//
//  Created by Raivis Olehno on 08/01/2022.
//

import UIKit
import FirebaseAuth
import FirebaseCore
import GoogleSignIn

@objc protocol UserManagerConsumer: class, NSObjectProtocol {
    @objc optional func userDidLogIn()
    @objc optional func userIsLoggedIn()
    @objc optional func noCurrentUser()
    @objc optional func userFailedToLogIn(with message: String)
    @objc optional func userDidSignup()
    @objc optional func userFailedToSignup(with message: String)
    @objc optional func didGetCurrentUser()
    @objc optional func failedToGetCurrentUser()
    @objc optional func userDidLogOut()
    @objc optional func userDidFailLogOut()
    @objc optional func didUpdateCurrentUser()
    @objc optional func failedToUpdateCurrentUser()
}

class UserManager: Manager {
    
    let userService = UserService()
    var currentUser = Auth.auth().currentUser
    
    func checkIfUserIsLoggedIn() {
        if Auth.auth().currentUser?.uid == nil {
            self.informConsumersNoUserLoggedIn()
        } else {
            self.informConsumersUserIsLoggedIn()
        }
    }
    
    func login(email: String, password: String) {
        userService.login(email: email, password: password) {
            if let base64EncodedString = StringHelper.base64Encode(user: email, password: password) {
                KeychainManager.setBasicAuthCredsInKeychain(withString: base64EncodedString)
            }
            self.informConsumersUserDidLogIn()
        } withFailure: { error in
            self.informConsumersUserFailedToLogIn(with: "\(error)")
        }
    }
    
    func GoogleLogIn(vc: UIViewController) {
        userService.GoogleLogIn(vc: vc) {
            self.informConsumersUserDidLogIn()
        } withFailure: { error in
            self.informConsumersUserFailedToLogIn(with: "\(error)")
        }
   }
    
    func logout() {
        userService.logout { result in
            switch result {
            case .success(_):
                KeychainManager.clear()
                UserDefaults.standard.removeObject(forKey: "isOwner")
                self.informConsumersUserLoggedOut()
            case .failure(_):
               self.informConsumersUserFailedLoggedOut()
            }
        }
    }
    
    func resetPassword(email: String ,withSuccess success:@escaping() -> (), withFailure failure: @escaping(String) -> ()) {
        userService.resetPassword(email: email) {
            success()
        } withFailure: { error in
            API.shared.bannerManager.showErrorNotification(withMessage: error)
        }

    }
    
    func createAccount(isOwner:Bool, email: String, password: String, confirmPassword: String, fullName: String, restaurantName: String, addressStreet: String, addressCity: String, addressState: String, addressZip: String, restaurantDescription: String, phoneNumber: String, priceRange: String, websiteURL: String, hourArray: [String], dietaryDict: [String:Bool], genreDict: [String:Bool], restaurantHeaderImageURL: String, restaurantThumbnailImageURL: String) {
        userService.createAccount(isOwner:isOwner, email: email, password: password, confirmPassword: confirmPassword, fullName: fullName, restaurantName: restaurantName, addressStreet: addressStreet, addressCity: addressCity, addressState: addressState, addressZip: addressZip, restaurantDescription: restaurantDescription, phoneNumber: phoneNumber, priceRange: priceRange, websiteURL: websiteURL, hourArray: hourArray, dietaryDict: dietaryDict, genreDict: genreDict, restaurantHeaderImageURL: restaurantHeaderImageURL, restaurantThumbnailImageURL: restaurantThumbnailImageURL) {
            if let base64EncodedString = StringHelper.base64Encode(user: email, password: password) {
                KeychainManager.setBasicAuthCredsInKeychain(withString: base64EncodedString)
            }
            self.informConsumersUserDidSignup()
        } withFailure: { error in
            API.shared.bannerManager.showErrorNotification(withMessage: error)
            self.informConsumersUserFailedToSignup(with: error)
        }
    }
    
    /*func getOwnerRestaurant() -> {
        userService.getOwnerRestaurantID()
    }*/

    //add dropdown info of cuisine, dietary -- menuheader
   /*
    func createRestaurantAccount(restaurantName: String, addressStreet: String, addressCity: String, addressState: String, addressZip: String, restaurantDescription: String, phoneNumber: String, priceRange: String, websiteURL: String, restaurantHeaderImageURL: String, restaurantThumbnailImageURL: String) {
        userService.addOwnerDetailsToFirestore(restaurantName: restaurantName, addressStreet: addressStreet, addressCity: addressCity, addressState: addressState, addressZip: addressZip, restaurantDescription: restaurantDescription, phoneNumber: phoneNumber, priceRange: priceRange, websiteURL: websiteURL, restaurantHeaderImageURL: restaurantHeaderImageURL, restaurantThumbnailImageURL: restaurantThumbnailImageURL)
    }
    */

    //MARK:- CONSUMERS
    
    func informConsumersUserIsLoggedIn() {
        let consumersEnumerator = self.consumers?.objectEnumerator().allObjects
        if consumersEnumerator != nil {
            for consumer in consumersEnumerator! {
                if (consumer as! UserManagerConsumer).responds(to: #selector(UserManagerConsumer.userIsLoggedIn)) {
                    (consumer as! UserManagerConsumer).userIsLoggedIn!()
                }
            }
        }
    }
    
    func informConsumersNoUserLoggedIn() {
        let consumersEnumerator = self.consumers?.objectEnumerator().allObjects
        if consumersEnumerator != nil {
            for consumer in consumersEnumerator! {
                if (consumer as! UserManagerConsumer).responds(to: #selector(UserManagerConsumer.noCurrentUser)) {
                    (consumer as! UserManagerConsumer).noCurrentUser!()
                }
            }
        }
    }
    
    func informConsumersUserDidLogIn() {
        let consumersEnumerator = self.consumers?.objectEnumerator().allObjects
        if consumersEnumerator != nil {
            for consumer in consumersEnumerator! {
                if (consumer as! UserManagerConsumer).responds(to: #selector(UserManagerConsumer.userDidLogIn)) {
                    (consumer as! UserManagerConsumer).userDidLogIn!()
                }
            }
        }
    }
    
    func informConsumersUserFailedToLogIn(with message: String) {
        let consumersEnumerator = self.consumers?.objectEnumerator().allObjects
        if consumersEnumerator != nil {
            for consumer in consumersEnumerator! {
                if (consumer as! UserManagerConsumer).responds(to: #selector(UserManagerConsumer.userFailedToLogIn(with:))) {
                    (consumer as! UserManagerConsumer).userFailedToLogIn!(with: message)
                }
            }
        }
    }
    
    func informConsumersUserDidGetCurrentUser() {
        let consumersEnumerator = self.consumers?.objectEnumerator().allObjects
        if consumersEnumerator != nil {
            for consumer in consumersEnumerator! {
                if (consumer as! UserManagerConsumer).responds(to: #selector(UserManagerConsumer.didGetCurrentUser)) {
                    (consumer as! UserManagerConsumer).didGetCurrentUser!()
                }
            }
        }
    }
    
    func informConsumersUserFailedToGetCurrentUser(with message: String) {
        let consumersEnumerator = self.consumers?.objectEnumerator().allObjects
        if consumersEnumerator != nil {
            for consumer in consumersEnumerator! {
                if (consumer as! UserManagerConsumer).responds(to: #selector(UserManagerConsumer.failedToGetCurrentUser)) {
                    (consumer as! UserManagerConsumer).failedToGetCurrentUser!()
                }
            }
        }
    }
    
    func informConsumersUserDidSignup() { //withUser user: SignupViewModel
        let consumersEnumerator = self.consumers?.objectEnumerator().allObjects
        if consumersEnumerator != nil {
            for consumer in consumersEnumerator! {
                if (consumer as! UserManagerConsumer).responds(to: #selector(UserManagerConsumer.userDidSignup)) {
                    (consumer as! UserManagerConsumer).userDidSignup!()
                }
            }
        }
    }
    
    func informConsumersUserFailedToSignup(with message: String) {
        let consumersEnumerator = self.consumers?.objectEnumerator().allObjects
        if consumersEnumerator != nil {
            for consumer in consumersEnumerator! {
                if (consumer as! UserManagerConsumer).responds(to: #selector(UserManagerConsumer.userFailedToSignup(with:))) {
                    (consumer as! UserManagerConsumer).userFailedToSignup!(with: message)
                }
            }
        }
    }
    
    func informConsumersUserLoggedOut() {
        let consumersEnumerator = self.consumers?.objectEnumerator().allObjects
        if consumersEnumerator != nil {
            for consumer in consumersEnumerator! {
                if (consumer as! UserManagerConsumer).responds(to: #selector(UserManagerConsumer.userDidLogOut)) {
                    (consumer as! UserManagerConsumer).userDidLogOut!()
                }
            }
        }
    }
    
    func informConsumersUserFailedLoggedOut() {
        let consumersEnumerator = self.consumers?.objectEnumerator().allObjects
        if consumersEnumerator != nil {
            for consumer in consumersEnumerator! {
                if (consumer as! UserManagerConsumer).responds(to: #selector(UserManagerConsumer.userDidFailLogOut)) {
                    (consumer as! UserManagerConsumer).userDidFailLogOut!()
                }
            }
        }
    }
}
