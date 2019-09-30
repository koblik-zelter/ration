//
//  CoreDataManager.swift
//  MyFirstProject
//
//  Created by Alex Koblik-Zelter on 9/25/19.
//  Copyright © 2019 Alex Koblik-Zelter. All rights reserved.
//

import Foundation
import CoreData

class CoreDataManager {
    
    static let shared = CoreDataManager()
    
    let persistentContainer: NSPersistentContainer = {
           let container = NSPersistentContainer(name: "MyFirstProject")
           container.loadPersistentStores { (storeDescription, err) in
               if let err = err {
                   fatalError("Loading of store failed: \(err)")
               }
           }
           return container
       }()
       
       func fetchRecipes() -> [Recipe] {
           let context = persistentContainer.viewContext
           
           let fetchRequest = NSFetchRequest<Recipe>(entityName: "Recipe")
           do {
               let recipes = try context.fetch(fetchRequest)
               return recipes
           } catch let fetchErr {
               print("Failed to fetch recipes:", fetchErr)
               return []
           }
       }
}
