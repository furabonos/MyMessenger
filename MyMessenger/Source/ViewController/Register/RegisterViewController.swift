//
//  RegisterViewController.swift
//  MyMessenger
//
//  Created by 엄태형 on 2018. 10. 21..
//  Copyright © 2018년 엄태형. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import NVActivityIndicatorView

class RegisterViewController: UIViewController {

    @IBOutlet weak var goBtnBottom: NSLayoutConstraint!
    @IBOutlet weak var goBtn: UIButton!
    @IBOutlet weak var emailImage: UIImageView!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var passwordImage: UIImageView!
    
    private var ref: DatabaseReference!
    private var activityView: NVActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addKeyboardObserver()
        setupInitialize()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        print("RegisterViewController Deinit")
    }
    
    func goNext() {
        if emailImage.image == UIImage(named: "Check.png") , passwordImage.image == UIImage(named: "Check.png") {
            goBtn.isEnabled = true
            goBtn.setTitleColor(.white, for: .normal)
        }
    }
    
    func setupInitialize() {
        ref = Database.database().reference()
        goBtn.isEnabled = false
        goBtn.setTitleColor(.gray, for: .normal)
        passwordField.isSecureTextEntry = true
        setupActivityIndicator()
    }
    
    private func setupActivityIndicator() {
        activityView = NVActivityIndicatorView(frame: CGRect(x: self.view.center.x - 50, y: self.view.center.y - 50, width: 100, height: 100), type: NVActivityIndicatorType.circleStrokeSpin, color: UIColor(red: 0/255.0, green: 132/255.0, blue: 137/255.0, alpha: 1), padding: 25)
        
        activityView.backgroundColor = .white
        activityView.layer.cornerRadius = 10
        self.view.addSubview(activityView)
    }
    
    @IBAction func closeBtn(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func nextBtn(_ sender: Any) {
        UserDefaults.standard.set(emailField.text, forKey: "email")
        UserDefaults.standard.set(passwordField.text, forKey: "password")
        activityView!.startAnimating()
        //
        Auth.auth().createUser(withEmail: UserDefaults.standard.string(forKey: "email")!, password: UserDefaults.standard.string(forKey: "password")!
        ) { (user, error) in
            if user !=  nil{
                print("register success")
                guard let uid = user?.user.uid else { return }
                UserDefaults.standard.set(uid, forKey: "uid")
                self.view.endEditing(true)
                self.activityView.stopAnimating()
                let registerNameVC = MoveStoryboard.toVC(storybardName: "Register", identifier: "RegisterNameViewController")
                self.navigationController?.pushViewController(registerNameVC, animated: true)
            }
            else{
                print("register failed")
                self.activityView.stopAnimating()
                //
                let alertController = UIAlertController(title: "경고",message: "중복된 이메일이 있습니다.", preferredStyle: UIAlertControllerStyle.alert)
                let cancelButton = UIAlertAction(title: "확인", style: UIAlertActionStyle.cancel, handler: nil)
                alertController.addAction(cancelButton)
                self.present(alertController,animated: true,completion: nil)
                //
            }
        }
        //
        
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
        if sender == emailField {
            if (emailField.text?.emailReg())! {
                emailImage.image = UIImage(named: "Check.png")
                goNext()
            }else {
                emailImage.image = UIImage(named: "close_White.png")
            }
        }else {
            if (passwordField.text?.passwordReg())! {
                passwordImage.image = UIImage(named: "Check.png")
                goNext()
            }else {
                passwordImage.image = UIImage(named: "close_White.png")
            }
        }
    }
    
    
   
    
}
