//
//  ChipsHeader.swift
//  MyFirstProject
//
//  Created by Alex Koblik-Zelter on 9/22/19.
//  Copyright © 2019 Alex Koblik-Zelter. All rights reserved.
//

import Foundation
import UIKit

class ChipsHeader: UICollectionReusableView {
    let categoryCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collection = UICollectionView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), collectionViewLayout: layout)
        layout.scrollDirection = .horizontal
        collection.showsHorizontalScrollIndicator = false
        collection.backgroundColor = .clear
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.isScrollEnabled = true
        collection.allowsMultipleSelection = false
        //  collection.selectItem(at: IndexPath(item: 0, section: 0), animated: true, scrollPosition: .centeredHorizontally)
        return collection
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        self.setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setupView() {
        self.addSubview(categoryCollection)
        categoryCollection.topAnchor.constraint(equalTo: self.topAnchor, constant: 4).isActive = true
        categoryCollection.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        categoryCollection.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        categoryCollection.heightAnchor.constraint(equalToConstant: 42).isActive = true
    }
    
}
