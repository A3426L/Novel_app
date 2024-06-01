//
//  FirestStartViewController.swift
//  Novel_app
//
//  Created by aru on 2024/05/29.
//

import UIKit

class FirstStartViewController: UIViewController {
    
    @IBOutlet var Label:UILabel!
    @IBOutlet var NameBox:UITextField!
    
    let nameKey = UserDefaults.standard.bool(forKey: "UserName")

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func TappedButton(){
        dismiss(animated: true, completion: nil)
        
    }


}
