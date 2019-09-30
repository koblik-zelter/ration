//
//  RecipeDetailHeader.swift
//  MyFirstProject
//
//  Created by Alex Koblik-Zelter on 9/29/19.
//  Copyright © 2019 Alex Koblik-Zelter. All rights reserved.
//

import Foundation
import UIKit

class RecipeDetailHeader: UICollectionReusableView {
    var post: Post? {
        didSet {
            guard let post = post else { return }
            self.titleLabel.text = post.title
            self.timeLabel.text = post.time
            self.caloriesLabel.text = "\(post.calories) кКал"
        }
    }
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .gray
        return label
    }()
       
    let timeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
       
    let caloriesLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .white
        label.clipsToBounds = true
        label.textAlignment = .center
        label.layer.cornerRadius = 4
        label.backgroundColor = UIColor.init(red: 106/255, green: 191/255, blue: 123/255, alpha: 1)
       // label.text = "122 кКал"
        // label.text = "Test"
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        self.contentView.backgroundColor = .white
//        self.contentView.layer.cornerRadius = 16
        self.layer.cornerRadius = 20
        self.layer.masksToBounds = true
        //self.backgroundColor = .white
        self.setupViews()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        self.addSubview(timeLabel)
        self.addSubview(titleLabel)
        self.addSubview(caloriesLabel)
       
        timeLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 16).isActive = true
        timeLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16).isActive = true
        
        caloriesLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 18).isActive = true
        caloriesLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16).isActive = true

        caloriesLabel.heightAnchor.constraint(equalToConstant: 24).isActive = true
        caloriesLabel.widthAnchor.constraint(equalToConstant: 110).isActive = true
        
        titleLabel.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 8).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16).isActive = true
        
    }
}
