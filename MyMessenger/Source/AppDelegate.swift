//
//  AppDelegate.swift
//  MyMessenger
//
//  Created by 엄태형 on 2018. 10. 19..
//  Copyright © 2018년 엄태형. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        //
//        let authListener = Auth.auth().addStateDidChangeListener { (auth, user) in
//            if user != nil {
//                UserServices.observerUserInfo(user!.uid, completion: { (userInfo) in
//                    UserServices.currentUserInfo = userInfo
//                })
//                let storyboard = UIStoryboard(name: "Profile", bundle: nil)
//                let controller = storyboard.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
//                self.window?.rootViewController = controller
//                self.window?.makeKeyAndVisible()
//            }else {
//                let storyboard = UIStoryboard(name: "Login", bundle: nil)
//                let controller = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
//                self.window?.rootViewController = controller
//                self.window?.makeKeyAndVisible()
//            }
//        }
        if let user = Auth.auth().currentUser {
            print("now login = \(user.uid)")
            UserServices.observerUserInfo(user.uid, completion: { (userInfo) in
                App.userManager.userInfo = (userInfo?.uid)!
            })
            let storyboard = UIStoryboard(name: "Profile", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
            self.window?.rootViewController = controller
            self.window?.makeKeyAndVisible()
        }
        //
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

