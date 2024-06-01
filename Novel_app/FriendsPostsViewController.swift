//
//  FriendsPostsViewController.swift
//  Novel_app
//
//  Created by aru on 2024/05/27.
//

import UIKit

class FriendsPostsViewCell: UICollectionViewCell {
    
    let label: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textAlignment = .center
        lbl.textColor = .black
        lbl.font = UIFont.systemFont(ofSize: 24)
        return lbl
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(label)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        contentView.addSubview(label)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}

class FriendsPostsViewController:UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    let cellIdentifier = "Cell"
    let colors: [UIColor] = [.red, .blue, .green, .yellow, .purple]
    var textData: [String] = []
    
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
                        self.textData.append(postTxt)
                        print(self.textData)

                        
                    } else {
                        print("PostTxt not found for document ID: \(documentID)")
                    }
                }
            }
            DispatchQueue.main.async {
                self.collectionView.reloadData()
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
            UserDefaults.standard.set(true,forKey: "isPostKey")
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
        cell.label.text = textData[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height)
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

