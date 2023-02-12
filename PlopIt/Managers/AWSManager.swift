//
//  AWSManager.swift
//  PlopIt
//
//  Created by Raivis Olehno on 02/03/2022.
//

import Foundation
import UIKit
import Amplify

class AWSManager: Manager {
    
    //needs to have a folder after menuItemID
    func uploadImage(with data: Data, restaurantID: String, menuItemID: String, randomString: String) {
        Amplify.Storage.uploadData(key: "\(restaurantID)/\(menuItemID)/\(randomString)/\(UUID().uuidString).png", data: data,
                                   progressListener: { progress in
            print("ProgressUpload: \(progress)")
        }, resultListener: { (event) in
            switch event {
            case .success:
                print("CompletedUpload: \(data)")
            case .failure(let storageError):
                print("FailedUpload: \(storageError.errorDescription). \(storageError.recoverySuggestion)")
            }
        })
    }
    
    /*func uploadMultipleImages(with data: Data, restaurantID: String, menuItemID: String) {
        Amplify.Storage.uploadData(key: "\(restaurantID)/\(menuItemID)/\(UUID().uuidString).png", data: data,
                                   progressListener: { progress in
            print("ProgressUpload: \(progress)")
        }, resultListener: { (event) in
            switch event {
            case .success:
                print("CompletedUpload: \(data)")
            case .failure(let storageError):
                print("FailedUpload: \(storageError.errorDescription). \(storageError.recoverySuggestion)")
            }
        })
    }*/

}
