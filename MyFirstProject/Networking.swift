//
//  Networking.swift
//  MyFirstProject
//
//  Created by Alex Koblik-Zelter on 9/8/19.
//  Copyright © 2019 Alex Koblik-Zelter. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth

class APIManager {
    
    static let shared = APIManager()
    let reference = Database.database().reference()
    func downloadCategories(childKey: String, completion: @escaping ([Category]) -> Void) {
        let ref = self.reference.child(childKey)
        var categories = [Category]()
        ref.observeSingleEvent(of: .value) { (snapshot) in
            guard let dictionaries = snapshot.value as? [String: Any] else { return }
            dictionaries.forEach { (key, value) in
                guard let dictionary = value as? [String: Any] else { return }
                let id = key
                let category = Category(id: id, dictionary: dictionary)
                categories.append(category)
            }
            completion(categories)
        }
    }
    
    func findInDB(text: String) {
        let ref = reference.child("Recipes")
        ref.queryOrdered(byChild: "title").observeSingleEvent(of: .value, with: { (snapshot) in
             print(snapshot)
        })
    }
    
    func downloadRecipes(completion: @escaping ([Post]) -> Void) {
        var recipes = [Post]()
        let ref = reference.child("Recipes")
        ref.observeSingleEvent(of: .value) { (snapshot) in
            guard let dictionaries = snapshot.value as? [String: Any] else { return }
            dictionaries.forEach { (key, value) in
                guard let dictionary = value as? [String: Any] else { return}
                let recipe = Post(dictionary: dictionary)
                recipes.append(recipe)
            }
            completion(recipes)
        }
    }
    
    func downloadPosts(childKey: String, categoryID: String, completion: @escaping ([Post]) -> Void) {
        let ref = reference.child(childKey).child(categoryID)
        ref.queryOrderedByKey().observe(.value) { (snapshot) in
            print(snapshot)
            var posts = [Post]()
            guard let dictionaries = snapshot.value as? [String: Any] else { return }
            dictionaries.forEach { (key, value) in
                guard let dictionary = value as? [String: Any] else { return }
                let post = Post(dictionary: dictionary)
                posts.append(post)
            }
            completion(posts)
        }
    }
    
    func createUser(uid: String, email: String, date: String, sex: String) {
        let ref = self.reference.child("Users")
        let userValues = ["userEmail": email, "date": date, "sex": sex]
        let values = [uid: userValues]
        ref.updateChildValues(values) { (err, ref) in
            if let err = err {
                print("Fail to create user", err)
            }
            else {
                print("success")
            }
        }
    }
}
