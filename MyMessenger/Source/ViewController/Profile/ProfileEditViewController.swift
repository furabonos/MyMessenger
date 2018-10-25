//
//  ProfileEditViewController.swift
//  MyMessenger
//
//  Created by 엄태형 on 2018. 10. 24..
//  Copyright © 2018년 엄태형. All rights reserved.
//

import UIKit
import MobileCoreServices

class ProfileEditViewController: UIViewController {

    
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    
    let picker = UIImagePickerController()
    var selectedImage = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInitialize()
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
        print("ProfileEditViewController is deinit")
    }
    
    func setupInitialize() {
        profileImageView.layer.cornerRadius = 0.5 * profileImageView.bounds.size.width
        profileImageView.clipsToBounds = true
        
        passwordField.isSecureTextEntry = true
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(noti:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        picker.delegate = self
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        profileImageView.isUserInteractionEnabled = true
        profileImageView.addGestureRecognizer(tapGestureRecognizer)
        
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
        if (passwordField.text?.passwordReg())! {
            print("correct pwd")
        }
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

