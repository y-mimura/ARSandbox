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
    @IBOutlet weak var floorSwitch: UISwitch!
    @IBOutlet weak var sizeLabel: UILabel!
    @IBOutlet weak var sizeStepper: UIStepper!
    
    var recordingButton: RecordingButton!
    var planeNodes:[PlaneNode] = []
    var diceSize: CGFloat = 0.15
    var dices : [Dice] = []
    var timer: Timer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.delegate = self
        // デバッグ用の情報を表示する
        sceneView.showsStatistics = true
        sceneView.autoenablesDefaultLighting = true
        
        let scene = SCNScene()
        sceneView.scene = scene
        
        addTapGesture()
        
        sizeStepper.value = Double(diceSize)
        dispSize()
        
        // 録画ボタン
        self.recordingButton = RecordingButton(self)
    }
    
    /*
     * TapGestureRecognizerを登録する
     */
    func addTapGesture() {
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapped))
        self.sceneView.addGestureRecognizer(tapRecognizer)
    }
    
    /*
     * 検出した水平面の表示/非表示切り替え
     */
    @IBAction func floorSwitchChanged(_ sender: UISwitch) {
        for planeNode in self.planeNodes {
            planeNode.isDisplay = sender.isOn
        }
    }
    
    /*
     * サイコロのサイズを調整する
     */
    @IBAction func sizeStepperChanged(_ sender: UIStepper) {
        self.diceSize = CGFloat(sender.value)
        dispSize()
    }
    
    /*
     * サイコロのサイズを表示する
     */
    func dispSize() {
        self.sizeLabel.text = String.init(format: "%.2fm", diceSize)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        // 平面の検出を有効化する
        configuration.planeDetection = .horizontal
        
        // Run the view's session
        sceneView.session.run(configuration)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    /*
     * 画面タップ時の処理
     */
    @objc func tapped(recognizer: UITapGestureRecognizer) {
        if dices.count > 0 {
            // すでにサイコロがノードに配置されていたら削除する
            for dice in dices {
                dice.removeFromParentNode()
            }
            dices.removeAll()
            // 削除して終了
            return
        }
        
        guard let sceneView = recognizer.view as? ARSCNView else {
            print("cannot get sceneView from recognizer")
            return
        }
        // タップされた画面上の場所を抽出
        let touchLocation = recognizer.location(in: sceneView)
        
        // タップされた箇所の平面を検出
        let hitTestResult = sceneView.hitTest(touchLocation, types: .existingPlaneUsingExtent)
        
        if !hitTestResult.isEmpty {
            if let hitResult = hitTestResult.first {
                for _ in [0,1] {
                    // サイコロをrootNodeに2つ追加する
                    let dice = Dice(size: diceSize, hitResult: hitResult)
                    dices.append(dice)
                    sceneView.scene.rootNode.addChildNode(dice)
                    usleep(100000)
                }
            }
        }
    }
}

extension ViewController: ARSCNViewDelegate {
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        DispatchQueue.main.async {
            if !self.floorSwitch.isOn {
                return
            }
            if let planeAnchor = anchor as? ARPlaneAnchor {
                // 平面を表現するノードを追加する
                let planeNode = PlaneNode(anchor: planeAnchor)
                planeNode.isDisplay = self.floorSwitch.isOn
                
                node.addChildNode(planeNode)
                self.planeNodes.append(planeNode)
            }
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        DispatchQueue.main.async {
            if !self.floorSwitch.isOn {
                return
            }
            if let planeAnchor = anchor as? ARPlaneAnchor, let planeNode = node.childNodes[0] as? PlaneNode {
                print("planeNode update")
                
                print(String(format: "PlaneNode x:%f y:%f z:%f", planeNode.position.x, planeNode.position.y, planeNode.position.z))
                print(String(format: "PlaneAnchor x:%f y:%f z:%f", planeAnchor.extent.x, planeAnchor.extent.y, planeAnchor.extent.z))
                
                // ノードの位置及び形状を修正する
                planeNode.update(anchor: planeAnchor)
            }
        }
    }
}
