//
//  ConfirmViewController.swift
//  Novel_app
//
//  Created by aru on 2024/05/25.
//

import UIKit

class ConfirmViewController: UIViewController {
    
    @IBOutlet var PostButton:UIButton!
    @IBOutlet var Label:UILabel!

    var ReceivedData = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Label.text = ReceivedData
        print(ReceivedData)
    }

    
    

}
