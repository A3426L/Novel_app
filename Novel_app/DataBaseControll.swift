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

func AddPostTable(UserID:String,ThemeID:String,PostTxt:String,Range: Int){
    db.collection("Post").addDocument(data: [
        "UserID": UserID,
        "ThemeID":ThemeID,
        "PostTxt":PostTxt,
        "Range":Range, //0->全体公開,1->友達まで,2->自分だけ
        "CreatedAt":Date()
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

