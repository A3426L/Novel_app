//
//  FriendsPostsViewController.swift
//  Novel_app
//
//  Created by aru on 2024/05/27.
//

import UIKit

class FriendsPostsViewCell: UICollectionViewCell {
    
   // @IBOutlet var Label:UILabel!
    
//    let label: UILabel = {
//        let lbl = UILabel()
//        lbl.translatesAutoresizingMaskIntoConstraints = false
//        lbl.textAlignment = .center
//        lbl.textColor = .black
//        lbl.font = UIFont.systemFont(ofSize: 24)
//        return lbl
//    }()
    let TextView: UITextView = {
        let txv = UITextView()
        txv.translatesAutoresizingMaskIntoConstraints = false
        txv.textAlignment = .center
        txv.textColor = .black
        txv.isEditable = false
        txv.isSelectable = false
        txv.font = UIFont.systemFont(ofSize: 30)
        return txv
    }()
    
//    let topLeftLabel: UILabel = {
//        let label = UILabel()
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.textAlignment = .left
//        label.textColor = .darkGray
//        label.font = UIFont.boldSystemFont(ofSize: 44)
//        label.text = "友達"
//        return label
//    }()
    
//    let bottomRightLabel: UILabel = {
//        let label = UILabel()
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.textAlignment = .right
//        label.textColor = .black
//        label.font = UIFont.systemFont(ofSize: 16)
//        label.text = "Bottom Right"
//        return label
//    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(TextView)
//        contentView.addSubview(bottomRightLabel)
        //addSubview(topLeftLabel)
        
        NSLayoutConstraint.activate([
            TextView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            TextView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            TextView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.8),
            TextView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.5),
            
//            topLeftLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8),
//            topLeftLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8)
            
//            bottomRightLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
//            bottomRightLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20)
        ])
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        contentView.addSubview(TextView)
        NSLayoutConstraint.activate([
            TextView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            TextView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            TextView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.8),
            TextView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.8)
        ])
    }
}

class FriendsPostsViewController:UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {
    
    @IBOutlet weak var collectionView: UICollectionView!

    
    let cellIdentifier = "Cell"
    let colors: [UIColor] = [.red, .blue, .green, .yellow, .purple]
    //var textData: [String:String] = [:]
    var textData:[String] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.isPagingEnabled = true
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(FriendsPostsViewCell.self, forCellWithReuseIdentifier: cellIdentifier)
        
        GetPostTable { (postData, error) in
            if let error = error {
                print("Error: \(error)")
            } else if let postData = postData as? [String: [String: Any]] {
//                print("Post Data: \(postData)")
//                print("PostData keys \(postData.keys)")
                
                for (documentID, data) in postData {
                    if let postTxt = data["PostTxt"] as? String {
                        //print("Document ID: \(documentID), PostTxt: \(postTxt)")
                        //self.textData.append(postTxt)
                        let targetUserID = data["UserID"] as! String
                        print(targetUserID)
                        GetUserName(forUserID: targetUserID) { userName in
                            if let userName = userName {
                                print("UserID: \(targetUserID), UserName: \(userName)")
                                //self.textData([postTxt : userName])
                                self.textData.append(postTxt)
                                DispatchQueue.main.async {
                                    self.collectionView.reloadData()
                                }

                            } else {
                                print("UserName not found for UserID: \(targetUserID)")
                            }
                        }
                    } else {
                        print("PostTxt not found for document ID: \(documentID)")
                    }
                }
            }


        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !isPost() {
            print("not post")
            let nextView = storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
            nextView.modalPresentationStyle = .fullScreen
            present(nextView, animated: true, completion: nil)
            
        }else{
            print("post")
        }

    }
    
    func isPost() -> Bool{
        let isPostKey = UserDefaults.standard.bool(forKey: "isPostKey")
        if !isPostKey{
            return false
        }
        return true
    }

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return textData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath)as! FriendsPostsViewCell
        //cell.backgroundColor = colors[indexPath.item]
        cell.TextView.text = textData[indexPath.item]
        //let values = Array(textData.values)
        //print(values)
        //cell.TextView.text = values[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height - 150)
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let layout = self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let cellHeightIncludingSpacing = layout.itemSize.height + layout.minimumLineSpacing
        let estimatedIndex = scrollView.contentOffset.y / cellHeightIncludingSpacing
        let index: Int
        if velocity.y > 0 {
            index = Int(ceil(estimatedIndex))
        } else if velocity.y < 0 {
            index = Int(floor(estimatedIndex))
        } else {
            index = Int(round(estimatedIndex))
        }
        targetContentOffset.pointee = CGPoint(x: 0, y: CGFloat(index) * cellHeightIncludingSpacing)
    }
    

}

