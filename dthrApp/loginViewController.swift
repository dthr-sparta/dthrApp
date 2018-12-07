//
//  loginViewController.swift
//  dthrApp
//
//  Created by 小泉大夢 on 2018/12/06.
//  Copyright © 2018 Yoshiaki Kato. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import SVProgressHUD

class loginViewController: UIViewController {
    
    @IBOutlet var mailTextField: UITextField!
    @IBOutlet var pasTextField: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //改行ボタンを完了ボタンに変更
        mailTextField.returnKeyType = .done
        pasTextField.returnKeyType = .done
        
        //textFieldに入力している文字を全消しするclearボタン(×)を設定(書いている時のみの設定)
        mailTextField.clearButtonMode = .whileEditing
        pasTextField.clearButtonMode = .whileEditing
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    //UItextField以外の部分をタッチした場合にキーボードを閉じる
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (mailTextField.isFirstResponder) {
            mailTextField.resignFirstResponder()
        }
        
        if (pasTextField.isFirstResponder) {
            pasTextField.resignFirstResponder()
        }
    }

    
    
    @IBAction func loginButton(_ sender: Any) {
        
        
        if let email = mailTextField.text,
            let password = pasTextField.text {
            
            
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
            pasTextField.layer.borderColor = UIColor.black.cgColor
            
            SVProgressHUD.show()
            
            // firebaseを呼び出し、登録されているメールアドレスとパスワードが合致すればログインする処理
            Auth.auth().signIn(withEmail: email, password: password) { user, error in
                if let error = error {
                    print(error)
                    
                    //ぐるぐるにError!という文字を表示
                    SVProgressHUD.showError(withStatus: "Error!")
                    return
                } else {
                    
                    //ぐるぐるにsuccess!という文字を表示
                    SVProgressHUD.showSuccess(withStatus: "Success!")
//                    let when = DispatchTime.now() + 2
//                    DispatchQueue.main.asyncAfter(deadline: when) {
//                        self.present((self.storyboard?.instantiateViewController(withIdentifier: "FriendsViewController"))!,
//                                     animated: true,
//                                     completion: nil)
                    
                    //ID名がtimeLineのsegueで画面遷移
                    self.performSegue(withIdentifier: "timeLine", sender: nil)
                    }
                }
            }
        }
    
    @IBAction func signupButton(_ sender: Any) {
        
        //戻る処理
        self.dismiss(animated: true, completion: nil)
    }
    
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


