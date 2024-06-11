//
//  FirestStartViewController.swift
//  Novel_app
//
//  Created by aru on 2024/05/29.
//

import UIKit

class FirstStartViewController: UIViewController , UITextFieldDelegate {
    
    @IBOutlet var Label:UILabel!
    @IBOutlet var NameBox:UITextField!
    
    let nameKey = UserDefaults.standard.bool(forKey: "UserName")

    override func viewDidLoad() {
        super.viewDidLoad()
        NameBox.delegate = self
            //reset()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    @IBAction func TappedButton(){
        var name:String = NameBox.text ?? "名無し"
        let dict:[String : Any] = ["Name": name]
        UserDefaults.standard.set(dict, forKey: "UserInfo")
        print(dict)
        dismiss(animated: true, completion: nil)
        
    }


}
