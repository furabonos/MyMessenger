//
//  ProfileEditViewController.swift
//  MyMessenger
//
//  Created by 엄태형 on 2018. 10. 24..
//  Copyright © 2018년 엄태형. All rights reserved.
//

import UIKit
import MobileCoreServices
import Firebase
import FirebaseAuth
import FirebaseStorage
import NVActivityIndicatorView

class ProfileEditViewController: UIViewController {

    
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    
    let picker = UIImagePickerController()
    var selectedImage = UIImage()
    let user = Auth.auth().currentUser
    
    private var ref: DatabaseReference!
    private var activityView: NVActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInitialize()
        ref = Database.database().reference()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        idLabel.text = "\(App.userManager.userMail)"
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        let tappedImage = tapGestureRecognizer.view as! UIImageView
        //
        let alert =  UIAlertController(title: "원하는 타이틀", message: "원하는 메세지", preferredStyle: .actionSheet)
        let library =  UIAlertAction(title: "사진앨범", style: .default) { (action) in self.openLibrary()
        }
        
        let camera =  UIAlertAction(title: "카메라", style: .default) { (action) in
            self.openCamera()
        }
        
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        alert.addAction(library)
        alert.addAction(camera)
        alert.addAction(cancel)
        
        present(alert, animated: true, completion: nil)
        //
    }
    
    func openLibrary(){
        picker.sourceType = .photoLibrary
        present(picker, animated: false, completion: nil)
    }
    
    func openCamera(){
        picker.sourceType = .camera
        present(picker, animated: false, completion: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        print("ProfileEditViewController is deinit")
    }
    
    func setupInitialize() {
        
//        profileImageView.layer.cornerRadius = 0.5 * profileImageView.bounds.size.width
//        profileImageView.clipsToBounds = true
        
        passwordField.isSecureTextEntry = true
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(noti:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        picker.delegate = self
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        profileImageView.isUserInteractionEnabled = true
        profileImageView.addGestureRecognizer(tapGestureRecognizer)
        
        setupActivityIndicator()
    }
    
    private func setupActivityIndicator() {
        activityView = NVActivityIndicatorView(frame: CGRect(x: self.view.center.x - 50, y: self.view.center.y - 50, width: 100, height: 100), type: NVActivityIndicatorType.circleStrokeSpin, color: UIColor(red: 0/255.0, green: 132/255.0, blue: 137/255.0, alpha: 1), padding: 25)
        
        activityView.backgroundColor = .white
        activityView.layer.cornerRadius = 10
        self.view.addSubview(activityView)
    }
    
    @objc func keyboardWillShow(_ sender: Notification) {
        self.view.frame.origin.y = -150 // Move view 150 points upward
    }
    @objc private func keyboardWillHide(noti: Notification) {
        self.view.frame.origin.y = self.view.frame.origin.y + 150
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    @IBAction func editBtn(_ sender: Any) {
        activityView.startAnimating()
        let storageRef = Storage.storage().reference().child("\(App.userManager.userUid)/profileImage")
        if let uploadData = UIImagePNGRepresentation(self.profileImageView.image!) {
            storageRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                if error != nil {
                    print("error = \(error)")
                    return
                }
                print("metadata = \(metadata)")
                storageRef.downloadURL(completion: { (url, error) in
                    if let error = error {
                        print("urlerror = \(error)")
                    }else {
                        guard let url = url else { return }
                        let userRef = self.ref.child("Users").child(App.userManager.userUid)
                        userRef.updateChildValues(["profileURL": "\(url)"])
                        self.activityView.stopAnimating()
                    }
                })
            })
        }
        
        //
//        let currentUser = self.ref.child("Users").child(App.userManager.userUid)
//        currentUser.updateChildValues(["name": nameField.text!])
        //
//        if (passwordField.text?.passwordReg())! {
//        user?.updatePassword(to: passwordField.text!) { (error) in
//            if let error = error {
//                print("error")
//                //
//                let alertController = UIAlertController(title: "경고",message: "수정에 실패하였습니다.", preferredStyle: UIAlertControllerStyle.alert)
//                let cancelButton = UIAlertAction(title: "확인", style: UIAlertActionStyle.cancel, handler: nil)
//                alertController.addAction(cancelButton)
//                self.present(alertController,animated: true,completion: nil)
//                //
//            }else {
//                print("change")
//                //
//                let alertController = UIAlertController(title: "확인",message: "수정에 성공하였습니다.", preferredStyle: UIAlertControllerStyle.alert)
//                let cancelButton = UIAlertAction(title: "확인", style: UIAlertActionStyle.cancel, handler: nil)
//                alertController.addAction(cancelButton)
//                self.present(alertController,animated: true,completion: nil)
//                //
//            }
//        }
//            }else {
//
//            }
    }
    

}

extension ProfileEditViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
            let mediaType = info[UIImagePickerControllerMediaType] as! NSString
            if UTTypeEqual(mediaType, kUTTypeMovie) {
                let url = info[UIImagePickerControllerMediaURL] as! NSURL
                if let path = url.path {
                    UISaveVideoAtPathToSavedPhotosAlbum(path, nil, nil, nil)
                }
            } else {
                let originalImage = info[UIImagePickerControllerOriginalImage] as? UIImage
                let editedImage = info[UIImagePickerControllerEditedImage] as? UIImage
                selectedImage = editedImage ?? originalImage!
                profileImageView.image = selectedImage
            }
        }
        dismiss(animated: true, completion: nil)
    }
}

