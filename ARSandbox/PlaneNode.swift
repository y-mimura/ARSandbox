//
//  PlaneNode.swift
//  ARSandbox
//
//  Created by Yuya Mimura on 2019/03/31.
//  Copyright © 2019 Yuya Mimura. All rights reserved.
//

import UIKit
import ARKit

class PlaneNode: SCNNode {
    
    fileprivate override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(anchor: ARPlaneAnchor) {
        super.init()
        
        // 平面
        self.geometry = SCNPlane(width: CGFloat(anchor.extent.x), height: CGFloat(anchor.extent.z))
        SCNVector3Make(anchor.center.x, 0, anchor.center.z)
        
        self.transform = SCNMatrix4MakeRotation(-Float.pi / 2, 1, 0, 0)
        self.physicsBody = SCNPhysicsBody(type: .static, shape: SCNPhysicsShape(geometry: self.geometry!, options: nil))
        self.setPhysicsBody()
    }
    
    func update(anchor: ARPlaneAnchor) {
        (geometry as! SCNPlane).width = CGFloat(anchor.extent.x)
        (geometry as! SCNPlane).height = CGFloat(anchor.extent.z)
        position = SCNVector3Make(anchor.center.x, 0, anchor.center.z)
        physicsBody = SCNPhysicsBody(type: .static, shape: SCNPhysicsShape(geometry: geometry!, options: nil))
        self.setPhysicsBody()
    }
    
    func setPhysicsBody() {
        self.physicsBody?.categoryBitMask = 1
        self.physicsBody?.friction = 1 // 摩擦 0〜1.0 Default:0.5。0 1.0の場合は全く滑らなくなる
        self.physicsBody?.restitution = 0// 弾み具合　0:弾まない 3:弾みすぎ
    }
    
    // 平面の表示/非表示を切り替える
    var isDisplay : Bool = false {
        didSet{
            let planeMaterial = SCNMaterial()
            if isDisplay {
                planeMaterial.diffuse.contents = UIImage(named: "mesh")
            } else {
                planeMaterial.diffuse.contents = UIColor.white.withAlphaComponent(0.0)
            }
            self.geometry?.materials = [planeMaterial]
        }
    }
    
}
