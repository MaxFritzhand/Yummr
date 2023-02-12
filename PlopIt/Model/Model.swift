//
//  Model.swift
//  PlopIt
//
//  Created by Max Fritzhand on 1/24/22.
//

import Foundation
import SwiftUI
import UIKit
import RealityKit
import Combine

/*
class Model {

    // MARK: - Properties

    var modelName: String
    var image: UIImage
    var modelEntity: ModelEntity?

    private var cancellable: AnyCancellable? = nil

    // MARK: - Lifecycle

    init(modelName: String) {
        self.modelName = modelName
        self.image = UIImage(named: modelName)!

        let filename = modelName + ".usdz"
        self.cancellable = ModelEntity.loadModelAsync(named: filename)
            .sink { loadCompletion in
                if case .failure(let error) = loadCompletion {
                    print("Unable to load modelEntity for: \(modelName)")
                    print("Error: \(error)")
                }
            } receiveValue: { modelEntity in
                self.modelEntity = modelEntity
                print("Successfully loaded modelEntity for: \(modelName)")
            }
    }
}
*/
// MARK: - Hashable

extension Model: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(menuItem)
    }
}

// MARK: - Equatable

extension Model: Equatable {
    static func == (lhs: Model, rhs: Model) -> Bool {
        lhs.menuItem == rhs.menuItem
    }
}




//make this be dynamic...
enum MealType: String, CaseIterable {
    case breakfast
    case lunch
    case dinner
    
    var text: String {
        get {
            switch self {
            case .breakfast:
                return "Breakfast"
            case .lunch:
                return "Lunch"
            case .dinner:
                return "Dinner"
            }
        }
    }
}

 
 
 class Model: Identifiable{

   
     var id: String = UUID().uuidString
     var menuItem: String
     
     var mealType: MealType
     //var category: ModelCategory
     
     var modelURL: String
     var thumbnailImage: UIImage
     var modelEntity: ModelEntity?
     
     var scaleCompensation: Float

     private var cancellable: AnyCancellable? = nil

     // MARK: - Lifecycle

     init(menuItem: String,  mealType: MealType, modelURL: String, thumbnailImage: UIImage, scaleCompensation: Float = 1.0){
         self.menuItem = menuItem
         self.mealType = mealType
         self.modelURL = modelURL
        // self.thumbnailImage = thumbnailImage
         self.thumbnailImage = UIImage(named: menuItem) ?? UIImage(systemName: "photo")!
         self.scaleCompensation = scaleCompensation

     }
//     func asyncLoadModelEntity(){
//         let filename = self.modelURL + ".usdz"
//
//         self.cancellable = ModelEntity.loadModelAsync(named: filename)
//             .sink(receiveCompletion: { loadCompletion in
//
//                 switch loadCompletion{
//                 case .failure(let error): print("Unable to load modelEntity for: \(filename). Error:
//                 \(error.localizedDescription)")
//             case .finished:
//                 break
//             }
//     }, receiveValue: { modelEntity in
//
//         self.modelEntity = modelEntity
//         self.modelEntity?.scale *= self.scaleCompensation
//
//         print("modelEntity for \(self.name) has been loaded.")
//             })
//         }
        
    //relativePath uses modelName -- where fromURL would use modelURL
     //Ideally we would need to make {Raivis_Restaurant} a variable
     func asyncLoadModelEntity() {
         FirebaseStorageManager.asyncDownloadToFilesystem(relativePath: "restaurants/Raivis_Restaurant/\(self.menuItem).usdz") { localUrl in
             
             self.cancellable = ModelEntity.loadModelAsync(contentsOf: localUrl)
                 .sink { loadCompletion in
                     switch loadCompletion {
                     case .failure(let error):
                         print("Loading error \(error)")
                     case .finished:
                         break
                     }
                 } receiveValue: { modelEntity in
                     self.modelEntity = modelEntity
                     self.modelEntity?.scale *= self.scaleCompensation
                     
                     print("model for \(self.menuItem) is loaded")
                 }
             
         }
     }
     
     
     
     
     }
 
     

