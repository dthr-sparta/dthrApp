//
//  ViewController.swift
//  dthrApp
//
//  Created by Yoshiaki Kato on 2018/12/04.
//  Copyright © 2018 Yoshiaki Kato. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import SVProgressHUD

class ViewController: UIViewController {
    
    @IBOutlet var mailTextField: UITextField!
    
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var pasTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //改行ボタンを完了ボタンに変更
        mailTextField.returnKeyType = .done
        nameTextField.returnKeyType = .done
        pasTextField.returnKeyType = .done
        
        //textFieldに入力している文字を全消しするclearボタン(×)を設定(書いている時のみの設定)
        mailTextField.clearButtonMode = .whileEditing
        nameTextField.clearButtonMode = .whileEditing
        pasTextField.clearButtonMode = .whileEditing
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    //UItextField以外の部分をタッチした場合にキーボードを閉じる
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (mailTextField.isFirstResponder) {
            mailTextField.resignFirstResponder()
        }
        if (nameTextField.isFirstResponder) {
            nameTextField.resignFirstResponder()
        }
        if (pasTextField.isFirstResponder) {
            pasTextField.resignFirstResponder()
        }
            }

    
    @IBAction func signupButton(_ sender: Any) {
        
        if let email = mailTextField.text,
            let username = nameTextField.text,
            let password = pasTextField.text {
            if username.isEmpty {
                SVProgressHUD.showError(withStatus: "Oops!")
                nameTextField.layer.borderColor = UIColor.red.cgColor
                return
            }
            if email.isEmpty {
                SVProgressHUD.showError(withStatus: "Oops!")
                mailTextField.layer.borderColor = UIColor.red.cgColor
                return
            }
            if password.isEmpty {
                SVProgressHUD.showError(withStatus: "Oops!")
                pasTextField.layer.borderColor = UIColor.red.cgColor
                return
            }
            mailTextField.layer.borderColor = UIColor.black.cgColor
            nameTextField.layer.borderColor = UIColor.black.cgColor
            pasTextField.layer.borderColor = UIColor.black.cgColor
            
            //ぐるぐる回る
            SVProgressHUD.show()
            
            // ユーザー作成
            Auth.auth().createUser(withEmail: email, password: password) { user, error in
                if let error = error {
                    print(error)
                    SVProgressHUD.showError(withStatus: "Error!")
                    return
                }
                // ユーザーネームを設定
                let user = Auth.auth().currentUser
                if let user = user {
                    let changeRequest = user.createProfileChangeRequest()
                    changeRequest.displayName = username
                    changeRequest.commitChanges { error in
                        if let error = error {
                            print(error)
                            SVProgressHUD.showError(withStatus: "Error!")
                            return
                        }
                        SVProgressHUD.showSuccess(withStatus: "Success!")
                        
//                        let when = DispatchTime.now() + 2
//                        DispatchQueue.main.asyncAfter(deadline: when) {
//                            self.present((self.storyboard?.instantiateViewController(withIdentifier: "FriendsViewController"))!,
//                                         animated: true,
                        //                                         completion: nil)}
                        
                         self.performSegue(withIdentifier: "timeLine", sender: nil)
                        
                    }
                } else {
                    print("Error - User not found")
                }
                //ぐるぐる止まる
                SVProgressHUD.dismiss()
            }
        }
    }
    }
    




