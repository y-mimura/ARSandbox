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

enum MarkerMode {
    case white
    case black
    case none
}

class ViewController: UIViewController {

    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet weak var label: UILabel!
    var recordingButton: RecordingButton!
    var markerMode = MarkerMode.white
    var startPosition: SCNVector3!
    var isMeasuring = false
    var timer: Timer!
    var cylinderNode: SCNNode?
    
    @IBOutlet weak var imageMaker: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.delegate = self
        // デバッグ用の情報を表示する
        sceneView.showsStatistics = true
        
        // 録画ボタン
        self.recordingButton = RecordingButton(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
        
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
        timer.fire()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
        timer.invalidate()
    }
    
    // Mesure Button TouchDown
    // 計測開始
    @IBAction func beginMesure(_ sender: UIButton) {
        if let position = getCenter() {
            for node in sceneView.scene.rootNode.childNodes {
                node.removeFromParentNode()
            }
            startPosition = position
            isMeasuring = true
            
            let spere = createSphereNode(position: startPosition,
                                         color: UIColor.red)
            sceneView.scene.rootNode.addChildNode(spere)
        }
    }
    // 計測終了
    func endMeasure() {
        if !isMeasuring { return }
        isMeasuring = false
        
        if let endPosition = getCenter() {
            let sphereNode = createSphereNode(position: endPosition,
                                              color: UIColor.red)
            sceneView.scene.rootNode.addChildNode(sphereNode)
            
            let centerPosition = getCenter(startPosition: startPosition, endPosition: endPosition)
            let centerSphereNode = createSphereNode(position: centerPosition, color: UIColor.orange)
            sceneView.scene.rootNode.addChildNode(centerSphereNode)
            
            let lineNode = createLineNode(startPosition: startPosition, endPosition: endPosition, color: UIColor.white)
            sceneView.scene.rootNode.addChildNode(lineNode)
            
            refreshCylinderNode(endPosition: endPosition)
        }
    }
    
    // Measure Button TouchUpInside
    @IBAction func touchUpInside(_ sender: UIButton) {
        endMeasure()
    }
    
    // Measure Button TouchUpOutside
    @IBAction func touchUpOutside(_ sender: UIButton) {
        endMeasure()
    }
    
    // Maker Button TouchUpInside
    @IBAction func tapToggleMarker(_ sender: UIButton) {
        switch markerMode {
        case .white:
            markerMode = .black
            imageMaker.image = UIImage(named: "Landmark_Black")
        case .black:
            markerMode = .none
            imageMaker.image = UIImage(named: "")
        case .none:
            markerMode = .white
            imageMaker.image = UIImage(named: "Landmark_White")
        }
    }
    
    // 計測中に円柱の描画を更新する
    @objc func update(tm: Timer) {
        if isMeasuring {
            if let endPosition = getCenter() {
                let position = SCNVector3Make(endPosition.x - startPosition.x,
                                              endPosition.y - startPosition.y,
                                              endPosition.z - startPosition.z)
                // startPosition から endPosition までの距離
                // √(x^2 + y^2 + z^2)
                let distance = sqrt((position.x * position.x) + (position.y * position.y) + (position.z * position.z))
                label.text = String.init(format: "%.2fm", distance)
                
                refreshCylinderNode(endPosition: endPosition)
            }
        }
    }
    
    // 円柱の更新
    func refreshCylinderNode(endPosition: SCNVector3) {
        if let node = cylinderNode {
            node.removeFromParentNode()
        }
        cylinderNode = createCylinderNode(startPosition: startPosition,
                                          endPosition: endPosition,
                                          radius: 0.001, color: UIColor.yellow, transparency: 0.5)
        sceneView.scene.rootNode.addChildNode(cylinderNode!)
    }
    
    // MARK : 座標取得
    
    // 画面の中心を取得する
    func getCenter() -> SCNVector3? {
        let touchPoint = sceneView.center
        // 衝突判定
        // featurePoint = アンカー（平面）に依存せず座標を取得
        let hitResults = sceneView.hitTest(touchPoint, types: [.featurePoint])
        if !hitResults.isEmpty {
            if let hitResult = hitResults.first {
                return SCNVector3(hitResult.worldTransform.columns.3.x,
                                  hitResult.worldTransform.columns.3.y,
                                  hitResult.worldTransform.columns.3.z)
            }
        }
        return nil
    }
    
    // 2点間の中心座標を取得する
    func getCenter(startPosition: SCNVector3, endPosition: SCNVector3) -> SCNVector3 {
        let x = endPosition.x - startPosition.x
        let y = endPosition.y - startPosition.y
        let z = endPosition.z - startPosition.z
        return SCNVector3Make(endPosition.x - x/2,
                              endPosition.y - y/2,
                              endPosition.z - z/2)
    }
    
    // MARK : ノード作成
    
    // 円柱ノードの作成
    func createCylinderNode(startPosition: SCNVector3, endPosition: SCNVector3,
                            radius: CGFloat , color: UIColor, transparency: CGFloat) -> SCNNode {
        let height = CGFloat(GLKVector3Distance(SCNVector3ToGLKVector3(startPosition),
                                                SCNVector3ToGLKVector3(endPosition)))
        let cylinderNode = SCNNode()
        cylinderNode.eulerAngles.x = Float(Double.pi / 2)
        
        let cylinderGeometry = SCNCylinder(radius: radius, height: height)
        cylinderGeometry.firstMaterial?.diffuse.contents = color
        let cylinder = SCNNode(geometry: cylinderGeometry)
        
        cylinder.position.y = Float(-height/2)
        cylinderNode.addChildNode(cylinder)
        
        let node = SCNNode()
        let targetNode = SCNNode()
        
        if (startPosition.z < 0.0 && endPosition.z > 0.0) {
            node.position = endPosition
            targetNode.position = startPosition
        }
        else {
            node.position = startPosition
            targetNode.position = endPosition
        }
        
        node.addChildNode(cylinderNode)
        node.constraints = [SCNLookAtConstraint(target: targetNode)]
        return node
    }
    
    // 球体のノードの作成
    func createSphereNode(position: SCNVector3, color: UIColor) -> SCNNode {
        let sphere = SCNSphere(radius: 0.005)
        let material = SCNMaterial()
        material.diffuse.contents = color
        sphere.materials = [material]
        let sphereNode = SCNNode(geometry: sphere)
        sphereNode.position = position
        return sphereNode
    }
    
    // 線のノードの作成
    func createLineNode(startPosition: SCNVector3, endPosition: SCNVector3, color: UIColor) -> SCNNode {
        let indices: [Int32] = [0, 1]
        let source = SCNGeometrySource(vertices: [startPosition, endPosition])
        let element = SCNGeometryElement(indices: indices, primitiveType: .line)
        let line = SCNGeometry(sources: [source], elements: [element])
        line.firstMaterial?.lightingModel = SCNMaterial.LightingModel.blinn
        let lineNode = SCNNode(geometry: line)
        lineNode.geometry?.firstMaterial?.diffuse.contents = color
        return lineNode
    }
}

extension ViewController: ARSCNViewDelegate {
    
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
