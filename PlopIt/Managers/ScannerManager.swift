//
//  ScannerManager.swift
//  PlopIt
//
//  Created by e on 4/22/22.
//

import Foundation
import UIKit

class ScannerManager: Manager {
    
    func getScannedImageArray(url: URL?) -> [UIImage] {
        guard let url = url else { return [] }
        var files = [URL]()
        var images = [UIImage]()
        if let enumerator = FileManager.default.enumerator(at: url, includingPropertiesForKeys: [.isRegularFileKey], options: [.skipsHiddenFiles, .skipsPackageDescendants]) {
            for case let fileURL as URL in enumerator {
                do {
                    let fileAttributes = try fileURL.resourceValues(forKeys:[.isRegularFileKey])
                    if fileAttributes.isRegularFile! {
                        files.append(fileURL)
                    }
                    
                    if fileURL.absoluteString.contains(".HEIC") {
                        print("IMAGE FILE URL: \(fileURL)")
                        let data = try Data(contentsOf: fileURL)
                        
                        if let image = UIImage(data: data) {
                            images.append(image)
                        }
                    }
                    
                } catch { print(error, fileURL) }
            }
            // On Successful upload , delete old session directories
            removeOldSessionDirectories(url: url)
            // you can move this method to any suitable position, this is independent call
            
        }
        return images
    }
    
    func getDirectoriesFromURL(url: URL?) -> [URL]? {
        guard let url = url else { return nil }
        var directories = [URL]()
        if let enumerator = FileManager.default.enumerator(at: url, includingPropertiesForKeys: [.isDirectoryKey], options: [.skipsHiddenFiles, .skipsPackageDescendants]) {
            for case let fileURL as URL in enumerator {
                do {
                    let fileAttributes = try fileURL.resourceValues(forKeys:[.isDirectoryKey])
                    if fileAttributes.isDirectory! {
                        directories.append(fileURL)
                    }
                    
                } catch { print(error, fileURL) }
            }
            return directories
        }
        return nil
    }
    
    func removeOldSessionDirectories(url: URL?) {
        if let url = url {
            // wrong approach, I need to traverse captures directory and delete all sub directories
            let directoryPath = url.deletingLastPathComponent().absoluteString
            guard let newURL = URL(string: directoryPath) else { return }
            let directoriesURL = self.getDirectoriesFromURL(url: newURL)
            if let directoriesURLs = directoriesURL , !directoriesURLs.isEmpty {
                for directoryURL in directoriesURLs {
                    if directoryURL.lastPathComponent != url.lastPathComponent {
                        CaptureFolderState.removeCaptureFolder(folder: directoryURL)
                    }
                }
            }
            
        }
    }
    
    func promptForAnswer(on vc: UIViewController, title:String, placeholder: String,  completionHandler: @escaping () -> Void) {
        let ac = UIAlertController(title: "Add New Menu Header", message: nil, preferredStyle: .alert)
        ac.addTextField { field in
            field.placeholder = "Menu Header"
            field.returnKeyType = .done
        }
        
        let submitAction = UIAlertAction(title: "Submit", style: .default, handler: { _ in
            guard let fields = ac.textFields, fields.count == 1 else {

                return
                
            }
            let menuHeaderAnswerField = fields[0]
            guard let answer = menuHeaderAnswerField.text, !answer.isEmpty else {
                print("empty menu Header Answer")
                return
            }
            print(answer)
            //self.typeView.textField.text = answer
            //self.typeView.endEditing(true)
            //self.pickerData.insert(answer, at: self.pickerData.endIndex - 1)
            completionHandler()
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {_ in
            //self.typeView.textField.text = ""
            //self.typeView.endEditing(true)
        })
        
        ac.addAction(submitAction)
        ac.addAction(cancelAction)
        
        vc.present(ac, animated: true)
    }
}
