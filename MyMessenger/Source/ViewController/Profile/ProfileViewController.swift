//
//  ProfileViewController.swift
//  MyMessenger
//
//  Created by 엄태형 on 2018. 10. 23..
//  Copyright © 2018년 엄태형. All rights reserved.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    deinit {
        print("ProfileViewController is deinit")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logOut(_ sender: Any) {
        //
        let alertController = UIAlertController(title: "로그아웃 하시겠습니까？",message: "로그인 화면으로 이동합니다.", preferredStyle: UIAlertControllerStyle.alert)
        
        //UIAlertActionStye.destructive 지정 글꼴 색상 변경
        let okAction = UIAlertAction(title: "예", style: UIAlertActionStyle.destructive){ (action: UIAlertAction) in
            let firebaseAuth = Auth.auth()
            do {
                try firebaseAuth.signOut()
            } catch let signOutError as NSError {
                print ("Error signing out: %@", signOutError)
            }
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let loginVC = MoveStoryboard.toVC(storybardName: "Login", identifier: "LoginViewController") as! LoginViewController
            let navigationController = UINavigationController(rootViewController: loginVC)
            appDelegate.window?.rootViewController = navigationController
        }
        
        let cancelButton = UIAlertAction(title: "취소", style: UIAlertActionStyle.cancel, handler: nil)
        
        alertController.addAction(okAction)
        alertController.addAction(cancelButton)
        
        self.present(alertController,animated: true,completion: nil)
        //
    }
    
    

}
