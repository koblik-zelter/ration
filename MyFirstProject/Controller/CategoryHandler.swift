//
//  CategoryHandler.swift
//  MyFirstProject
//
//  Created by Alex Koblik-Zelter on 9/16/19.
//  Copyright © 2019 Alex Koblik-Zelter. All rights reserved.
//

import Foundation
import UIKit

class CategoryHandler: NSObject, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var categories: [Category] = []
    var delegate: CategoryDelegate?
    var firstOpen: Bool = true
    func addCategories(categories: [Category]) {
        self.categories.append(contentsOf: categories)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: categoryCellID, for: indexPath) as? CategoryCell else { return UICollectionViewCell() }
        cell.category = categories[indexPath.item]
        if (firstOpen && indexPath.item == 0) {
            cell.isSelected = true
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 90, height: 125)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("selected", indexPath.item)
        // first cell should be selected only during first open, when user selects other cell, first one should be deselected
        if (firstOpen) {
            firstOpen = false
            guard let cell = collectionView.cellForItem(at: IndexPath(item: 0, section: 0)) else { return }
            cell.isSelected = false
        }
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        self.delegate?.didTapOn(category: categories[indexPath.item])
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        // not to do another requiest when cell is selected
        guard let cell = collectionView.cellForItem(at: indexPath) else { return false }
        if cell.isSelected == true {
            return false
        }
        return true
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }
}

protocol CategoryDelegate {
    func didTapOn(category: Category)
}
