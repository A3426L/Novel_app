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

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        TextView.text = ReceivedData
        TextView.backgroundColor = colorData
        view.backgroundColor = colorData
        print(ReceivedData)
    }
    
    @IBAction func TapedPostButton(){
        let color = TextView.backgroundColor
        var StColor :String = "white"
        
        if color == UIColor(red: 1.0, green: 1.0, blue: 0.8, alpha: 1.0){
            StColor = "Yellow"
        }else if color == UIColor(red: 0.7, green: 0.8, blue: 1.0, alpha: 1.0){
            StColor = "Blue"
        }else if color == UIColor(red: 1.0, green: 0.8, blue: 0.8, alpha: 1.0){
            StColor = "Pink"
        }else if color == UIColor(red: 0.8, green: 1.0, blue: 0.8, alpha: 1.0){
            StColor = "Green"
        }else {
            StColor  = "white"
        }
        UserDefaults.standard.set(true,forKey: "isPostKey")
        AddPostTable(UserID: "test", ThemeID: "test", PostTxt: TextView.text, Color: StColor, Range:0)
        //AddPostTable(UserID: "test", ThemeID: "test", PostTxt: "吾輩は猫である。", Range:0)
        //AddUserTable(UserID: "test", UserName: "test")
    }

    
    

}
