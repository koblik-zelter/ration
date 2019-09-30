//
//  MainData.swift
//  MyFirstProject
//
//  Created by Alex Koblik-Zelter on 9/7/19.
//  Copyright © 2019 Alex Koblik-Zelter. All rights reserved.
//

import Foundation
import UIKit

class Category {
    var title: String
    var description: String
    var imageURL: String
    var imageSelectedURL: String
    var id: String
    
    init(id: String, dictionary: [String: Any]) {
        self.title = dictionary["title"] as? String ?? ""
        self.description = dictionary["description"] as? String ?? ""
        self.imageURL = dictionary["imageURL"] as? String ?? ""
        self.imageSelectedURL = dictionary["imageSelectedURL"] as? String ?? ""
        self.id = id
    }
}

struct Post: Equatable {
    var title: String
    var time: String
    var imageURL: String
    var calories: Int
    var ingredients: String?
    var imageHeight: CGFloat
    init (dictionary: [String: Any]) {
        self.title = dictionary["title"] as? String ?? ""
        self.time = dictionary["time"] as? String ?? dictionary["category"] as? String ?? ""
        self.imageURL = dictionary["imageURL"] as? String ?? ""
        self.ingredients = dictionary["ingredients"] as? String
        self.calories = dictionary["calories"] as? Int ?? 0
        self.imageHeight = dictionary["imageHeight"] as? CGFloat ?? 0
    }
}

struct User {
    var email: String
    var date: String
    var sex: Sex
}

enum Sex: String {
    case male = "Male"
    case female = "Female"
    case other = "Other"
}
