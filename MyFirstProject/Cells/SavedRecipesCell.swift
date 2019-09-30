//
//  SavedRecipesCell.swift
//  MyFirstProject
//
//  Created by Alex Koblik-Zelter on 9/26/19.
//  Copyright © 2019 Alex Koblik-Zelter. All rights reserved.
//

import Foundation
import UIKit

class SavedRecipesCell: UITableViewCell {
    var recipe: Recipe? {
        didSet {
            guard let recipe = recipe else { return }
            self.titleLabel.text = recipe.title
            self.timeImageView.image = UIImage(named: recipe.time!)
            self.caloriesLabel.text = "\(recipe.calories) кКал"
        }
    }
    let timeImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        //iv.image = #imageLiteral(resourceName: "Супы")
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 12
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .clear
        return iv
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16)
  //      label.font = UIFont(name: "RobotoCondensed-Regular", size: 16)
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
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setupViews() {
        self.accessoryType = .disclosureIndicator
        self.addSubview(timeImageView)
        self.addSubview(titleLabel)
        self.addSubview(caloriesLabel)
        
        timeImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16).isActive = true
        timeImageView.heightAnchor.constraint(equalToConstant: 24).isActive = true
        timeImageView.widthAnchor.constraint(equalToConstant: 24).isActive = true
        timeImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        caloriesLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -48).isActive = true
        caloriesLabel.heightAnchor.constraint(equalToConstant: 18).isActive = true
        caloriesLabel.widthAnchor.constraint(equalToConstant: 70).isActive = true
        caloriesLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: timeImageView.trailingAnchor, constant: 16).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: caloriesLabel.leadingAnchor, constant: -8).isActive = true
    }
    
}
