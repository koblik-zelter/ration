//
//  ingredientsViewController.swift
//  MyFirstProject
//
//  Created by Alex Koblik-Zelter on 9/27/19.
//  Copyright © 2019 Alex Koblik-Zelter. All rights reserved.
//

import UIKit
import CoreData
let indegrCellID = "indegrCellID"
class ingredientsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var lastSelection: IndexPath?
    var recipe: Recipe?
    var ingredients: [String] = []
    var tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setupViews()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
       // self.navigationController?.navigationBar.tintColor = .white
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        self.navigationItem.title = recipe?.title
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        createString(ingredients: ingredients)
    }
    private func setupViews() {
        self.view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: indegrCellID)
        guard let post = recipe else { return }
        guard let ingr = post.ingredients else { return }
        createArray(ingredients: ingr)
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: indegrCellID, for: indexPath)
        if (ingredients[indexPath.row].last == "+") {
            let text = ingredients[indexPath.row]
            let end = text.count - 1
            cell.accessoryType = .checkmark
            cell.textLabel?.text = text.substring(with: 0..<end)
        }
        else {
            cell.textLabel?.text = ingredients[indexPath.row]
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ingredients.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.tableView.cellForRow(at: indexPath)!.accessoryType == .none {
            self.tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
            ingredients[indexPath.row] += "+"
        }
        else {
            self.tableView.cellForRow(at: indexPath)?.accessoryType = .none
            ingredients[indexPath.row].removeLast()
        }
        //self.tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        self.tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    private func createArray(ingredients: String) {
        self.ingredients = ingredients.components(separatedBy: ",")
        tableView.reloadData()
    }
    
    private func createString(ingredients: [String]) {
        let ingr = ingredients.joined(separator: ",")
        let context = CoreDataManager.shared.persistentContainer.viewContext
        recipe?.ingredients = ingr
        do {
            try context.save()
            print(ingr)
            print("UPDATE")
        }
        catch let err {
            print("Fail to update", err)
        }
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
