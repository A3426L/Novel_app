//
//  PostViewController.swift
//  Novel_app
//
//  Created by aru on 2024/05/25.
//

import UIKit

class PostViewController: UIViewController {
    
    @IBOutlet var textview :UITextView!
    @IBOutlet var ConfirmButton :UIButton!
    var inputData: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //ConfirmButton.isEnabled = false
        textview.becomeFirstResponder()
    }
    
    
    @IBAction func ConfirmButtonTapped(){
        let inputData = textview.text
        //print("入力された\(inputData ?? "")")
        let nextView = storyboard?.instantiateViewController(withIdentifier: "ConfirmViewController") as! ConfirmViewController
        nextView.ReceivedData = inputData!
        nextView.modalPresentationStyle = .fullScreen
        present(nextView, animated: true, completion: nil)
        
    }
}

