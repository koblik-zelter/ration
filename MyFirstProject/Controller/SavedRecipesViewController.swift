//
//  SavedRecipesViewController.swift
//  MyFirstProject
//
//  Created by Alex Koblik-Zelter on 9/25/19.
//  Copyright © 2019 Alex Koblik-Zelter. All rights reserved.
//

import UIKit
import CoreData
fileprivate let recipeCell = "RecipeCellID"
class SavedRecipesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var recipes: [Recipe] = []
    var tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupViews()
        self.fetchRecipes()
        self.view.backgroundColor = UIColor(named: "BackgroundColor")
        // Do any additional setup after loading the view.
    }
    
    private func fetchRecipes() {
        self.recipes = CoreDataManager.shared.fetchRecipes()
        self.tableView.reloadData()
        NotificationCenter.default.addObserver(self, selector: #selector(refreshAppData), name: SearchViewController.name, object: nil)
    }
    
    private func setupViews() {
        self.navigationController?.navigationBar.barTintColor = UIColor(named: "NavBarColor")
        let label = UILabel()
        label.textColor = UIColor.white
        label.text = "Рецепты на вашем устройстве!"
        label.font = UIFont.robotoCondensed(size: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        self.navigationItem.titleView = label
        
        self.view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        tableView.register(SavedRecipesCell.self, forCellReuseIdentifier: recipeCell)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: recipeCell) as? SavedRecipesCell else { return UITableViewCell() }
        cell.recipe = recipes[indexPath.item]
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipes.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = ingredientsViewController()
        vc.recipe = recipes[indexPath.row]
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.pushViewController(vc, animated: true)
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completion) in
            print("Delete")
            let context = CoreDataManager.shared.persistentContainer.viewContext
            context.delete(self.recipes[indexPath.row])
            self.recipes.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .middle)
            do {
                try context.save()
                    print("Delete from coreData")
            }
            catch let err {
                print("Fail to delete", err)
            }
            completion(true)
        }
        delete.title = "Delete"
        return UISwipeActionsConfiguration(actions: [delete])
    }
    
    @objc func refreshAppData() {
        self.recipes.removeAll()
        self.recipes = CoreDataManager.shared.fetchRecipes()
        self.tableView.reloadData()
    }
    
//    private func deleteAll() {
        //        let context = CoreDataManager.shared.persistentContainer.viewContext
        //        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: Recipe.fetchRequest())
        //        do {
        //            try context.execute(batchDeleteRequest)
        //
        //                   // upon deletion from core data succeeded
        //
        //            var indexPathsToRemove = [IndexPath]()
        //
        //            for (index, _) in recipes.enumerated() {
        //                let indexPath = IndexPath(row: index, section: 0)
        //                indexPathsToRemove.append(indexPath)
        //            }
        //                recipes.removeAll()
        //                tableView.deleteRows(at: indexPathsToRemove, with: .left)
        //
        //            }
        //        catch let delErr {
        //                print("Failed to delete objects from Core Data:", delErr)
        //        }
//    }
}

