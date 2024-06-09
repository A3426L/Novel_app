//
//  FriendsPostsViewController.swift
//  Novel_app
//
//  Created by aru on 2024/05/27.
//

import UIKit

class FriendsPostsViewCell: UICollectionViewCell {
    
    let TextView: UITextView = {
        let txv = UITextView()
        txv.translatesAutoresizingMaskIntoConstraints = false
        txv.textAlignment = .center
        txv.textColor = .black
        txv.isEditable = false
        txv.isSelectable = false
        txv.font = UIFont.boldSystemFont(ofSize: 30)
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
    
    let bottomRightLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .right
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 30)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(TextView)
        contentView.addSubview(bottomRightLabel)
//        contentView.addSubview(bottomRightLabel)
        //addSubview(topLeftLabel)
        
        NSLayoutConstraint.activate([
            TextView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            TextView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            TextView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.8),
            TextView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.5),
            
//            topLeftLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8),
//            topLeftLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8)
            
            bottomRightLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -40),
            bottomRightLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -60)
        ])
        
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
//                contentView.addGestureRecognizer(tapGesture)
        
        TextView.layer.cornerRadius = 12
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        contentView.addSubview(TextView)
        contentView.addSubview(bottomRightLabel)
        NSLayoutConstraint.activate([
            TextView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            TextView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor,constant: -20),
            TextView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.8),
            TextView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.8),
            
            bottomRightLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -40),
            bottomRightLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -60)
        ])
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
                contentView.addGestureRecognizer(tapGesture)
        
    }
    
    @objc func handleTap() {
        guard let collectionView = superview as? UICollectionView else { return }
        guard let indexPath = collectionView.indexPath(for: self) else { return }
        
        let nextItem = indexPath.item + 1
        print(nextItem)
        if nextItem < collectionView.numberOfItems(inSection: indexPath.section) {
            let nextIndexPath = IndexPath(item: nextItem, section: indexPath.section)
            collectionView.scrollToItem(at: nextIndexPath, at: .centeredVertically, animated: true)
        }
    }
}

class FriendsPostsViewController:UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var viewWidth: CGFloat!
    var viewHeight: CGFloat!
    var cellWidth: CGFloat!
    var cellHeight: CGFloat!
    var cellOffset: CGFloat!
    var navHeight: CGFloat!
    var tabBarHeight: CGFloat!
    var safeAreaInsets: UIEdgeInsets!
    
    let cellIdentifier = "Cell"
    let colors: [UIColor] = [.red, .blue, .green, .yellow, .purple]
    //var textData: [String:String] = [:]
    var textData:[String] = []
    var userData:[String] = []
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewWidth = view.frame.width
        viewHeight = view.frame.height
//        viewWidth = view.safeAreaLayoutGuide.layoutFrame.width
//        viewHeight = view.safeAreaLayoutGuide.layoutFrame.height
        
        navHeight = self.navigationController?.navigationBar.frame.size.height
        tabBarHeight = self.tabBarController?.tabBar.frame.size.height ?? 0
        
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
                                self.userData.append(userName)
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
        safeAreaInsets = view.safeAreaInsets
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
        
        cell.backgroundColor = .orange
        
        cell.TextView.text = textData[indexPath.item]
        //cell.TextView.backgroundColor = colors[indexPath.item]
        cell.bottomRightLabel.text = userData[indexPath.item]
        cell.layer.cornerRadius = 15
        //let values = Array(textData.values)
        //print(values)
        //cell.TextView.text = values[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: view.frame.width, height: view.frame.height - 150)
        
        cellWidth = viewWidth-30
        let safeAreaTop = safeAreaInsets.top
        let safeAreaBottom = safeAreaInsets.bottom
        cellHeight = viewHeight  - tabBarHeight - safeAreaTop - safeAreaBottom
        cellOffset = viewWidth-cellWidth
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        let layout = self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let cellHeightIncludingSpacing = cellHeight + layout.minimumLineSpacing
        var offset = targetContentOffset.pointee.y
        let index = (offset + scrollView.contentInset.top + safeAreaInsets.top) / cellHeightIncludingSpacing
        let roundedIndex = round(index)
        
        offset = roundedIndex * cellHeightIncludingSpacing - (scrollView.contentInset.top - safeAreaInsets.top)
        
        offset = max(0, offset - tabBarHeight)
        targetContentOffset.pointee = CGPoint(x: 0, y: offset)
    }
    
    func scrollView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets()
        }
    

}

