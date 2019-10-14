//
//  HomeHeader.swift
//  MyFirstProject
//
//  Created by Alex Koblik-Zelter on 9/16/19.
//  Copyright © 2019 Alex Koblik-Zelter. All rights reserved.
//

import Foundation
import UIKit

class HomeHeader: UICollectionReusableView {
    let categoryCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collection = UICollectionView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), collectionViewLayout: layout)
        layout.scrollDirection = .horizontal
        collection.showsHorizontalScrollIndicator = false
        collection.backgroundColor = UIColor(named: "BackgroundColor")
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.isScrollEnabled = true
        collection.allowsMultipleSelection = false
      //  collection.selectItem(at: IndexPath(item: 0, section: 0), animated: true, scrollPosition: .centeredHorizontally)
        return collection
    }()
    
    let separatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .lightGray
        return view
    }()
    
    let title: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.robotoCondensed(size: 16)
        label.textColor = .lightGray
        label.backgroundColor = .white
        label.text = "Наше меню"
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(named: "BackgroundColor")
        self.setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setupView() {
        self.addSubview(categoryCollection)
        self.addSubview(separatorView)
        self.addSubview(title)
       
        categoryCollection.topAnchor.constraint(equalTo: self.topAnchor, constant: -16).isActive = true
        categoryCollection.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        categoryCollection.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        categoryCollection.heightAnchor.constraint(equalToConstant: 160).isActive = true
        
        separatorView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        separatorView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        separatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        separatorView.topAnchor.constraint(equalTo: categoryCollection.bottomAnchor, constant: 0).isActive = true
        title.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        title.centerYAnchor.constraint(equalTo: separatorView.centerYAnchor).isActive = true
        title.widthAnchor.constraint(equalToConstant: 100).isActive = true
    }
}
