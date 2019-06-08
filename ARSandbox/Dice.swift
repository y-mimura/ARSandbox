//
//  Dice.swift
//  ARSandbox
//
//  Created by Yuya Mimura on 2019/03/31.
//  Copyright © 2019 Yuya Mimura. All rights reserved.
//

import UIKit
import ARKit

class Dice: SCNNode {

    fileprivate override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // サイコロを落とす位置とサイズを決める
    init(size: CGFloat, hitResult: ARHitTestResult) {
        super.init()
        
        // 形状をBoxに指定し、サイズを指定
        self.geometry = SCNBox(width: size, height: size, length: size, chamferRadius: 0.01)
        
        // 6面をそれぞれ違う表面にする
        let imageNames = ["dice1","dice2","dice6","dice5","dice3","dice4"]
        self.geometry?.materials = []
        
        for imageName in imageNames {
            let material = SCNMaterial()
            material.diffuse.contents = UIImage(named: imageName)
            geometry?.materials.append(material)
        }
        
        self.physicsBody = SCNPhysicsBody(type: .dynamic, shape: SCNPhysicsShape(geometry: self.geometry!, options: [:]))
        self.physicsBody?.categoryBitMask = 1
        self.physicsBody?.restitution = 1.3         // 弾み具合 0:弾まない
        //self.physicsBody?.rollingFriction = 1     // 回転に対する摩擦 Default:0(摩擦なし)
        //self.physicsBody?.damping = 1             // 空気の摩擦抵抗 1でゆっくり落ちる
        self.physicsBody?.angularDamping = 1        // 回転に対する空気抵抗 0.0〜1.0 Default 0.1
        self.physicsBody?.friction = 1              // 設置面の摩擦の値　0.0〜1.0 Default:0.5

        // タップした位置よりサイコロのサイズのX倍の高さから落下させる
        // arc4random = シードなしでunsigned intのランダム値を生成する
        self.position = SCNVector3(hitResult.worldTransform.columns.3.x + Float(size * CGFloat(arc4random() % 3)),
                                   hitResult.worldTransform.columns.3.y + Float(size * CGFloat(arc4random() % 3 + 5)),
                                   hitResult.worldTransform.columns.3.z)
        
        // 出目が変わるように、初期表示はランダムに回転させる
        self.rotation = SCNVector4(1, 1, 1, Double(arc4random() % 10) * Double.pi)
    }
    
}
