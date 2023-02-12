//
//  ARViewManager.swift
//  PlopIt
//
//  Created by Raivis Olehno on 27/02/2022.
//

import UIKit
import ARKit
import RealityKit
import SceneKit
import SceneKit.ModelIO
import FocusNode
import SmartHitTest

extension ARSCNView: ARSmartHitTest {}

class ARManager: Manager, URLSessionDelegate {
    
    let focusNode = FocusSquare()
    var focusNodePosition: SCNVector3?
    
    func configureARView(view: ARSCNView) {
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal, .vertical]
        view.session.run(configuration)
        view.delegate = self
        view.autoenablesDefaultLighting = true
        view.automaticallyUpdatesLighting = true
        self.focusNode.viewDelegate = view
        view.scene.rootNode.addChildNode(self.focusNode)
    }
    
    func getFocusNodePosition() -> SCNVector3 {
        focusNodePosition = focusNode.position
        return focusNodePosition!
    }
    
    func downloadSceneTask(newModel: String){
        guard let url = URL(string: newModel) else { return }
        let downloadSession = URLSession(configuration: URLSession.shared.configuration, delegate: self, delegateQueue: nil)
        let downloadTask = downloadSession.downloadTask(with: url)
        downloadTask.resume()
    }
    
    //AR
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    func load(ARView: SCNView, directory: String) {
        let downloadedScenePath = getDocumentsDirectory().appendingPathComponent("\(directory).usdz")
        print("downloadedScenePath: \(downloadedScenePath)")
        ARView.autoenablesDefaultLighting = true
        ARView.backgroundColor = .clear
        let asset = MDLAsset(url: downloadedScenePath)
        asset.loadTextures()
        
        
        
        let scene = SCNScene(mdlAsset: asset)
        
        var objectDish = SCNNode()
        objectDish.position = SCNVector3(0, CGFloat(0.01 * Double.pi), 0)
        ARView.scene?.rootNode.addChildNode(objectDish)
        
        for item in scene.rootNode.childNodes{
            objectDish = item
        }
      
        
        
        

       let rotate = SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: CGFloat(0.01 * Double.pi), z: 0, duration: 0.1))
        objectDish.runAction(rotate)
    
        ARView.scene = scene
        ARView.allowsCameraControl = true
    }
    
    func removeARObject(ARView: SCNView) {
        if let ARScene = ARView.scene {
            ARScene.rootNode.enumerateChildNodes { (node, stop) in
                node.removeFromParentNode()
            }
        }
    }
}

extension ARManager: ARSCNViewDelegate {
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
        
        let width = CGFloat(planeAnchor.extent.x)
        let height = CGFloat(planeAnchor.extent.z)
        let plane = SCNPlane(width: width, height: height)
        plane.materials.first?.diffuse.contents = UIColor.clear
        
        let planeNode = SCNNode(geometry: plane)
        
        let x = CGFloat(planeAnchor.center.x)
        let y = CGFloat(planeAnchor.center.y)
        let z = CGFloat(planeAnchor.center.z)
        planeNode.position = SCNVector3(x,y,z)
        planeNode.eulerAngles.x = -.pi / 2

        node.addChildNode(planeNode)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as?  ARPlaneAnchor,
              let planeNode = node.childNodes.first,
              let plane = planeNode.geometry as? SCNPlane
        else { return }
        
        let width = CGFloat(planeAnchor.extent.x)
        let height = CGFloat(planeAnchor.extent.z)
        plane.width = width
        plane.height = height
        
        let x = CGFloat(planeAnchor.center.x)
        let y = CGFloat(planeAnchor.center.y)
        let z = CGFloat(planeAnchor.center.z)
        planeNode.position = SCNVector3(x, y, z)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        self.focusNode.updateFocusNode()
    }
}
