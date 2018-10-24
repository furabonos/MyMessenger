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
        ref = Database.database().reference()
        setupInitialize()
        passwordField.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        //로그아웃
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        
        if let user = Auth.auth().currentUser {
            idField.placeholder = "이미 로그인 된 상태입니다."
            passwordField.placeholder = "이미 로그인 된 상태입니다."
        }
    }
    
    func setupInitialize() {
        passwordField.isSecureTextEntry = true
        
    }
    
    @objc func keyboardWillShow(_ sender: Notification) {
        self.view.frame.origin.y = -150 // Move view 150 points upward
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.frame.origin.y = self.view.frame.origin.y + 150
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
//                    print("token = \(token!)")
//                    print("name = \(UserDefaults.standard.string(forKey: "name")!)")
                    guard let tokens = token else { return }
                    print("tokens = \(tokens)")
                    let currentUser = self.ref.child("Users").child(tokens)
//                    currentUser.setValue([
//                        "token": tokens,
//                        "name": UserDefaults.standard.string(forKey: "name")!
//                        ])
                }
                
            }
            else{
                print("login fail")
            }
        }
//        Auth.auth().signIn(withEmail: self.idField.text!, password: self.passwordField.text!) { (result) in
//            switch result {
//            case .success(let value):
//                print("로그인 성공")
//
//                UserDefaults.standard.set(value.token, forKey: "CurrentUserToken")
//                print("CurrentUserToken : ",UserDefaults.standard.string(forKey: "CurrentUserToken"))
//                let currentUser = self.ref.child("Users").child(value.token)
//                currentUser.setValue([
//                    "token":value.token,
//                    "firstName":value.user.firstName,
//                    "lastName":value.user.lastName,
//                    "profileImage":value.user.profileImage ?? "",
//                    "birthday":value.user.birthday ?? "",
//                    "isHost":value.user.isHost,
//                    "createDate":value.user.createDate])
//
//                let mainVC = MoveStoryboard.toVC(storybardName: "Main", identifier: "MainExploring")
//                self.show(mainVC, sender: nil)
//
//
//            case .failure(let response, let error):
//                print(error)
//            }
//
//    }
    }
    

}
