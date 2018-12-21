//
//  MakeViewController.swift
//  dthrApp
//
//  Created by 小泉大夢 on 2018/12/07.
//  Copyright © 2018 Yoshiaki Kato. All rights reserved.
//

import UIKit
import Photos
import SVProgressHUD
import Firebase
import FirebaseStorage


class MakeViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextViewDelegate {
    
    @IBOutlet var imageView: UIImageView!
    
    @IBOutlet var eventNameText: UITextField!
    @IBOutlet var timeText: UITextField!
    @IBOutlet var placeText: UITextField!
    @IBOutlet var peopleText: UITextField!
    @IBOutlet var priceText: UITextField!
    @IBOutlet var detailsText: UITextView!
    
    var postImage_Array = [String]()
    var eventName_Array = [String]()
    var time_Array = [String]()
    var place_Array = [String]()
    var people_Array = [String]()
    var price_Array = [String]()
    var details_Array = [String]()
    
    var postImageURL:URL!
    var passImage = UIImage()
    var eventName = String()
    var time = String()
    var place = String()
    var people = String()
    var price = String()
    var details = String()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //これよくわからん
        //detailsText.delegate = self
        
        PHPhotoLibrary.requestAuthorization { (status) in
            
            switch(status){
            case .authorized
                :break
            case .denied
                :break
            case .notDetermined
                :break
            case .restricted
                :break
            }
            
            
        }

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func photo(_ sender: Any) {
        
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
    
    
    
    
    func postData(){
        
        let rootRef = Database.database().reference(fromURL:"https://cosco-22e74.firebaseio.com/").child("post")
        let storage = Storage.storage().reference(forURL: "gs://cosco-22e74.appspot.com")
        
        //key何のためにあるかわからない。
        let key = rootRef.child("User").childByAutoId().key
        let imageRef = storage.child("Users").child("\(key).jpg")
        
        var data:NSData = NSData()
        if let image = imageView.image{
            
            data = image.jpegData(compressionQuality: 0.01)! as NSData
        }
        
        
        //putDataでStorageサーバーに保存している
        let uploadTask = imageRef.putData(data as Data, metadata: nil) { (metaData, error) in
            
            if error != nil{
                
                SVProgressHUD.show()
                return
            }
            
            imageRef.downloadURL(completion: { (url, error) in
                
                if url != nil{
                    
                    let feed = ["postImage":url?.absoluteString,"details":self.detailsText.text,"eventName":self.eventNameText.text,"time":self.timeText.text,"price":self.priceText.text,"place":self.placeText.text,"people":self.peopleText.text] as [String:Any]
                    let postFeed = ["\(key)":feed]
                    
                    //データの上書きでなく追加
                    rootRef.updateChildValues(postFeed)
                    
                    SVProgressHUD.dismiss()
                    
                }
                
            })
            
        }
        
        
        
        uploadTask.resume()
        self.dismiss(animated: true, completion: nil)
        
        
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
    
    @IBAction func postButton(_ sender: Any) {
        postData()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        detailsText.resignFirstResponder()
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
