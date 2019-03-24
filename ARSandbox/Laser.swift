//
//  Laser.swift
//  ARSandbox
//
//  Created by 三村裕矢 on 2019/03/24.
//  Copyright © 2019 Yuya Mimura. All rights reserved.
//

import UIKit
import ARKit
import SceneKit

class Laser: SCNNode {

    var node : SCNNode!
    
    fileprivate override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented.")
    }

    init(arScnView: ARSCNView) {
        super.init()
        
        // Laser外側の薄い赤円
        geometry = SCNSphere(radius: 0.03)
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.red.withAlphaComponent(0.5)
        geometry?.materials = [material]
        position = SCNVector3(0, 0, 0)
        
        // Laser内側の濃い赤円
        let sphere = SCNSphere(radius: 0.01)
        let sphereMaterial = SCNMaterial()
        sphereMaterial.diffuse.contents = UIColor.red
        sphere.materials = [sphereMaterial]
        node = SCNNode(geometry: sphere)
        node.position = SCNVector3Make(0, 0, 0)
        
        // rootNodeに追加する
        arScnView.scene.rootNode.addChildNode(self)
        arScnView.scene.rootNode.addChildNode(node)
        // 初期状態はoff
        off()
    }
    
    /*
     Laserのポジションを調整する
     */
    func update(center: SCNVector3) {
        position = center
        node.position = center
    }
    
    /*
     Laser On
     */
    func on() {
        isHidden = false
        node.isHidden = false
    }
    
    /*
     Laser Off
     */
    func off() {
        isHidden = true
        node.isHidden = true
    }
}
