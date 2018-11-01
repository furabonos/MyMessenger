//
//  UserService.swift
//  MyMessenger
//
//  Created by 엄태형 on 2018. 10. 28..
//  Copyright © 2018년 엄태형. All rights reserved.
//

import Foundation
import Firebase

class UserServices {
    static var currentUserInfo: UserInfo?
    
    static func observerUserInfo(_ uid: String, completion: @escaping ((_ userInfo: UserInfo?)->())) {
        let ref = Database.database().reference().child("Users/\(uid)")
        
        ref.observe(.value, with: { snapshot in
            var userInfo: UserInfo?
            if let dict = snapshot.value as? [String: Any],
                let name = dict["name"] as? String,
                let uid = dict["uid"] as? String,
                let mail = dict["mail"] as? String,
                let url = dict["profileURL"] as? String {
                userInfo = UserInfo(uid: uid, name: name, mail: mail, url: url)
            }
            completion(userInfo)
        })
    }
}
