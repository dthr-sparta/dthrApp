//
//  TimeLineViewController.swift
//  dthrApp
//
//  Created by 小泉大夢 on 2018/12/07.
//  Copyright © 2018 Yoshiaki Kato. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import SDWebImage

//読み込み時にぐるぐる回るアニメーション
import SVProgressHUD

class TimeLineViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    
    @IBAction func refleshB(_ sender: Any) {
        refleshControl.addTarget(self, action: #selector(reflesh), for: .valueChanged)
        
        tableView.addSubview(refleshControl)
    }
    
    
    
    @IBOutlet var tableView: UITableView!
    
    //引っ張って更新するためのもの
    let refleshControl = UIRefreshControl()
    
    var postImage_Array = [String]()
    var eventName_Array = [String]()
    var time_Array = [String]()
    var place_Array = [String]()
    var people_Array = [String]()
    var price_Array = [String]()
    var details_Array = [String]()

    
    var posts = [Post]()
    var posst = Post()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        //引っ張って更新するときに表示される言葉
        refleshControl.attributedTitle = NSAttributedString(string: "引っ張って更新")
        
        
        //selector()のカッコ内の関数が呼ばれる
        refleshControl.addTarget(self, action: #selector(reflesh), for: .valueChanged)
        
        tableView.addSubview(refleshControl)

        // Do any additional setup after loading the view.
    }
    
    @IBOutlet var labelName: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let user = Auth.auth().currentUser
        if let user = user {
            let name = user.displayName
            
             labelName.text = name
        }
        
        fetchPost()
        tableView.reloadData()

       

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        SVProgressHUD.dismiss()
        
    }
    
    @objc func reflesh(){
        
        //引っ張って更新する時に呼ばれる処理
        fetchPost()
        refleshControl.endRefreshing()
        
    }
    
    func fetchPost(){
        
        //配列の数とCellの数が合わなくなりエラーが起きるので初期化している。
        self.posts = [Post]()
        self.eventName_Array = [String]()
        self.postImage_Array = [String]()
        self.time_Array = [String]()
        self.price_Array = [String]()
        self.place_Array = [String]()
        self.people_Array = [String]()
        self.details_Array = [String]()
        self.posst = Post()
        
        
        //postの投稿をとってくる処理。googlService-info.plistを参照してデータを取ってくる場所を特定している。
        let ref = Database.database().reference()
        ref.child("post").queryLimited(toFirst: 10).observeSingleEvent(of: .value) { (snap,error) in
            
            //snapの中にすべてのデータが入っている。その中身(value)をpostSnapに代入する処理
            let postsSnap = snap.value as? [String:NSDictionary]
            if postsSnap == nil{
                return
            }
            
            self.posts = [Post]()
            
            for (_,post) in postsSnap!
            {
                
                self.eventName_Array = [String]()
                self.postImage_Array = [String]()
                self.time_Array = [String]()
                self.price_Array = [String]()
                self.place_Array = [String]()
                self.people_Array = [String]()
                self.details_Array = [String]()
                self.posst = Post()
                
                if let eventName = post["eventName"] as? String,let time = post["time"] as? String,let price =  post["price"] as? String,let place = post["place"] as? String,let people =  post["people"] as? String,let details = post["details"] as? String,let postImage = post["postImage"] as? String{
                    
                    
                    self.posst.eventName = eventName
                    self.posst.time = time
                    self.posst.postImage = postImage
                    self.posst.price = price
                    self.posst.place = place
                    self.posst.people = people
                    self.posst.details = details

                    
                    
                    self.eventName_Array.append(self.posst.eventName)
                    self.time_Array.append(self.posst.time)
                    self.postImage_Array.append(self.posst.postImage)
                    self.price_Array.append(self.posst.price)
                    self.place_Array.append(self.posst.place)
                    self.people_Array.append(self.posst.people)
                    self.details_Array.append(self.posst.details)

                    
                }
                
                self.posts.append(self.posst)
                
            }
            
            self.tableView.reloadData()
        }
        
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return posts.count
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let profileImageView = cell.viewWithTag(1) as! UIImageView
        let profileImageURL = URL(string: self.posts[indexPath.row].postImage as String)!
        profileImageView.sd_setImage(with: profileImageURL, completed: nil)
        profileImageView.layer.cornerRadius = 8.0
        profileImageView.clipsToBounds = true
        
        
        
        let eventNameLabel = cell.viewWithTag(2) as! UILabel
        eventNameLabel.text = self.posts[indexPath.row].eventName
        
        let timeLabel = cell.viewWithTag(3) as! UILabel
        timeLabel.text = self.posts[indexPath.row].time
        
        let placeLabel = cell.viewWithTag(4) as! UILabel
        placeLabel.text = self.posts[indexPath.row].place
        
        let peopleLabel = cell.viewWithTag(5) as! UILabel
        peopleLabel.text = self.posts[indexPath.row].people
        
        let priceLabel = cell.viewWithTag(6) as! UILabel
        priceLabel.text = self.posts[indexPath.row].price
        
        let detailsLabel = cell.viewWithTag(7) as! UILabel
        detailsLabel.text = self.posts[indexPath.row].details
        
        return cell
        
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        //cellの縦の長さ
        return 560
        
    }

//
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
