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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        TextView.text = ReceivedData
        print(ReceivedData)
    }
    
    @IBAction func TapedPostButton(){
       
        UserDefaults.standard.set(true,forKey: "isPostKey")
        AddPostTable(UserID: "test", ThemeID: "test", PostTxt: TextView.text, Range:0)
        //AddPostTable(UserID: "test", ThemeID: "test", PostTxt: "吾輩は猫である。", Range:0)
        //AddUserTable(UserID: "test", UserName: "test")
    }

    
    

}
