//
//  RegisterNameViewController.swift
//  MyMessenger
//
//  Created by 엄태형 on 2018. 10. 22..
//  Copyright © 2018년 엄태형. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class RegisterNameViewController: UIViewController {

    @IBOutlet weak var nameImage: UIImageView!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var goBtn: UIButton!
    @IBOutlet weak var goBtnBottom: NSLayoutConstraint!
    
    private var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInitialize()
        addKeyboardObserver()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        print("RegisterNameViewController Deinit")
    }
    
    func setupInitialize() {
        ref = Database.database().reference()
//        goBtn.isEnabled = false
//        goBtn.setTitleColor(.gray, for: .normal)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    private func addKeyboardObserver() {
        func parsingKeyboardInfo(
            userInfo: [AnyHashable : Any]
            ) -> (frame: CGRect, duration: TimeInterval, option: UIViewAnimationOptions) {
            let keyboardFrame = userInfo[UIKeyboardFrameEndUserInfoKey] as! CGRect
            let duration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as! TimeInterval
            let curve = userInfo[UIKeyboardAnimationCurveUserInfoKey] as! UInt
            return (keyboardFrame, duration, UIViewAnimationOptions(rawValue: curve))
        }
        
        var noti: NSObjectProtocol!
        noti = NotificationCenter.default.addObserver(forName: .UIKeyboardWillShow, object: nil, queue: .main) { [weak self] in
            guard let userInfo = $0.userInfo, let strongSelf = self else { return }
            let keyboard = parsingKeyboardInfo(userInfo: userInfo)
            UIView.animate(withDuration: keyboard.duration, delay: 0, options: keyboard.option, animations: {
                strongSelf.goBtnBottom.constant = keyboard.frame.height - 80
                self?.view.frame.origin.y = -70
                strongSelf.view.layoutIfNeeded()
            })
        }
        
        noti = NotificationCenter.default.addObserver(forName: .UIKeyboardWillHide, object: nil, queue: .main) { [weak self] in
            guard let userInfo = $0.userInfo, let strongSelf = self else { return }
            let keyboard = parsingKeyboardInfo(userInfo: userInfo)
            UIView.animate(withDuration: keyboard.duration, delay: 0, options: keyboard.option, animations: {
                strongSelf.goBtnBottom.constant = 10
                self?.view.frame.origin.y = 0
                strongSelf.view.layoutIfNeeded()
            })
        }
    }
    
    @IBAction func textFieldDidChange(_ sender: UITextField) {
        if sender == nameField {
            
        }
    }
    
    @IBAction func goBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func goBtn(_ sender: Any) {
        UserDefaults.standard.set(nameField.text, forKey: "name")
        Auth.auth().createUser(withEmail: UserDefaults.standard.string(forKey: "email")!, password: UserDefaults.standard.string(forKey: "password")!
        ) { (user, error) in
            if user !=  nil{
                print("register success")
                
                guard let uid = user?.user.uid else { return }
                let registerUser = self.ref.child("Users")
                registerUser.child(uid).setValue(["name": UserDefaults.standard.string(forKey: "name")!,
                                                  "uid": uid])
                self.view.endEditing(true)

                // UserDefault내용 전체 삭제
                if let appDomain = Bundle.main.bundleIdentifier {
                    UserDefaults.standard.removePersistentDomain(forName: appDomain)
                }
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                let entryVC = MoveStoryboard.toVC(storybardName: "Login", identifier: "LoginViewController") as! LoginViewController
                let navigationController = UINavigationController(rootViewController: entryVC)
                appDelegate.window?.rootViewController = navigationController
            }
            else{
                print("register failed")
            }
        }
    }
}
