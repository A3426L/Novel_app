//
//  File.swift
//  Novel_app
//
//  Created by aru on 2024/05/24.
//

import Foundation
import Firebase
import FirebaseFirestore

let db = Firestore.firestore()

func AddPostTable(UserID:String,ThemeID:String,PostTxt:String,Color:String,Range: Int){
    db.collection("Post").addDocument(data: [
        "UserID": UserID,
        "ThemeID":ThemeID,
        "PostTxt":PostTxt,
        "Range":Range, //0->全体公開,1->友達まで,2->自分だけ
        "CreatedAt":Date(),
        "Color":Color
    ]) { err in
        if let err = err {
            print("Error writing AddPost: \(err)")
        } else {
            print("AddPostTable successfully written!")
        }
    }
}

func AddUserTable(UserID:String,UserName:String){
    db.collection("User").addDocument(data: [
        "UserID":UserID,
        "UserName": UserName
    ]) { err in
        if let err = err {
            print("Error writing AddUser: \(err)")
        } else {
            print("AddUser successfully written!")
        }
    }
}

func AddThemeTable(ThemeTxt:String){
    db.collection("Theme").addDocument(data: [
        "ThemeTxt": ThemeTxt
    ]) { err in
        if let err = err {
            print("Error writing AddTheme: \(err)")
        } else {
            print("AddTheme successfully written!")
        }
    }
}

func GetPostTable(completion: @escaping ([String: Any]?, Error?) -> Void) {
    db.collection("Post").getDocuments { (querySnapshot, error) in
        if let error = error {
            print("Error getting documents: \(error)")
        } else {
            var UserData: [String: Any] = [:]
            for document in querySnapshot!.documents {
                UserData[document.documentID] = document.data()
                //print("\(document.documentID) => \(document.data())")
            }
            completion(UserData, nil)
        }
    }
}

func GetUserName(forUserID userID: String, completion: @escaping (String?) -> Void) {
    db.collection("User").whereField("UserID", isEqualTo: userID)
        .getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error getting user name: \(error)")
                completion(nil)
            } else {
                guard let documents = querySnapshot?.documents else {
                    print("No documents")
                    completion(nil)
                    return
                }
                
                if let document = documents.first, let userName = document.data()["UserName"] as? String {
                    completion(userName)
                } else {
                    print("User not found")
                    completion(nil)
                }
            }
    }
}

func GetThemeTxt(forDate date: Date, completion: @escaping (String?) -> Void) {
    
    let startOfDay = Calendar.current.startOfDay(for: date)
    let endOfDay = Calendar.current.date(byAdding: .day, value: 1, to: startOfDay)!
    
    db.collection("Theme").whereField("Date",  isGreaterThanOrEqualTo: startOfDay)
        .whereField("Date", isLessThan: endOfDay)
        .getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error getting user name: \(error)")
                completion(nil)
            } else {
                guard let documents = querySnapshot?.documents else {
                    print("No documents")
                    completion(nil)
                    return
                }
                
                if let document = documents.first, let ThemeTxt = document.data()["ThemeTxt"] as? String {
                    completion(ThemeTxt)
                } else {
                    print("ThemeTxt not found")
                    completion(nil)
                }
            }
    }
}

func getRandomThemeTxt(completion: @escaping (String?) -> Void) {
    let db = Firestore.firestore()
    
    db.collection("Theme").getDocuments { (querySnapshot, error) in
        if let error = error {
            print("Error getting documents: \(error)")
            completion(nil)
        } else {
            var themeTxts: [String] = []
            
            for document in querySnapshot!.documents {
                if let themeTxt = document.data()["ThemeTxt"] as? String {
                    themeTxts.append(themeTxt)
                }
            }
            
            if let randomThemeTxt = themeTxts.randomElement() {
                completion(randomThemeTxt)
            } else {
                completion(nil)
            }
        }
    }
}


func reset(){
    UserDefaults.standard.removeObject(forKey: "UserInfo")
    UserDefaults.standard.removeObject(forKey: "isPostKey")
    UserDefaults.standard.removeObject(forKey: "firstLunchKey")
    print("complete reset!")
}

