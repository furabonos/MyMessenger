//
//  UserInfo.swift
//  MyMessenger
//
//  Created by 엄태형 on 2018. 10. 23..
//  Copyright © 2018년 엄태형. All rights reserved.
//

import Foundation

class UserSingleton {
    static let shared = UserSingleton()
    private init() {}
    var token = ""
    var name = ""
}
