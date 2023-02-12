//
//  FirebaseStorageManager.swift
//  PlopIt
//
//  Created by Raivis Olehno on 26/01/2022.
//

import Foundation
import FirebaseStorage
import Firebase
import UIKit
import RealityKit

class FirebaseStorageManager {
    
    public func uploadImageData(data: Data, serverFileName: String, restaurantName: String ,completionHandler: @escaping (_ isSuccess: Bool, _ url: String?) -> Void) {

        let storage = Storage.storage()
        let storageRef = storage.reference()
        // Create a reference to the file you want to upload
        let directory = "restaurants/\(restaurantName)/"
        let fileRef = storageRef.child(directory + serverFileName)

        _ = fileRef.putData(data, metadata: nil) { metadata, error in
            fileRef.downloadURL { (url, error) in
                guard let downloadURL = url else {
                    // Uh-oh, an error occurred!
                    completionHandler(false, nil)
                    return
                }
                // File Uploaded Successfully
                completionHandler(true, downloadURL.absoluteString)
            }
        }
    }
    
    func pullImageFromDatabase(fromURL: String, completion: @escaping (UIImage?) -> Void) {
        if fromURL != "" {
            let imageReference = Storage.storage().reference(forURL: fromURL)
            imageReference.getData(maxSize: 1 * 1024 * 1024) {
                (imageData, error) in
                if let error = error {
                    print("An error has occurred - \(error.localizedDescription)")
                    completion(nil)
                } else if let imageData = imageData {
                    let downloadedImage = UIImage(data: imageData)
                    completion(downloadedImage)
                } else {
                    print("Could not unwrap image data")
                    completion(nil)
                }
            }
        }

    }
    
    //based on fromURL // rather relative path
    
//    func pullModelFromDatabase(fromURL: String, completion: @escaping (ModelEntity?) -> Void){
//        let modelReference = Storage.storage().reference(forURL: fromURL)
//
//
//        modelReference.downloadURL() {
//            (modelURL, error) in
//            if let error = error {
//                print("An error has occurred - \(error.localizedDescription)")
//                completion(nil)
//            } else if let modelURL = modelURL {
//                //modelEntity? data
//                let downloadedModel = ModelEntity(data: modelURL)
//                completion(downloadedModel)
//            } else {
//                print("Could not unwrap model data")
//                completion(nil)
//            }
//        }
//    }
    
    
     class func asyncDownloadToFilesystem(relativePath: String, handler: @escaping (_ fileUrl: URL) -> Void) {
        // Create local filesystem URL
        let storage = Storage.storage()
        let docsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileUrl = docsUrl.appendingPathComponent(relativePath)

        // Check if asset is alrady in the local filesystem
        // if it is, load that asset and return
        if FileManager.default.fileExists(atPath: fileUrl.path) {
            handler(fileUrl)
            return
        }

        // Create a reference to the asset
        let storageRef = storage.reference(withPath: relativePath)

        // Download to the local filesystem
        storageRef.write(toFile: fileUrl) { url, error in
            guard let localUrl = url else {
                print("Error downloading file")
                return
            }

            handler(localUrl)
        }.resume()
    }
}
