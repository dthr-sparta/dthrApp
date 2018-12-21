//
//  MyPageEditViewController.swift
//  dthrApp
//
//  Created by 小泉大夢 on 2018/12/15.
//  Copyright © 2018 Yoshiaki Kato. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD


class MyPageEditViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextViewDelegate {
    
    @IBOutlet var userPhote: UIImageView!
    @IBOutlet var userNameText: UITextField!
    @IBOutlet var profileText: UITextView!
    @IBOutlet var imageView: UIImageView!
    
    @IBAction func photeB(_ sender: Any) {
        let sourceType:UIImagePickerController.SourceType = UIImagePickerController.SourceType.photoLibrary
        // カメラが利用可能かチェック
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary){
            // インスタンスの作成
            let cameraPicker = UIImagePickerController()
            cameraPicker.sourceType = sourceType
            cameraPicker.delegate = self
            cameraPicker.allowsEditing = true
            self.present(cameraPicker, animated: true, completion: nil)
            
        }else{
                print("エラー")
        }
    }
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    func editDate(){
        
         let rootRef = Database.database().reference(fromURL:"https://cosco-22e74.firebaseio.com/").child("user")
//
        let storage = Storage.storage().reference(forURL: "gs://cosco-22e74.appspot.com")

        let key = rootRef.child("User").childByAutoId().key
        let imageRef = storage.child("Mypage").child("\(key).jpg")

        //datebaseにURLを送らなければならないのでdate型の変数を定義
        var data:NSData = NSData()
        if let image = imageView.image{

            //画像を圧縮している
            data = image.jpegData(compressionQuality: 0.01)! as NSData
        }
        //putDataでストレージサーバーに保存
        let uploadTask = imageRef.putData(data as Data, metadata: nil) { (metaData, error) in

            if error != nil{

                SVProgressHUD.show()
                return
            }

            //storageサーバーからURLをダウンロードしてくる
            imageRef.downloadURL(completion: { (url, error) in

                if url != nil{

                    let feed = ["userPhote":url?.absoluteString,"userName":self.userNameText.text,"profile":self.profileText.text] as [String:Any]
                    
                    let postFeed = ["\(key)":feed]
                    
                    //setValueは上書き
                    //
                    rootRef.setValue(postFeed)
                  

                    SVProgressHUD.dismiss()

                }

            })


        }




       uploadTask.resume()
        
        //すぐ遷移すると画像が更新されないため遷移を遅らせている。firebaseのラグ。
        SVProgressHUD.show()
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) {
            SVProgressHUD.dismiss()
           self.dismiss(animated: true, completion: nil)
            
        }
        

        
        

        
//        let feed = ["userName":userNameText.text,"profile":profileText.text] as [String:Any]
//        rootRef.setValue(feed)
//        dismiss(animated: true, completion: nil)
        
    }
    
    
    
    
    //写真を表示させるために必要
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let pickedImage = info[.originalImage] as? UIImage{
            
            //写真を映るようににする処理
            self.imageView.image = pickedImage
            
            //写真を圧縮している
            let imageData = pickedImage.jpegData(compressionQuality: 1.0)
            
            //定型文
            let documentURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
            
            
            picker.dismiss(animated: true, completion: nil)
            
        }
        
        
        
        
        
        
    }
    
    
    @IBAction func save(_ sender: Any) {
        editDate()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
