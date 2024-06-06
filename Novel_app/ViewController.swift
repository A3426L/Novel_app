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

    var themeTxt = "こんにちは　今日も一文"
    @IBOutlet var Label:UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let date = Date()
//        GetThemeTxt(forDate: date){ ThemeTxt in
//            if let ThemeTxt = ThemeTxt {
//                print("Date: \(date), ThemeTxt: \(ThemeTxt)")
//                self.themeTxt = ThemeTxt
//                DispatchQueue.main.async {
//                    self.Label.text = ThemeTxt
//                }
//            }
//        }
        Label.text = themeTxt
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
    
       
        
}

