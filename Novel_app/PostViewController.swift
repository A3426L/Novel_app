//
//  PostViewController.swift
//  Novel_app
//
//  Created by aru on 2024/05/25.
//

import UIKit
import FirebaseCore
import FirebaseFirestore


class PostViewController: UIViewController , UITextViewDelegate {
    
    @IBOutlet var textview :UITextView!
    @IBOutlet var ConfirmButton :UIButton!
    var inputData: String?
    var ThemeTxt = "取得失敗！"
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let date = Date()
        GetThemeTxt(forDate: date){ ThemeTxt in
            if let ThemeTxt = ThemeTxt {
                print("Date: \(date), ThemeTxt: \(ThemeTxt)")
                self.ThemeTxt = ThemeTxt
                DispatchQueue.main.async {
                    self.textview.text = ThemeTxt
                }
            }
        }
        
        textview.delegate = self
        textview.becomeFirstResponder()
        
        let toolbar = UIToolbar()
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                    target: nil,
                                    action: nil)
        let done = UIBarButtonItem(title: "完了",
                                   style: .done,
                                   target: self,
                                   action: #selector(didTapDoneButton))
        toolbar.items = [space, done]
        
        toolbar.sizeToFit()
        textview.inputAccessoryView = toolbar
    }
    
    @objc func didTapDoneButton() {
        textview.resignFirstResponder()
    }
    
    
    
    @IBAction func ConfirmButtonTapped(){
        let inputData = textview.text
        //print("入力された\(inputData ?? "")")
        let nextView = storyboard?.instantiateViewController(withIdentifier: "ConfirmViewController") as! ConfirmViewController
        nextView.ReceivedData = inputData!
        //nextView.modalPresentationStyle = .fullScreen
        present(nextView, animated: true, completion: nil)
        
    }
}

