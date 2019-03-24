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

class ViewController: UIViewController {

    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet weak var label: UILabel!
    var recordingButton: RecordingButton!
    var timer: Timer!
    var laser: Laser!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.delegate = self
        // デバッグ用の情報を表示する
        sceneView.showsStatistics = true
        
        let scene = SCNScene()
        sceneView.scene = scene
        
        laser = Laser(arScnView: sceneView)
        
        // 録画ボタン
        self.recordingButton = RecordingButton(self)
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
    
    // Mesure Button TouchDown
    // 計測開始
    @IBAction func beginMesure(_ sender: UIButton) {
        startLaser()
    }
    
    // Measure Button TouchUpInside
    @IBAction func touchUpInside(_ sender: UIButton) {
        stopLaser()
    }
    
    // Measure Button TouchUpOutside
    @IBAction func touchUpOutside(_ sender: UIButton) {
        stopLaser()
    }
    
    // MARK: - LaserBeam
    func startLaser() {
        laser.on()
        self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
        timer.fire()
    }
    
    func stopLaser() {
        laser.off()
        timer.invalidate()
    }
    
    // 画面の中心を取得する
    @objc func update(tm: Timer) {
        // featurePoint = アンカー（平面）に依存せず座標を取得
        let hitResults = sceneView.hitTest(sceneView.center, types: [.featurePoint])
        if !hitResults.isEmpty {
            if let hitResult = hitResults.first {
                let center = SCNVector3(hitResult.worldTransform.columns.3.x,
                                          hitResult.worldTransform.columns.3.y,
                                          hitResult.worldTransform.columns.3.z)
                self.laser.update(center: center)
                label.text = String.init(format: "%.2fm", arguments: [ hitResult.distance ])
            }
        }
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
