//
//  FriendsPostsViewController.swift
//  Novel_app
//
//  Created by aru on 2024/05/27.
//


import UIKit
import FirebaseCore
import FirebaseFirestore

class FriendsPostsViewCell: UICollectionViewCell {
    
    let TextView: UITextView = {
        let txv = UITextView()
        txv.translatesAutoresizingMaskIntoConstraints = false
        txv.textAlignment = .center
        txv.textColor = .black
        txv.isEditable = false
        txv.isSelectable = false
        txv.font = UIFont(name: "Georgia", size: 25)
        return txv
    }()
    
    let bottomRightLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .right
        label.textColor = .black
        label.font = UIFont(name: "Georgia", size: 25)
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
    
    let customNavigationBar = UIView()
    let titleLabel = UILabel()
    
    var viewWidth: CGFloat!
    var viewHeight: CGFloat!
    var cellWidth: CGFloat!
    var cellHeight: CGFloat!
    var navHeight: CGFloat!
    var tabBarHeight: CGFloat!
    var safeAreaInsets: UIEdgeInsets!
    var statusBarHeight: CGFloat!
    
    let cellIdentifier = "Cell"
    var posts: [(text: String, user: String, color: String, date: Date)] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 1.0, green: 0.8, blue: 0.8, alpha: 1.0)
        
        setupCustomNavigationBar()
        
        self.title = "Home"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black]
        
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.backgroundColor = UIColor(red: 1.0, green: 0.8, blue: 0.8, alpha: 1.0)
        navigationController?.view.backgroundColor = UIColor(red: 1.0, green: 0.8, blue: 0.8, alpha: 1.0)
        
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
        layout.minimumLineSpacing = 30
        layout.minimumInteritemSpacing = 0
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isPagingEnabled = false
        collectionView.decelerationRate = .fast
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = UIColor(red: 1.0, green: 0.8, blue: 0.8, alpha: 1.0)
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
        safeAreaInsets = view.safeAreaInsets
        collectionView.contentInset.top = statusBarHeight
        
        updateData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        safeAreaInsets = view.safeAreaInsets
        collectionView.contentInset.top = statusBarHeight
        if !isPost() {
            if let newVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ViewController") as? ViewController {
                let navController = UINavigationController(rootViewController: newVC)
                navController.modalPresentationStyle = .fullScreen
                present(navController, animated: true, completion: nil)
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        safeAreaInsets = view.safeAreaInsets
        collectionView.contentInset.top = statusBarHeight
    }
    
    func updateData() {
        GetPostTable { (postData, error) in
            if let error = error {
                print("Error: \(error)")
            } else if let postData = postData as? [String: [String: Any]] {
                self.posts = []
                
                for (_, data) in postData {
                    if let postTxt = data["PostTxt"] as? String,
                       let targetUserID = data["UserID"] as? String,
                       let color = data["Color"] as? String,
                       let createdAt = data["CreatedAt"] as? Timestamp {
                        GetUserName(forUserID: targetUserID) { userName in
                            if let userName = userName {
                                self.posts.append((text: postTxt, user: userName, color: color, date: createdAt.dateValue()))
                                DispatchQueue.main.async {
                                    self.posts.sort { $0.date > $1.date } // 最新順にソート
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
    
    func isPost() -> Bool {
        let isPostKey = UserDefaults.standard.bool(forKey: "isPostKey")
        return isPostKey
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! FriendsPostsViewCell
        let post = posts[indexPath.item]
        let color: UIColor
        switch post.color {
        case "Yellow":
            color = UIColor(red: 1.0, green: 1.0, blue: 0.8, alpha: 1.0)
        case "Blue":
            color = UIColor(red: 0.7, green: 0.8, blue: 1.0, alpha: 1.0)
        case "white":
            color = .white
        case "Green":
            color = UIColor(red: 0.8, green: 1.0, blue: 0.8, alpha: 1.0)
        default:
            color = .white
        }
        cell.backgroundColor = color
        cell.TextView.text = post.text
        cell.TextView.backgroundColor = color
        cell.bottomRightLabel.text = post.user
        cell.layer.cornerRadius = 50
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        cellWidth = viewWidth - 40
        cellHeight = viewHeight - navHeight - tabBarHeight - safeAreaInsets.top - safeAreaInsets.bottom - statusBarHeight - 100
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let layout = self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let cellHeightIncludingSpacing = cellHeight + layout.minimumLineSpacing
        let yOffset = scrollView.contentOffset.y
        let index = (yOffset + scrollView.contentInset.top) / cellHeightIncludingSpacing
        var roundedIndex = round(index)
        
        if velocity.y > 0.3 {
            roundedIndex = ceil(index)
        } else if velocity.y < -0.3 {
            roundedIndex = floor(index)
        } else {
            roundedIndex = round(index)
        }
        
        if roundedIndex < 0 {
            roundedIndex = 0
        } else if roundedIndex >= CGFloat(posts.count) {
            roundedIndex = CGFloat(posts.count) - 1
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
        } else if roundedIndex >= CGFloat(posts.count) {
            roundedIndex = CGFloat(posts.count) - 1
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
            cell.alpha = alpha
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 40, left: 0, bottom: 0, right: 0)
    }
    
    private func setupCustomNavigationBar() {
        customNavigationBar.backgroundColor = .white
        customNavigationBar.layer.shadowColor = UIColor.black.cgColor
        customNavigationBar.layer.shadowOpacity = 0.1
        customNavigationBar.layer.shadowOffset = CGSize(width: 0, height: 2)
        customNavigationBar.layer.shadowRadius = 4
        customNavigationBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(customNavigationBar)
        
        titleLabel.text = "Home"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 30)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        customNavigationBar.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            customNavigationBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: -20),
            customNavigationBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            customNavigationBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            customNavigationBar.heightAnchor.constraint(equalToConstant: 60),
            
            titleLabel.centerXAnchor.constraint(equalTo: customNavigationBar.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: customNavigationBar.centerYAnchor)
        ])
    }
}





