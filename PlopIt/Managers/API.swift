//
//  API.swift
//  PlopIt
//
//  Created by Raivis Olehno on 08/01/2022.
//

import UIKit

final class API: NSObject {

    lazy var userManager: UserManager = { UserManager() }()
    lazy var bannerManager: BannerNotificationManager = { BannerNotificationManager() }()
    lazy var authenticationManager: AuthenticationManager = { AuthenticationManager() }()
    lazy var restaurantManager: RestaurantManager = { RestaurantManager() }()
    lazy var firebaseStorageManager: FirebaseStorageManager = { FirebaseStorageManager() }()
    lazy var userDefaultsManager: UserDefaultsManager = { UserDefaultsManager() }()
    lazy var awsManager: AWSManager = { AWSManager() }()
    lazy var arManager: ARManager = {ARManager()}()
    lazy var animationManager: AnimationManager = {AnimationManager() } ()
    lazy var UIMenuDropdownManager: UIMenuDropdownManager = {PlopIt.UIMenuDropdownManager() } ()
    lazy var scannerManager: ScannerManager = {ScannerManager() } ()

    
    static let shared: API = { API() }()
}
