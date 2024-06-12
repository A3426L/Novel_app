//
//  AccountViewController.swift
//  Novel_app
//
//  Created by aru on 2024/06/12.
//

import UIKit

class AccountViewController: UIViewController {


    let nameLabel = UILabel()
    let notificationsSwitch = UISwitch()
    let notificationsLabel = UILabel()
    let notificationsContainerView = UIView()
    let myInformationButton = UIButton(type: .system)
    let changePasswordButton = UIButton(type: .system)
    var displayname:String = "エラー"

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 1.0, green: 0.8, blue: 0.8, alpha: 1.0)
        print("AccountViewController's viewDidLoad executed")
        
        self.title = "Account"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black]
 
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let savedDict = UserDefaults.standard.dictionary(forKey: "UserInfo"),
           let name = savedDict[userID] as? String {
            displayname = name
            print("Name: \(name)")
        } else {
            print("データが見つかりません")
        }
        setupUI(name: displayname)
    }

    func setupUI(name:String) {
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.text = name
        nameLabel.font = UIFont(name: "Georgia", size: 35)
        nameLabel.textColor = .black
        view.addSubview(nameLabel)
        
        notificationsLabel.translatesAutoresizingMaskIntoConstraints = false
        notificationsLabel.text = "Notifications"
        notificationsLabel.font = UIFont(name: "Georgia", size: 25)
        notificationsLabel.textColor = .black
        view.addSubview(notificationsLabel)

        notificationsSwitch.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(notificationsSwitch)

        myInformationButton.translatesAutoresizingMaskIntoConstraints = false
        var myInfoButtonConfig = UIButton.Configuration.filled()
        myInfoButtonConfig.title = "memory"
        
        myInfoButtonConfig.baseBackgroundColor = .systemGroupedBackground
        myInfoButtonConfig.baseForegroundColor = .black
        myInfoButtonConfig.contentInsets = NSDirectionalEdgeInsets(top: 50, leading: 50, bottom: 50, trailing: 50)
        myInformationButton.configuration = myInfoButtonConfig
        myInformationButton.layer.cornerRadius = 20
        myInformationButton.layer.masksToBounds = true
        view.addSubview(myInformationButton)
        
        changePasswordButton.translatesAutoresizingMaskIntoConstraints = false
        var changePasswordButtonConfig = UIButton.Configuration.filled()
        changePasswordButtonConfig.title = "change name"
        changePasswordButton.addTarget(self, action: #selector(changeNameButtonTapped), for: .touchUpInside)
        changePasswordButtonConfig.baseBackgroundColor = .systemGroupedBackground
        changePasswordButtonConfig.baseForegroundColor = .black
        changePasswordButtonConfig.contentInsets = NSDirectionalEdgeInsets(top: 50, leading: 50, bottom: 50, trailing: 50)
        changePasswordButton.configuration = changePasswordButtonConfig
        changePasswordButton.layer.cornerRadius = 20
        changePasswordButton.layer.masksToBounds = true
        view.addSubview(changePasswordButton)


        NSLayoutConstraint.activate([
            nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80),
            notificationsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            notificationsLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 100),
            notificationsSwitch.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            notificationsSwitch.centerYAnchor.constraint(equalTo: notificationsLabel.centerYAnchor),

            myInformationButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            myInformationButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            myInformationButton.topAnchor.constraint(equalTo: notificationsLabel.bottomAnchor, constant: 50),
            myInformationButton.heightAnchor.constraint(equalToConstant: 70),
            
            
            
            changePasswordButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            changePasswordButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            changePasswordButton.topAnchor.constraint(equalTo: myInformationButton.bottomAnchor, constant: 20),
            changePasswordButton.heightAnchor.constraint(equalToConstant: 70),

        ])
        
        
    }
    
    @objc func changeNameButtonTapped() {
        print("名前変更ボタンがタップされました")
//        let nextView = storyboard?.instantiateViewController(withIdentifier: "FirstStartViewController") as! FirstStartViewController
//        nextView.modalPresentationStyle = .fullScreen
//        present(nextView, animated: true, completion: nil)
        if let newVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FirstStartViewController") as? FirstStartViewController {
            let navController = UINavigationController(rootViewController: newVC)
            navController.modalPresentationStyle = .fullScreen
            present(navController, animated: true, completion: nil)
        }
    }
}

