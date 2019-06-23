//
//  UserDefaultsUtil.swift
//  ARSandbox
//
//  Created by Yuya Mimura on 2019/06/22.
//  Copyright © 2019 Yuya Mimura. All rights reserved.
//

import UIKit

class UserDefautlsKey {
    static let width = "width"
    static let height = "height"
    static let length = "length"
}

class UserDefaultsUtil {
    
    private init() {
        // インスタンス生成禁止
        self.initialize()
    }
    
    private func initialize() {
        UserDefaults.standard.register(defaults: [
            UserDefautlsKey.width: 1,
            UserDefautlsKey.height: 1,
            UserDefautlsKey.length: 1
        ])
    }
    
    // 幅
    class var width: Float {
        get {
            return UserDefaults.standard.float(forKey: UserDefautlsKey.width)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefautlsKey.width)
            UserDefaults.standard.synchronize()
        }
    }
    
    // 高さ
    class var height: Float {
        get {
            return UserDefaults.standard.float(forKey: UserDefautlsKey.height)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefautlsKey.height)
            UserDefaults.standard.synchronize()
        }
    }
    
    // 奥行き
    class var length: Float {
        get {
            return UserDefaults.standard.float(forKey: UserDefautlsKey.length)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefautlsKey.length)
            UserDefaults.standard.synchronize()
        }
    }
}
