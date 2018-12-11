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
import TwitterKit
//import FirebaseUI

class ViewController: UIViewController {
    
    @IBOutlet var mailTextField: UITextField!
    
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var pasTextField: UITextField!
    
   
    @IBAction func twitterButton(_ sender: Any) {
        TWTRTwitter.sharedInstance().logIn { session, error in
            guard let session = session else {
                if let error = error {
                    print("エラーが起きました => \(error.localizedDescription)")
                }
                return
            }
            print("@\(session.userName)でログインしました")
            let credential = TwitterAuthProvider.credential(withToken: session.authToken, secret: session.authTokenSecret)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let logInButton = TWTRLogInButton(logInCompletion: { session, error in
            if (session != nil) {
                print("signed in as \(session!.userName)");
                print("成功だ\(session!.userName)")
                
                //twitterのユーザー名をfirebaseに保存
                let user = Auth.auth().currentUser
                if let user = user {
                    let changeRequest = user.createProfileChangeRequest()
                    changeRequest.displayName = session!.userName
                    changeRequest.commitChanges{ error in
                        if let error = error {
                            print(error)
                    
                            return
                        }
                        
                        //                        let when = DispatchTime.now() + 2
                        //                        DispatchQueue.main.asyncAfter(deadline: when) {
                        //                            self.present((self.storyboard?.instantiateViewController(withIdentifier: "FriendsViewController"))!,
                        //                                         animated: true,
                        //                                         completion: nil)}
                        
                        self.performSegue(withIdentifier: "timeLine", sender: nil)
                        
                    }
                    
                }
//                //firebaseに保存される
//                let authToken = session!.authToken
//                let authTokenSecret = session!.authTokenSecret
//
//                let credential = TwitterAuthProvider.credential(withToken: session!.authToken, secret: session!.authTokenSecret)
//
//                //firebaseに保存される
//                Auth.auth().signInAndRetrieveData(with: credential) { (authResult, error) in
//                    if let error = error {
//                        // ...
//                        return
//                    }
//                    // User is signed in
//                    // ...
//                }
//

            } else {
                print("error: \(error!.localizedDescription)");
                print("エラーだお: \(error!.localizedDescription)")
            }
        })
        logInButton.center = self.view.center
        self.view.addSubview(logInButton)
        
//        TWTRTwitter.sharedInstance().logIn(completion: { (session, error) in
//            if (session != nil) {
//                print("signed in as \(session!.userName)");
//            } else {
//                print("error: \(error!.localizedDescription)");
//            }
//        })
        
        //setup()
        
//        twitterLoginButton = TWTRLogInButton(logInCompletion: { session, error in
//            if (session != nil) {
//                let authToken = session?.authToken
//                let authTokenSecret = session?.authTokenSecret
//                // ...
//            } else {
//                // ...
//            }
//        })
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
    
//    func setup() {
//        let logInButton = TWTRLogInButton(logInCompletion: { session, error in
//
//            if let session = session {
//
//                let credential = TwitterAuthProvider.credential(withToken: session.authToken,
//                                                                            secret: session.authTokenSecret)
//
//                Auth.auth().signIn(with: credential) { (user, error) in
//
//                    if let error = error {
//                        //TOOD: エラーハンドリング
//                        print(error)
//                        return
//                    }
//
//                    print("ようこそ! \(user?.displayName)")
//                }
//
//            } else {
//                //TOOD: エラーハンドリング
//            }
//        })
    
//        logInButton.center = view.center
//        self.view.addSubview(logInButton)
    //}
    
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
    




