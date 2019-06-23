//
//  SetSizeViewController.swift
//  ARSandbox
//
//  Created by Yuya Mimura on 2019/06/22.
//  Copyright © 2019 Yuya Mimura. All rights reserved.
//

import UIKit

class SetSizeViewController: KeyboardViewController {

    // MARK: - Control

    // 幅入力用(cm)
    @IBOutlet weak var widthInput: UITextField!
    // 高さ入力用(cm)
    @IBOutlet weak var heightInput: UITextField!
    // 奥行き入力用(cm)
    @IBOutlet weak var lengthInput: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - EventListerner

    // ボタンタップイベント
    @IBAction func showButtonTouchDown(_ sender: UIButton) {
        guard let width = widthInput.text, let height = heightInput.text, let length = lengthInput.text else {
            showAlert(title: "エラー", message: "全項目を入力してください。")
            return
        }
        
        if width.isEmpty, height.isEmpty, length.isEmpty {
            showAlert(title: "エラー", message: "全項目を入力してください。")
            return
        }
        
        UserDefaultsUtil.width = width.floatValue
        UserDefaultsUtil.height = height.floatValue
        UserDefaultsUtil.length = length.floatValue
        
        performSegue(withIdentifier: "ShowReallitySegue", sender: nil)
    }
    
    // アラート表示
    func showAlert(title: String, message: String) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        ac.addAction(action)
        present(ac, animated: true)
    }
}

// String拡張
extension String {
    // String -> Float
    var floatValue: Float {
        return (self as NSString).floatValue
    }
}

