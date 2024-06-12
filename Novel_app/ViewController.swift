//
//  ViewController.swift
//  Novel_app
//
//  Created by aru on 2024/05/23.
//

import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth



class ViewController: UIViewController {

    var themeTxt = "こんにちは"
    @IBOutlet var Label:UILabel!
    @IBOutlet var imageview:UIImageView!
    @IBOutlet var button:UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 1.0, green: 0.8, blue: 0.8, alpha: 1.0)
        Label.backgroundColor = UIColor(red: 1.0, green: 0.8, blue: 0.8, alpha: 1.0)
        
        setupConstraints()

    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if isFirstLaunch() {
            print("first launch")
            let nextView = storyboard?.instantiateViewController(withIdentifier: "FirstStartViewController") as! FirstStartViewController
            nextView.modalPresentationStyle = .fullScreen
            present(nextView, animated: true, completion: nil)
            
        }else{
            print("not first launch")
        }

    }
    
    
    func isFirstLaunch() -> Bool{
        let firstLunchKey = UserDefaults.standard.bool(forKey: "firstLunchKey")
        if !firstLunchKey{
            UserDefaults.standard.set(true,forKey: "firstLunchKey")
            return true
        }
        //test　code
        //UserDefaults.standard.set(false,forKey: "firstLunchKey")
        return false
    }
    
    private func setupConstraints() {
        Label.translatesAutoresizingMaskIntoConstraints = false
        imageview.translatesAutoresizingMaskIntoConstraints = false
        button.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // Label constraints
            Label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            Label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60),
            Label.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.95),
            Label.heightAnchor.constraint(greaterThanOrEqualToConstant: 50),
            
            // ImageView constraints
            imageview.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageview.topAnchor.constraint(equalTo: Label.bottomAnchor, constant: 60),
            imageview.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            imageview.heightAnchor.constraint(equalTo: imageview.widthAnchor, multiplier: 0.9),
            
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.topAnchor.constraint(equalTo: imageview.bottomAnchor, constant: 100),
            button.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            button.heightAnchor.constraint(greaterThanOrEqualToConstant: 60)
        ])
    }
    
       
        
}

