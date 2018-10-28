//
//  UserInfo.swift
//  MyMessenger
//
//  Created by 엄태형 on 2018. 10. 23..
//  Copyright © 2018년 엄태형. All rights reserved.
//

import Foundation

class UserManager {
    enum Constant: String {
        case UserInfo
    }
    static let shared = UserManager()
//    private init() {}
    var uid = ""
    var userInfo: String {
        get {
            if let info = UserDefaults.standard.string(forKey: Constant.UserInfo.rawValue) {
                return info
            }
            return ""
        }
        
        set {
            UserDefaults.standard.set(newValue, forKey: Constant.UserInfo.rawValue)
        }
    }
    
//    func setUserInfo(userInfo: String) {
//        UserDefaults.standard.set(userInfo, forKey: Constant.UserInfo.rawValue)
//    }
//
//    func getUserinfo() -> String {
//        UserDefaults.standard.string(forKey: Constant.UserInfo.rawValue)
//    }
    
    
}
