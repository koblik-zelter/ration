//
//  BaseViewController.swift
//  MyFirstProject
//
//  Created by Alex Koblik-Zelter on 9/22/19.
//  Copyright © 2019 Alex Koblik-Zelter. All rights reserved.
//

import UIKit
import PinterestLayout
import FirebaseDatabase

class BaseCollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    let pinterestLayout: PinterestLayout = PinterestLayout()
    var collectionView: UICollectionView!
    var posts: [Post] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupView()
        // Do any additional setup after loading the view.
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
    }
    
    private func setupNavigationBar() {
        self.navigationController?.navigationBar.barTintColor = .rgbColor(red: 106, green: 191, blue: 123)
        // self.navigationController?.navigationBar.barTintColor = .rgbColor(red: 38, green: 183, blue: 95)
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

