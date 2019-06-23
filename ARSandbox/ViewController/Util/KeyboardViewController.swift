//
//  KeyboardViewController.swift
//  ARSandbox
//
//  Created by Yuya Mimura on 2019/06/23.
//  Copyright © 2019 Yuya Mimura. All rights reserved.
//

import UIKit

class KeyboardViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // キーボード以外がタップされたら編集を終了する
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

}
