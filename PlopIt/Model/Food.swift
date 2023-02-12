//
//  Food.swift
//  scrum
//
//  Created by e on 12/26/21.
//

import Foundation
import RealityKit
import ARKit


class MenuItemARModel: SCNNode {
    
    
    func loadModel() {
        guard let virtualObjectScene = SCNScene(named: "ship.scn") else {
            return
        }
        
        let wrapperNode = SCNNode()
        
       
        
        for child in virtualObjectScene.rootNode.childNodes {
            wrapperNode.addChildNode(child)
        
        }

        
        
        self.addChildNode(wrapperNode)
    }
}
