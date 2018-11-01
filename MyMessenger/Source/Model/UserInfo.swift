//
//  UserInfo.swift
//  MyMessenger
//
//  Created by 엄태형 on 2018. 10. 28..
//  Copyright © 2018년 엄태형. All rights reserved.
//

import Foundation

class UserInfo {
    var uid: String
    var name: String
    var mail: String
    var url: String
    
    init(uid: String, name: String, mail: String, url: String) {
        self.uid = uid
        self.name = name
        self.mail = mail
        self.url = url
    }
}
