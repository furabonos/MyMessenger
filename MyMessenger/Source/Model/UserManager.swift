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
        case UserName
        case UserUid
        case UserMail
        case UserImageURL
    }
    static let shared = UserManager()
    var userName: String {
        get {
            if let name = UserDefaults.standard.string(forKey: Constant.UserName.rawValue) {
                return name
            }
            return ""
        }
        
        set {
            UserDefaults.standard.set(newValue, forKey: Constant.UserName.rawValue)
        }
    }
    var userUid: String {
        get {
            if let uid = UserDefaults.standard.string(forKey: Constant.UserUid.rawValue) {
                return uid
            }
            return ""
        }
        
        set {
            UserDefaults.standard.set(newValue, forKey: Constant.UserUid.rawValue)
        }
    }
    var userMail: String {
        get {
            if let uid = UserDefaults.standard.string(forKey: Constant.UserMail.rawValue) {
                return uid
            }
            return ""
        }
        
        set {
            UserDefaults.standard.set(newValue, forKey: Constant.UserMail.rawValue)
        }
    }
    
    var userImageURL: String {
        get {
            if let uid = UserDefaults.standard.string(forKey: Constant.UserImageURL.rawValue) {
                return uid
            }
            return ""
        }
        
        set {
            UserDefaults.standard.set(newValue, forKey: Constant.UserImageURL.rawValue)
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
