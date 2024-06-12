//
//  TabBarController.swift
//  Novel_app
//
//  Created by aru on 2024/06/01.
//

//import UIKit
//
//class TabBarController: UITabBarController {
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        delegate = self
//    }
//}
//extension TabBarController: UITabBarControllerDelegate {
//    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
//        if viewController is PostViewController {
//            if let newVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PostViewController") as? PostViewController {
//                //newVC.modalPresentationStyle = .fullScreen
//                tabBarController.present(newVC, animated: true, completion: nil)
//                return false
//            }
//        }
//        return true
//    }
//}

import UIKit

class TabBarController: UITabBarController, UITabBarControllerDelegate {

    let customTabBarView = UIView()
    let plusButton = UIButton()
    let homeButton = UIButton()
    let accountButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        setupViewControllers()
        setupTabBar()
        setupCustomTabBarView()
        setupPlusButton()
        setupCustomTabBarButtons()
    }

    func setupViewControllers() {
        // 各タブのViewControllerを設定
        let homeVC = FriendsPostsViewController()
        homeVC.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), tag: 0)
        let homeNavController = UINavigationController(rootViewController: homeVC)
        
        let accountVC = AccountViewController()
        accountVC.tabBarItem = UITabBarItem(title: "Account", image: UIImage(systemName: "person"), tag: 1)
        let accountNavController = UINavigationController(rootViewController: accountVC)
        
        viewControllers = [homeNavController, accountNavController]
    }

    func setupTabBar() {
        tabBar.isHidden = true
    }

    func setupCustomTabBarView() {
        customTabBarView.backgroundColor = .white
        customTabBarView.layer.cornerRadius = 20
        customTabBarView.layer.shadowColor = UIColor.black.cgColor
        customTabBarView.layer.shadowOpacity = 0.1
        customTabBarView.layer.shadowOffset = CGSize(width: 0, height: 5)
        customTabBarView.layer.shadowRadius = 10
        customTabBarView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(customTabBarView)

        NSLayoutConstraint.activate([
            customTabBarView.heightAnchor.constraint(equalToConstant: 70),
            customTabBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            customTabBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            customTabBarView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 20)
        ])
    }

    func setupPlusButton() {
        plusButton.setImage(UIImage(systemName: "plus"), for: .normal)
        plusButton.tintColor = .white
        plusButton.backgroundColor = .systemPink
        plusButton.layer.cornerRadius = 35
        plusButton.translatesAutoresizingMaskIntoConstraints = false
        plusButton.addTarget(self, action: #selector(plusButtonTapped), for: .touchUpInside)

        view.addSubview(plusButton)
        
        NSLayoutConstraint.activate([
            plusButton.centerXAnchor.constraint(equalTo: customTabBarView.centerXAnchor),
            plusButton.centerYAnchor.constraint(equalTo: customTabBarView.topAnchor),
            plusButton.widthAnchor.constraint(equalToConstant: 70),
            plusButton.heightAnchor.constraint(equalToConstant: 70)
        ])
    }

    func setupCustomTabBarButtons() {
        // Home Button
        let homeImageView = UIImageView(image: UIImage(systemName: "house.fill"))
        homeImageView.contentMode = .scaleAspectFit
        homeImageView.tintColor = .systemPink
        homeImageView.translatesAutoresizingMaskIntoConstraints = false
        homeButton.addSubview(homeImageView)
        
        NSLayoutConstraint.activate([
            homeImageView.centerXAnchor.constraint(equalTo: homeButton.centerXAnchor),
            homeImageView.centerYAnchor.constraint(equalTo: homeButton.centerYAnchor),
            homeImageView.widthAnchor.constraint(equalToConstant: 40),
            homeImageView.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        homeButton.translatesAutoresizingMaskIntoConstraints = false
        homeButton.addTarget(self, action: #selector(homeButtonTapped), for: .touchUpInside)
        customTabBarView.addSubview(homeButton)
        
        NSLayoutConstraint.activate([
            homeButton.centerYAnchor.constraint(equalTo: customTabBarView.centerYAnchor),
            homeButton.leadingAnchor.constraint(equalTo: customTabBarView.leadingAnchor, constant: 30),
            homeButton.widthAnchor.constraint(equalToConstant: 40),
            homeButton.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        // Account Button
        let accountImageView = UIImageView(image: UIImage(systemName: "person"))
        accountImageView.contentMode = .scaleAspectFit
        accountImageView.tintColor = .systemPink
        accountImageView.translatesAutoresizingMaskIntoConstraints = false
        accountButton.addSubview(accountImageView)
        
        NSLayoutConstraint.activate([
            accountImageView.centerXAnchor.constraint(equalTo: accountButton.centerXAnchor),
            accountImageView.centerYAnchor.constraint(equalTo: accountButton.centerYAnchor),
            accountImageView.widthAnchor.constraint(equalToConstant: 40),
            accountImageView.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        accountButton.translatesAutoresizingMaskIntoConstraints = false
        accountButton.addTarget(self, action: #selector(accountButtonTapped), for: .touchUpInside)
        customTabBarView.addSubview(accountButton)
        
        NSLayoutConstraint.activate([
            accountButton.centerYAnchor.constraint(equalTo: customTabBarView.centerYAnchor),
            accountButton.trailingAnchor.constraint(equalTo: customTabBarView.trailingAnchor, constant: -30),
            accountButton.widthAnchor.constraint(equalToConstant: 40),
            accountButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    func updateButtonImages() {
        for subview in homeButton.subviews {
            if let imageView = subview as? UIImageView {
                imageView.image = selectedIndex == 0 ? UIImage(systemName: "house.fill") : UIImage(systemName: "house")
            }
        }
        for subview in accountButton.subviews {
            if let imageView = subview as? UIImageView {
                imageView.image = selectedIndex == 1 ? UIImage(systemName: "person.fill") : UIImage(systemName: "person")
            }
        }
    }
    
    

    @objc func plusButtonTapped() {
        if let newVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PostViewController") as? PostViewController {
            let navController = UINavigationController(rootViewController: newVC)
            navController.modalPresentationStyle = .fullScreen
            present(navController, animated: true, completion: nil)
        }
    }

    @objc func homeButtonTapped() {
        selectedIndex = 0
        updateButtonImages()
        
    }

    @objc func accountButtonTapped() {
        selectedIndex = 1
        updateButtonImages()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        var tabFrame = tabBar.frame
        tabFrame.size.height = 70
        tabFrame.origin.y = view.frame.height - tabFrame.size.height
        tabBar.frame = tabFrame
    }

    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController is PostViewController {
            return false
        }
        return true
    }
}
