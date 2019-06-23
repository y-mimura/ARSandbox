//
//  ARObject.swift
//  ARSandbox
//
//  Created by Yuya Mimura on 2019/06/22.
//  Copyright © 2019 Yuya Mimura. All rights reserved.
//

import UIKit
import ARKit

class ARObject: SCNNode {

    fileprivate override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not implemented")
    }
    
    init(width: CGFloat, height: CGFloat, length: CGFloat,
         hitResult: ARHitTestResult) {
        super.init()
        
        // Box形状でサイズを指定
        self.geometry = SCNBox(width: width, height: height, length: length, chamferRadius: 0.01)
        
        self.physicsBody = SCNPhysicsBody(type: .dynamic, shape: SCNPhysicsShape(geometry: self.geometry!, options: [:]))
        // 衝突検知用のBitmask
        // collisionBitMaskが同じノードと衝突する
        self.physicsBody?.categoryBitMask = 1
        
        // 他のPhysicsBodyと衝突する際に運動エネルギーをどれだけ失うか
        // 1以上に設定すると衝突の際に力が発生するため、弾む
        self.physicsBody?.restitution = 0
        
        // 回転に対する摩擦
        // 0で摩擦なし
        self.physicsBody?.rollingFriction = 0

        // 空気抵抗
        // 1でゆっくり落ちる
        self.physicsBody?.damping = 0
        
        // 回転に対する空気抵抗
        self.physicsBody?.angularDamping = 0
        
        // 接地面の摩擦の値
        self.physicsBody?.friction = 0
        
        // タップした位置より50cm上の高さから落下させる
        self.position
            = SCNVector3(hitResult.worldTransform.columns.3.x,
                        hitResult.worldTransform.columns.3.y + Float(0.5),
                        hitResult.worldTransform.columns.3.z)

    }
    
}
