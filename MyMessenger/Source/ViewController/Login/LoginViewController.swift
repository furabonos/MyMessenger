//
//  LoginViewController.swift
//  MyMessenger
//
//  Created by 엄태형 on 2018. 10. 19..
//  Copyright © 2018년 엄태형. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var goBtnBottom: NSLayoutConstraint!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var idField: UITextField!
    
    private var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInitialize()
        ref = Database.database().reference()
        
        //로그아웃
//        let firebaseAuth = Auth.auth()
//        do {
//            try firebaseAuth.signOut()
//        } catch let signOutError as NSError {
//            print ("Error signing out: %@", signOutError)
//        }
        //
        
        if let user = Auth.auth().currentUser {
            idField.placeholder = "이미 로그인 된 상태입니다."
            passwordField.placeholder = "이미 로그인 된 상태입니다."
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        print("LoginViewController Deinit")
    }
    
    func setupInitialize() {
        self.ref = Database.database().reference()
        
        passwordField.delegate = self
        passwordField.isSecureTextEntry = true
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(noti:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
    }
    
    @objc func keyboardWillShow(_ sender: Notification) {
        self.view.frame.origin.y = -150 // Move view 150 points upward
    }
    @objc private func keyboardWillHide(noti: Notification) {
        self.view.frame.origin.y = self.view.frame.origin.y + 150
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func goLogin(_ sender: Any) {
        Auth.auth().signIn(withEmail: idField.text!, password: passwordField.text!) { (user, error) in
            if user != nil{
                print("login success")
                let currentUser = Auth.auth().currentUser
                currentUser?.getIDTokenForcingRefresh(true) { token, error in
                    if let error = error {
                        print("error = \(error)")
                        return;
                    }
                    guard let uid = user?.user.uid else { return }
                    UserManager.shared.uid = uid
                    print("login uid = \(uid)")
                    print("login uid2 = \(UserManager.shared.uid)")
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    let entryVC = MoveStoryboard.toVC(storybardName: "Profile", identifier: "ProfileViewController") as! ProfileViewController
                    let navigationController = UINavigationController(rootViewController: entryVC)
                    appDelegate.window?.rootViewController = navigationController
                }
                
//                let appDelegate = UIApplication.shared.delegate as! AppDelegate
//                let entryVC = MoveStoryboard.toVC(storybardName: "Profile", identifier: "ProfileViewController") as! ProfileViewController
//                let navigationController = UINavigationController(rootViewController: entryVC)
//                appDelegate.window?.rootViewController = navigationController
            }
            else{
                print("login fail")
            }
        }
    }
    
    
}
