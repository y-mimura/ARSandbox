//
//  RecordingButton.swift
//  ARSandbox
//
//  Created by 三村裕矢 on 2019/03/23.
//  Copyright © 2019 Yuya Mimura. All rights reserved.
//

import UIKit
import ReplayKit

class RecordingButton: UIButton {

    var isRecording = false
    let height:CGFloat = 50.0
    let width:CGFloat = 80.0
    let viewController: UIViewController!
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(_ viewController: UIViewController) {
        self.viewController = viewController
        
        super.init(frame: CGRect(x: 0, y: 0, width: width, height: height))
        layer.position = CGPoint(x: width/2, y:viewController.view.frame.height - height)
        
        layer.cornerRadius = 10
        layer.borderWidth = 1
        setTitleColor(UIColor.white, for: .normal)
        
        addTarget(self, action: #selector(tapped), for: .touchUpInside)
        setAppearance()
        viewController.view.addSubview(self)
    }
    
    @objc func tapped() {
        if !isRecording {
            isRecording = true
            RPScreenRecorder.shared().startRecording { (error) in
                if let e = error {
                    print(e)
                }
                else {
                    print("error")
                }
            }
        }
        else {
            isRecording = false
            RPScreenRecorder.shared().stopRecording { (previewViewController, error) in
                previewViewController?.previewControllerDelegate = self
                self.viewController.present(previewViewController!, animated: true, completion: nil)
            }
        }
        setAppearance()
    }
    
    func setAppearance() {
        var alpha: CGFloat = 1.0
        var title = "REC"
        if isRecording {
            alpha = 0
            title = ""
        }
        setTitle(title, for: .normal)
        backgroundColor = UIColor(red: 0.7, green: 0, blue: 0, alpha: alpha)
        layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: alpha).cgColor
    }
}

extension RecordingButton : RPPreviewViewControllerDelegate {
    func previewControllerDidFinish(_ previewController: RPPreviewViewController) {
        DispatchQueue.main.async {
            previewController.dismiss(animated: true, completion: nil)
        }
    }
}
