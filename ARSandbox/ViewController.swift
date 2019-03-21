//
//  ViewController.swift
//  ARSandbox
//
//  Created by 三村裕矢 on 2019/03/21.
//  Copyright © 2019 Yuya Mimura. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        // Set the view's delegate
//        sceneView.delegate = self
//
//        // Show statistics such as fps and timing information
//        sceneView.showsStatistics = true
//
//        // Create a new scene
//        let scene = SCNScene(named: "art.scnassets/ship.scn")!
//
//        // Set the scene to the view
//        sceneView.scene = scene
        
        // Viewのsceneプロパティに空のシーンを生成する
        sceneView.scene = SCNScene()
        
        // 1辺の長さが20cmの立方体を生成する
        // scneneViewの中のサイズは、1.0=1mとして現実の世界とリンクしている。
        let node = SCNNode()
        node.geometry = SCNBox(width: 0.2, height: 0.2, length: 0.2, chamferRadius: 0)
        // 表面（マテリアル）を生成する
        let material = SCNMaterial()
        material.diffuse.contents = UIImage(named: "block")
        
        // マテリアルをノードに適用
        node.geometry?.materials = [material]
        
        // ノードの位置は、カメラを原点として左右：0m 上下：0m　奥に50cm
        node.position = SCNVector3(0, 0, -0.5)
        
        sceneView.scene.rootNode.addChildNode(node)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}
