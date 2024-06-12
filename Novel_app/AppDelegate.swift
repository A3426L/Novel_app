//
//  AppDelegate.swift
//  Novel_app
//
//  Created by aru on 2024/05/23.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth


var userID:String!
@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        //reset()
       
        
        FirebaseApp.configure()
        
        Auth.auth().signInAnonymously() { (authResult, error) in
            if error != nil{
                print("Auth Error :\(error!.localizedDescription)")
            }
            guard let user = authResult?.user else { return }
            //let isAnonymous = user.isAnonymous  // true
            let uid = user.uid
            userID = uid
            return
        }
        
        DateHandler.shared.clearIsPostIfNeeded()
        

        
        return true
    }
    


    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}


