//
//  HomePostCell.swift
//  MyFirstProject
//
//  Created by Alex Koblik-Zelter on 9/9/19.
//  Copyright © 2019 Alex Koblik-Zelter. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher

class HomePostCell: UICollectionViewCell {
    
    var isRight: Bool!
    var rightLeading: NSLayoutConstraint!
    var rightTrailing: NSLayoutConstraint!
    var leftLeading: NSLayoutConstraint!
    var leftTrailing: NSLayoutConstraint!
    var height: NSLayoutConstraint!
    
    var post: Post? {
        didSet {
            guard let post = post else { return }
            height.isActive = false
            height = self.rationImageView.heightAnchor.constraint(equalToConstant: post.imageHeight)
            height.isActive = true
            let mainResource = ImageResource(downloadURL: URL(string: post.imageURL)!)
            self.rationImageView.kf.indicatorType = .activity
            self.rationImageView.kf.setImage(with: mainResource)
            self.titleLabel.text = post.title
            self.timeLabel.text = post.time
            self.caloriesLabel.text = "\(post.calories) кКал"
            
            if isRight {
                rightTrailing.isActive = true
                rightLeading.isActive = true
                leftLeading.isActive = false
                leftTrailing.isActive = false
            }
            else {
                rightTrailing.isActive = false
                rightLeading.isActive = false
                leftLeading.isActive = true
                leftTrailing.isActive = true
            }
        }
    }
    
    
    
    var isPressed: Bool = false {
        didSet {
            var transform: CGAffineTransform = .identity
            if isPressed {
                transform = .init(scaleX: 0.9, y: 0.9)
            }
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.transform = transform
            })
            updatePressedState()
        }
    }
    
    
    
    let checkmark: UIImageView = {
        let image = UIImage(named: "bird1")
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.alpha = 0
        return imageView
    }()
    
    let rationImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 12
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        return iv
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = .gray
        return label
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    let caloriesLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = .white
        label.clipsToBounds = true
        label.textAlignment = .center
        label.layer.cornerRadius = 4
        label.backgroundColor = UIColor.init(red: 106/255, green: 191/255, blue: 123/255, alpha: 1)
        label.text = "122 кКал"
        // label.text = "Test"
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    private func setupView() {
        self.addSubview(rationImageView)
        self.addSubview(timeLabel)
        self.addSubview(titleLabel)
        self.addSubview(caloriesLabel)
        self.addSubview(checkmark)
        
        self.height = self.rationImageView.heightAnchor.constraint(equalToConstant: 240)
        
        rightTrailing = rationImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16)
        
        rightLeading = rationImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8)
        
        leftLeading = rationImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16)
        
        leftTrailing = rationImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8)
        
        rationImageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        
        checkmark.bottomAnchor.constraint(equalTo: rationImageView.bottomAnchor, constant: -8).isActive = true
        checkmark.trailingAnchor.constraint(equalTo: rationImageView.trailingAnchor, constant: -8).isActive = true
        
        timeLabel.topAnchor.constraint(equalTo: rationImageView.bottomAnchor, constant: 8).isActive = true
        timeLabel.leadingAnchor.constraint(equalTo: self.rationImageView.leadingAnchor).isActive = true
        
        caloriesLabel.centerYAnchor.constraint(equalTo: timeLabel.centerYAnchor).isActive = true
        caloriesLabel.trailingAnchor.constraint(equalTo: rationImageView.trailingAnchor).isActive = true
        
        caloriesLabel.heightAnchor.constraint(equalToConstant: 18).isActive = true
        caloriesLabel.widthAnchor.constraint(equalToConstant: 70).isActive = true
        
        titleLabel.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 4
            ).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: self.rationImageView.leadingAnchor).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: rationImageView.trailingAnchor).isActive = true
    }
    
    private func updatePressedState() {
        rationImageView.alpha = isPressed ? 0.5 : 1
        checkmark.alpha = isPressed ? 1 : 0
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        isPressed = false
    }
}
