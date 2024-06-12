//
//  ConfirmViewController.swift
//  Novel_app
//
//  Created by aru on 2024/05/25.
//

import UIKit

class ConfirmViewController: UIViewController {
    
    @IBOutlet var PostButton:UIButton!
    @IBOutlet var TextView:UITextView!

    var ReceivedData = ""
    var colorData:UIColor!
    //var userID:String!

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        TextView.text = ReceivedData
        TextView.backgroundColor = colorData
        TextView.font = UIFont(name: "Georgia", size: 25)
        view.backgroundColor = colorData
        setupConstraints()
        print(ReceivedData)
    }
    
    @IBAction func TapedPostButton(){
        let color = TextView.backgroundColor
        var StColor :String = "white"
        
        if color == UIColor(red: 1.0, green: 1.0, blue: 0.8, alpha: 1.0){
            StColor = "Yellow"
        }else if color == UIColor(red: 0.7, green: 0.8, blue: 1.0, alpha: 1.0){
            StColor = "Blue"
        }else if color == UIColor.white{
            StColor = "white"
        }else if color == UIColor(red: 0.8, green: 1.0, blue: 0.8, alpha: 1.0){
            StColor = "Green"
        }else {
            StColor  = "white"
        }
        
        if let savedDict = UserDefaults.standard.dictionary(forKey: "UserInfo"),
           let name = savedDict["Name"] as? String {
            //userID = name
            print("Name: \(name)")
        } else {
            print("データが見つかりません")
        }
        
        UserDefaults.standard.set(true,forKey: "isPostKey")
        
        
        AddPostTable(UserID: userID, ThemeID: "test", PostTxt: TextView.text, Color: StColor, Range:0)
        //AddPostTable(UserID: "test", ThemeID: "test", PostTxt: "吾輩は猫である。", Range:0)
        //AddUserTable(UserID: "test", UserName: "test")
    }
    
    private func setupConstraints() {
        TextView.translatesAutoresizingMaskIntoConstraints = false
        PostButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            // TextView constraints
            TextView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 300),
            TextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            TextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            TextView.bottomAnchor.constraint(equalTo: PostButton.topAnchor, constant: -20),

            // PostButton constraints
            PostButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            PostButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            PostButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            PostButton.heightAnchor.constraint(equalToConstant: 70)
        ])
    }

    
    

}

//import UIKit
//
//class ConfirmViewController: UIViewController {
//    
//    @IBOutlet var postButton: UIButton!
//    @IBOutlet var textView: UITextView!
//
//    var receivedData = ""
//    var colorData: UIColor!
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        textView.text = receivedData
//        textView.backgroundColor = colorData
//        textView.font = UIFont(name: "Georgia", size: 25)
//        view.backgroundColor = colorData
//        
//        setupConstraints()
//        print(receivedData)
//    }
//    
//    @IBAction func tapedPostButton() {
//        let color = textView.backgroundColor
//        var stColor: String = "white"
//        
//        if color == UIColor(red: 1.0, green: 1.0, blue: 0.8, alpha: 1.0) {
//            stColor = "Yellow"
//        } else if color == UIColor(red: 0.7, green: 0.8, blue: 1.0, alpha: 1.0) {
//            stColor = "Blue"
//        } else if color == UIColor.white {
//            stColor = "white"
//        } else if color == UIColor(red: 0.8, green: 1.0, blue: 0.8, alpha: 1.0) {
//            stColor = "Green"
//        } else {
//            stColor = "white"
//        }
//        
//        if let savedDict = UserDefaults.standard.dictionary(forKey: "UserInfo"),
//           let name = savedDict["Name"] as? String {
//            print("Name: \(name)")
//        } else {
//            print("データが見つかりません")
//        }
//        
//        UserDefaults.standard.set(true, forKey: "isPostKey")
//        
//        AddPostTable(UserID: userID, ThemeID: "test", PostTxt: textView.text, Color: stColor, Range: 0)
//    }
//    
//    private func setupConstraints() {
//        textView.translatesAutoresizingMaskIntoConstraints = false
//        postButton.translatesAutoresizingMaskIntoConstraints = false
//        
//        NSLayoutConstraint.activate([
//            // TextView constraints
//            textView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
//            textView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
//            textView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
//            textView.bottomAnchor.constraint(equalTo: postButton.topAnchor, constant: -20),
//            
//            // PostButton constraints
//            postButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
//            postButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
//            postButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
//            postButton.heightAnchor.constraint(equalToConstant: 70)
//        ])
//    }
//}

