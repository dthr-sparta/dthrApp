//
//  MypageViewController.swift
//  dthrApp
//
//  Created by 小泉大夢 on 2018/12/15.
//  Copyright © 2018 Yoshiaki Kato. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage
import FirebaseAuth

class MypageViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    var userProfile = String()
    var userName = String()
    var userImage:String = String()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return 1
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    @IBOutlet var tableView: UITableView!
    
    
    @IBAction func back(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        print("きてる")
        
       // tableView.reloadData()
        //データをとってくる
        fetchPost()
        
        
        
        print("いいね")
        //print("\(posst.userName)")
        
    }
    
    
    
    
    func fetchPost(){
        
        
        
       // postの投稿をとってくる処理。googlService-info.plistを参照してデータを取ってくる場所を特定している。
        let ref = Database.database().reference()
//        ref.child("user").queryLimited(toFirst: 10).observeSingleEvent(of: .value) { (snap,error) in
       print("ieeee")
        ref.child("user").observeSingleEvent(of: .value) { (snap,error) in
            
            //snapの中にすべてのデータが入っている。その中身(value)をpostSnapに代入する処理
            //keyがStringでpProfileなどがNSDictionaryかな？
            let postsSnap = snap.value as? [String:NSDictionary]
            
            print("いええええ\(postsSnap)")
            if postsSnap == nil{
                print("sippai")
                return
            }

       


            for (_,post) in postsSnap!
            {
            print("こら\(post["userName"])\(post["profile"])\(post["mypagePhote"])")
            if let userName = post["userName"],let profile = post["profile"],let mypagePhote = post["userPhote"]{



                
                self.userImage = mypagePhote as! String
                self.userName = userName as! String
                self.userProfile = profile as! String
                
                
                 self.tableView.reloadData()
                }

            }
        }

        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //各行に表示するセルを返す
        
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        
            
            print("テーブル")
        let profileImageView = cell.viewWithTag(1) as! UIImageView
        let profileImageURL = URL(string: userImage as String)
        profileImageView.sd_setImage(with: profileImageURL, completed: nil)
        profileImageView.layer.cornerRadius = 8.0
        profileImageView.clipsToBounds = true
        
        
        let userNameLabel = cell.viewWithTag(2) as! UILabel
        userNameLabel.text = self.userName
        
        let userProfileLabel = cell.viewWithTag(3) as! UILabel
        userProfileLabel.text = self.userProfile
        
        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        //cellの縦の長さ
        return 560
        
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
