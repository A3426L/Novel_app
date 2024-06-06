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
    
    var characterCountLabel: UILabel!

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textview.text = GetTxt
        
        textview.delegate = self
        textview.becomeFirstResponder()
        
        characterCountLabel = UILabel()
        characterCountLabel.text = String(GetTxt.count)
        characterCountLabel.sizeToFit()

        let countBarButtonItem = UIBarButtonItem(customView: characterCountLabel)

        
        let toolbar = UIToolbar()
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                    target: nil,
                                    action: nil)
        
        let done = UIBarButtonItem(title: "完了",
                                   style: .done,
                                   target: self,
                                   action: #selector(didTapDoneButton))
        
        toolbar.items = [countBarButtonItem, space, done]
        
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
    
    func textViewDidChange(_ textView: UITextView) {
        updateCharacterCount()
    }

    func updateCharacterCount() {
        let count = textview.text.count
        characterCountLabel.text = "\(count)"
    }
}

