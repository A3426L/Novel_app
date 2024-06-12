//
//  FirestStartViewController.swift
//  Novel_app
//
//  Created by aru on 2024/05/29.
//

//import UIKit
//
//class FirstStartViewController: UIViewController , UITextFieldDelegate {
//    
//    @IBOutlet var Label:UILabel!
//    @IBOutlet var NameBox:UITextField!
//    
//    let nameKey = UserDefaults.standard.bool(forKey: "UserName")
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = UIColor(red: 1.0, green: 0.8, blue: 0.8, alpha: 1.0)
//        NameBox.delegate = self
//            //reset()
//    }
//    
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        textField.resignFirstResponder()
//        return true
//    }
//    
//    
//    @IBAction func TappedButton(){
//        let name:String = NameBox.text ?? "名無し"
//        let key:String = userID
//        let dict:[String : String] = [key: name]
//        UserDefaults.standard.set(dict, forKey: "UserInfo")
//        AddOrUpdateUser(UserID: key, UserName: name)
//        print(dict)
//        dismiss(animated: true, completion: nil)
//        
//    }
//
//
//}

import UIKit

class FirstStartViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var Label: UILabel!
    @IBOutlet var NameBox: UITextField!
    @IBOutlet var decideButton: UIButton!
    
    let nameKey = UserDefaults.standard.bool(forKey: "UserName")

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 1.0, green: 0.8, blue: 0.8, alpha: 1.0)
        NameBox.delegate = self
        setupConstraints()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func decideButtonTapped() {
        let name: String = NameBox.text ?? "名無し"
        let key: String = userID
        let dict: [String : String] = [key: name]
        UserDefaults.standard.set(dict, forKey: "UserInfo")
        AddOrUpdateUser(UserID: key, UserName: name)
        print(dict)
        dismiss(animated: true, completion: nil)
    }
    
    private func setupConstraints() {
        Label.translatesAutoresizingMaskIntoConstraints = false
        NameBox.translatesAutoresizingMaskIntoConstraints = false
        decideButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // Label constraints
            Label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            Label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 120),
            Label.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            Label.heightAnchor.constraint(equalToConstant: 70),
            
            // NameBox constraints
            NameBox.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            NameBox.topAnchor.constraint(equalTo: Label.bottomAnchor, constant: 150),
            NameBox.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            NameBox.heightAnchor.constraint(equalToConstant: 60),
            
            // decideButton constraints
            decideButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            decideButton.topAnchor.constraint(equalTo: NameBox.bottomAnchor, constant: 200),
            decideButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.90),
            decideButton.heightAnchor.constraint(equalToConstant: 70)
        ])
    }
}


