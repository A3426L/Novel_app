//
//  TabBarController.swift
//  Novel_app
//
//  Created by aru on 2024/06/01.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
    }
}
extension TabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        // TabBarItemタップでModal表示をする画面を指定して実装
        if viewController is PostViewController {
            if let newVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PostViewController") as? PostViewController {
                //newVC.modalPresentationStyle = .fullScreen
                tabBarController.present(newVC, animated: true, completion: nil)
                return false
            }
        }
        return true
    }
}
