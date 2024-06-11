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
        
        NSLayoutConstraint.activate([
            TextView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            TextView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            TextView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.8),
            TextView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.5),
            
            bottomRightLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -40),
            bottomRightLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -60)
        ])
        
        TextView.layer.cornerRadius = 12
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

class FriendsPostsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var collectionView: UICollectionView!
    
    var viewWidth: CGFloat!
    var viewHeight: CGFloat!
    var cellWidth: CGFloat!
    var cellHeight: CGFloat!
    var navHeight: CGFloat!
    var tabBarHeight: CGFloat!
    var safeAreaInsets: UIEdgeInsets!
    var statusBarHeight: CGFloat!
    
    let cellIdentifier = "Cell"
    var textData: [String] = []
    var userData: [String] = []
    var colorData:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Home"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black]
        
        viewWidth = view.frame.width
        viewHeight = view.frame.height
        
        navHeight = self.navigationController?.navigationBar.frame.size.height ?? 0
        tabBarHeight = self.tabBarController?.tabBar.frame.size.height ?? 0
        
        
        if let statusBarManager = view.window?.windowScene?.statusBarManager {
            statusBarHeight = statusBarManager.statusBarFrame.height
        } else {
            statusBarHeight = 0
        }
        

        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 80
        layout.minimumInteritemSpacing = 0
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isPagingEnabled = false
        collectionView.decelerationRate = .fast
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(FriendsPostsViewCell.self, forCellWithReuseIdentifier: cellIdentifier)
        
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        collectionView.contentInsetAdjustmentBehavior = .never
        
        //
        safeAreaInsets = view.safeAreaInsets
        collectionView.contentInset.top = statusBarHeight
        //
        
        GetPostTable { (postData, error) in
            if let error = error {
                print("Error: \(error)")
            } else if let postData = postData as? [String: [String: Any]] {
                for (_, data) in postData {
                    if let postTxt = data["PostTxt"] as? String, let targetUserID = data["UserID"] as? String,let Color = data["Color"] as? String{
                        GetUserName(forUserID: targetUserID) { userName in
                            if let userName = userName {
                                self.textData.append(postTxt)
                                self.userData.append(userName)
                                self.colorData.append(Color)
                                DispatchQueue.main.async {
                                    self.collectionView.reloadData()
                                }
                            } else {
                                print("UserName not found for UserID: \(targetUserID)")
                            }
                        }
                    } else {
                        print("PostTxt not found or UserID not found")
                    }
                }
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        safeAreaInsets = view.safeAreaInsets
        collectionView.contentInset.top = statusBarHeight
        if !isPost() {
            let nextView = storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
            nextView.modalPresentationStyle = .fullScreen
            present(nextView, animated: true, completion: nil)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        safeAreaInsets = view.safeAreaInsets
        collectionView.contentInset.top = statusBarHeight
    }
    
    func isPost() -> Bool {
        let isPostKey = UserDefaults.standard.bool(forKey: "isPostKey")
        return isPostKey
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return textData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! FriendsPostsViewCell
        let color:UIColor!
        if colorData[indexPath.item] == "Yellow"{
            color = UIColor(red: 1.0, green: 1.0, blue: 0.8, alpha: 1.0)
        }else if colorData[indexPath.item] == "Blue"{
            color = UIColor(red: 0.7, green: 0.8, blue: 1.0, alpha: 1.0)
        }else if colorData[indexPath.item] == "Pink"{
            color = UIColor(red: 1.0, green: 0.8, blue: 0.8, alpha: 1.0)
        }else if colorData[indexPath.item] == "Green"{
            color = UIColor(red: 0.8, green: 1.0, blue: 0.8, alpha: 1.0)
        }else{
            color = .white
        }
        cell.backgroundColor = color
        cell.TextView.text = textData[indexPath.item]
        cell.TextView.backgroundColor = color
        cell.bottomRightLabel.text = userData[indexPath.item]
        cell.layer.cornerRadius = 50
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        cellWidth = viewWidth - 40
        
        cellHeight = viewHeight - navHeight - tabBarHeight - safeAreaInsets.top - safeAreaInsets.bottom - statusBarHeight
        cellHeight += 80
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let layout = self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let cellHeightIncludingSpacing = cellHeight + layout.minimumLineSpacing
        let yOffset = scrollView.contentOffset.y
        let index = (yOffset + scrollView.contentInset.top) / cellHeightIncludingSpacing
        var roundedIndex = round(index)
        
//        if velocity.y == 0 {
//            if yOffset - roundedIndex * cellHeightIncludingSpacing > cellHeightIncludingSpacing / 2 {
//                roundedIndex += 1
//            } else if roundedIndex * cellHeightIncludingSpacing - yOffset > cellHeightIncludingSpacing / 2 {
//                roundedIndex -= 1
//            }
//        }
        
        if velocity.y > 0.3 {
            roundedIndex = ceil(index)
        } else if velocity.y < -0.3 {
            roundedIndex = floor(index)
        } else {
            roundedIndex = round(index)
        }
        
        if roundedIndex < 0 {
            roundedIndex = 0
        } else if roundedIndex >= CGFloat(textData.count) {
            roundedIndex = CGFloat(textData.count) - 1
        }
        
        
        let newYOffset = roundedIndex * cellHeightIncludingSpacing - scrollView.contentInset.top
        
        targetContentOffset.pointee = CGPoint(x: 0, y: newYOffset)
        
        
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseOut, .allowUserInteraction], animations: {
            scrollView.contentOffset = CGPoint(x: 0, y: newYOffset)
        })
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        adjustScrollViewOffset(scrollView, animated: true)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            adjustScrollViewOffset(scrollView, animated: true)
        }
    }
    
    private func adjustScrollViewOffset(_ scrollView: UIScrollView, animated: Bool) {
        let layout = self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let cellHeightIncludingSpacing = cellHeight + layout.minimumLineSpacing
        let yOffset = scrollView.contentOffset.y
        let index = (yOffset + scrollView.contentInset.top) / cellHeightIncludingSpacing
        var roundedIndex = round(index)
        
        
        if roundedIndex < 0 {
            roundedIndex = 0
        } else if roundedIndex >= CGFloat(textData.count) {
            roundedIndex = CGFloat(textData.count) - 1
        }
        
        
        let newYOffset = roundedIndex * cellHeightIncludingSpacing - scrollView.contentInset.top
        
        if animated {
            UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseOut, .allowUserInteraction], animations: {
                scrollView.contentOffset = CGPoint(x: 0, y: newYOffset)
            }, completion: { _ in
                
                
                self.collectionView.visibleCells.forEach { cell in
                    cell.alpha = 1.0
                }
            })
        } else {
            scrollView.setContentOffset(CGPoint(x: 0, y: newYOffset), animated: false)
            self.collectionView.visibleCells.forEach { cell in
                cell.alpha = 1.0
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let visibleCells = collectionView.visibleCells
        let cellHeightIncludingSpacing = cellHeight + (collectionView.collectionViewLayout as! UICollectionViewFlowLayout).minimumLineSpacing
        let yOffset = scrollView.contentOffset.y
        
        visibleCells.forEach { cell in
            let cellCenter = cell.center.y
            let distanceFromCenter = abs(cellCenter - yOffset - scrollView.frame.height / 2)
            let alpha = max(0, 1 - (distanceFromCenter / cellHeightIncludingSpacing))
            //cell.alpha = alpha
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        //return .zero
        return UIEdgeInsets(top: 150, left: 0, bottom: 0, right: 0)
    }
}


