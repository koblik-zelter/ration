//
//  ViewController.swift
//  MyFirstProject
//
//  Created by Alex Koblik-Zelter on 9/5/19.
//  Copyright © 2019 Alex Koblik-Zelter. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Kingfisher
import FirebaseAuth
import PinterestLayout


let cellID = "cellID"
let headerID = "headerID"
let categoryCellID = "categoryCellID"

class HomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, CategoryDelegate {
    
    let pinterestLayout: PinterestLayout = PinterestLayout()
    var collectionView: UICollectionView!
    let categoryHandler = CategoryHandler()
    var posts: [Post] = []
    var categories: [Category] = []
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        downloadCategories()
        setupView()
        setupNavigationBar()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    
    
    private func setupView() {
        collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: pinterestLayout)
        collectionView.backgroundColor = .white
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.bounces = true
        collectionView.register(HomePostCell.self, forCellWithReuseIdentifier: cellID)
        self.view.addSubview(collectionView)
        collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 16).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(HomeHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerID)
        categoryHandler.delegate = self
        self.pinterestLayout.delegate = self
        self.pinterestLayout.cellPadding = 0
        self.pinterestLayout.numberOfColumns = 2
    }
    
    private func setupNavigationBar() {
        self.navigationController?.navigationBar.barTintColor = .rgbColor(red: 106, green: 191, blue: 123)
        let label = UILabel()
        label.textColor = UIColor.white
        label.text = "Koblzelv - твой выбор!"
        label.font = UIFont.robotoCondensed(size: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: label)
        
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "phone-white"), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(phone), for: .touchUpInside)
        let telegramButton = UIButton()
        telegramButton.translatesAutoresizingMaskIntoConstraints = false
        telegramButton.setImage(UIImage(named: "telegram"), for: .normal)
        telegramButton.addTarget(self, action: #selector(telegram), for: .touchUpInside)
        telegramButton.tintColor = .white
        
        let stackview = UIStackView.init(arrangedSubviews: [button, telegramButton])
        stackview.distribution = .equalSpacing
        stackview.axis = .horizontal
        stackview.spacing = 16
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: stackview)
        print(stackview.frame.height)
    }
    
    private func downloadCategories() {
        APIManager.shared.downloadCategories(childKey: "Categories") { (categories) in
            self.categories.append(contentsOf: categories)
            self.categoryHandler.addCategories(categories: self.categories)
            self.downloadPosts(id: categories[0].id)
            DispatchQueue.main.async {
                let header = self.getCollectionHeader()
                self.collectionView.collectionViewLayout.invalidateLayout()
                header?.categoryCollection.reloadData()
                self.collectionView.reloadData()
            }
        }
    }
    
    private func downloadPosts(id: String) {
        APIManager.shared.downloadPosts(childKey: "Posts", categoryID: id) { (posts) in
            self.posts.append(contentsOf: posts)
            print(posts.count)
            DispatchQueue.main.async {
                self.collectionView.collectionViewLayout.invalidateLayout()
                self.collectionView.reloadData()
            }
        }
    }
    
    func didTapOn(category: Category) {
        self.posts.removeAll()
        self.downloadPosts(id: category.id)
    }
    
    
    private func getCollectionHeader() -> HomeHeader? {
        return self.collectionView.supplementaryView(forElementKind: UICollectionView.elementKindSectionHeader, at: IndexPath(row: 0, section: 0)) as? HomeHeader
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 16, left: 0, bottom: 16, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as? HomePostCell else { return UICollectionViewCell() }
        
        print(cell.frame.origin.x)
        //cell.height.isActive = false
        if cell.frame.origin.x != 0 {
            cell.isRight = true
        }
        else {
            cell.isRight = false
        }
        cell.post = posts[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = UICollectionReusableView()
        switch kind {
            case UICollectionView.elementKindSectionHeader:
                guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerID, for: indexPath) as? HomeHeader else { return UICollectionReusableView() }
                header.categoryCollection.register(CategoryCell.self, forCellWithReuseIdentifier: categoryCellID)
                header.categoryCollection.delegate = categoryHandler
                header.categoryCollection.dataSource = categoryHandler
                return header
        default:
        assert(false, "Unexpected element kind")
        }
        return header
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // TODO: Selection
        try! Auth.auth().signOut()
        let vc = SignInViewController()
        let navVc = UINavigationController(rootViewController: vc)
        navVc.modalPresentationStyle = .fullScreen
        navVc.isNavigationBarHidden = true
        self.present(navVc, animated: true, completion: nil)
    }
}

extension HomeViewController: PinterestLayoutDelegate {
    func collectionView(collectionView: UICollectionView, heightForAnnotationAtIndexPath indexPath: IndexPath, withWidth: CGFloat) -> CGFloat {
        return 60
    }
    
    func collectionView(collectionView: UICollectionView, heightForImageAtIndexPath indexPath: IndexPath, withWidth: CGFloat) -> CGFloat {
        let post = self.posts[indexPath.item]
        let height = post.imageHeight
        print(height)
        return height
    }
    
    func collectionView(collectionView: UICollectionView, sizeForSectionHeaderViewForSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 170)
    }
}
