//
//  CategoryCell.swift
//  MyFirstProject
//
//  Created by Alex Koblik-Zelter on 9/14/19.
//  Copyright © 2019 Alex Koblik-Zelter. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher

class CategoryCell: UICollectionViewCell {
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                selectCell()
            }
            else {
                unSelectCell()
            }
        }
    }
    var category: Category? {
        didSet {
            guard let category = category else { return }
            categoryTitle.text = category.title
            guard let url = URL(string: category.imageURL) else { return }
            let resource = ImageResource(downloadURL: url)
            categoryImageView.kf.setImage(with: resource)
            categoryDescription.text = category.description
        }
    }
    
    let categoryImageView: UIImageView = {
        let iv = UIImageView()
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    let categoryTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont(name: "RobotoCondensed-Regular", size: 16)
        label.textColor = .lightGray
        label.text = "Detox"
        return label
    }()
    let categoryDescription: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont(name: "RobotoCondensed-Regular", size: 14)
        label.textColor = .lightGray
        label.numberOfLines = 0
        label.text = "Ускорь похудение!"
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    private func setupViews() {
        self.addSubview(categoryImageView)
        self.addSubview(categoryTitle)
        
        categoryImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        categoryImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 4).isActive = true
        categoryImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -4).isActive = true
        categoryImageView.heightAnchor.constraint(equalToConstant: 95).isActive = true
        
        categoryTitle.topAnchor.constraint(equalTo: categoryImageView.bottomAnchor, constant: 2).isActive = true
        categoryTitle.centerXAnchor.constraint(equalTo: categoryImageView.centerXAnchor).isActive = true
    }
    
    private func selectCell() {
        guard let category = category else { return }
        guard let url = URL(string: category.imageSelectedURL) else { return }
        let resource = ImageResource(downloadURL: url)
        categoryImageView.kf.indicatorType = .activity
        categoryImageView.kf.setImage(with: resource)
        
        self.categoryTitle.textColor = .rgbColor(red: 106, green: 191, blue: 123)
    }
    
    private func unSelectCell() {
        guard let category = category else { return }
        guard let url = URL(string: category.imageURL) else { return }
        let resource = ImageResource(downloadURL: url)
        categoryImageView.kf.setImage(with: resource)
        self.categoryTitle.textColor = .lightGray
    }
}
