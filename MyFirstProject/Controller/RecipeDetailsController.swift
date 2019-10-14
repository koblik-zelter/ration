//
//  TestViewController.swift
//  MyFirstProject
//
//  Created by Alex Koblik-Zelter on 9/29/19.
//  Copyright © 2019 Alex Koblik-Zelter. All rights reserved.
//

import UIKit
import ParallaxHeader
import Kingfisher
import MaterialComponents


fileprivate let recipeDetailCellId = "recipeDetailCellId"
fileprivate let headerId = "RecipeHeaderID"
class RecipeDetailsViewController: UIViewController, UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource {
    
    var tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
        
    var post: Post? {
        didSet {
            guard let post = post else { return }
            guard let url = URL(string: post.imageURL) else { return }
            let imageResource = ImageResource(downloadURL: url)
            self.categoryImageView.kf.setImage(with: imageResource)
        }
    }
    
    var ingredients: [String] = []
    
    var backButton: MDCButton = {
        let backButton = MDCFloatingButton()
        backButton.inkColor = UIColor.lightGray
        backButton.setBackgroundColor(.init(white: 1, alpha: 1), for: .normal)
        backButton.setImage(UIImage(named: "arrow-left-black"), for: .normal)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.contentMode = .scaleAspectFill
        return backButton
    }()
        
    var likeButton: MDCButton = {
        let backButton = MDCFloatingButton()
        backButton.inkColor = UIColor.lightGray
        backButton.setBackgroundColor(.init(white: 1, alpha: 1), for: .normal)
        backButton.setImage(UIImage(named: "icons8-heart-outline-24-2"), for: .normal)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.contentMode = .scaleAspectFill
        return backButton
    }()
    
    let categoryImageView: UIImageView = {
        let iv = UIImageView()
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
            // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
        
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        self.navigationController?.navigationBar.barTintColor = UIColor(named: "NavBarColor")
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
       
    private func setupViews() {
        self.view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: recipeDetailCellId)
        tableView.parallaxHeader.view = categoryImageView
        guard let post = post else { return }
        tableView.parallaxHeader.height = post.imageHeight * 2
        tableView.parallaxHeader.minimumHeight = 0
        tableView.parallaxHeader.mode = .bottomFill
        guard let ingr = post.ingredients else { return }
        self.createArray(ingredients: ingr)
        setupNavBar()
        setupButtons()
    }
    
    private func setupNavBar() {
        let backButton = UIButton()
        // backButton.inkColor = UIColor.lightGray
        backButton.backgroundColor = .clear
        //backButton.setBackgroundColor(.clear, for: .normal)
        backButton.setImage(UIImage(named: "arrow-left-black"), for: .normal)
        //backButton.setImage(UIImage(named: "arrow-left-black"), for: .highlighted)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.contentMode = .scaleAspectFill
        backButton.addTarget(self, action: #selector(back), for: .touchUpInside)
        let barLeftButton = UIBarButtonItem(customView: backButton)
        self.navigationItem.leftBarButtonItem = barLeftButton
        let likeButton = MDCButton()
        likeButton.inkColor = UIColor.lightGray
        likeButton.layer.cornerRadius = 48
        likeButton.setBackgroundColor(.clear, for: .normal)
        // button.setBackgroundColor(.gray, for: .normal)
        likeButton.setImage(UIImage(named: "icons8-heart-outline-24-2"), for: .normal)
        //backButton.setImage(UIImage(named: "arrow-left-black"), for: .highlighted)
        likeButton.translatesAutoresizingMaskIntoConstraints = false
        likeButton.contentMode = .scaleAspectFill
        let barRightButton = UIBarButtonItem(customView: likeButton)
        self.navigationItem.rightBarButtonItem = barRightButton
    }

    private func setupButtons() {
        self.view.addSubview(backButton)
        self.view.addSubview(likeButton)
        backButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 8).isActive = true
        backButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 48).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 48).isActive = true
        backButton.addTarget(self, action: #selector(back), for: .touchUpInside)
        
        likeButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 8).isActive = true
        likeButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16).isActive = true
        likeButton.heightAnchor.constraint(equalToConstant: 48).isActive = true
        likeButton.widthAnchor.constraint(equalToConstant: 48).isActive = true
    }
        
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print(scrollView.contentOffset.y)
        if scrollView.contentOffset.y > -100 {
            self.backButton.isHidden = true
            self.likeButton.isHidden = true
            self.navigationController?.setNavigationBarHidden(false, animated: true)
        }
        else {
            self.backButton.isHidden = false
            self.likeButton.isHidden = false
            self.navigationController?.setNavigationBarHidden(true, animated: true)
        }
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: recipeDetailCellId)!
        cell.textLabel?.text = ingredients[indexPath.item]
        return cell
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
//            view.post = self.post
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        titleLabel.textColor = .gray
        titleLabel.text = post?.title

        let timeLabel = UILabel()
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.font = UIFont.boldSystemFont(ofSize: 20)
        timeLabel.text = post?.time


        let caloriesLabel = UILabel()
        caloriesLabel.translatesAutoresizingMaskIntoConstraints = false
        caloriesLabel.font = UIFont.boldSystemFont(ofSize: 18)
        caloriesLabel.textColor = .white
        caloriesLabel.clipsToBounds = true
        caloriesLabel.textAlignment = .center
        caloriesLabel.layer.cornerRadius = 4
        caloriesLabel.backgroundColor = UIColor.init(red: 106/255, green: 191/255, blue: 123/255, alpha: 1)
        caloriesLabel.text = "\(post!.calories) кКал"

        view.addSubview(timeLabel)
        view.addSubview(titleLabel)
        view.addSubview(caloriesLabel)
        
        timeLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 16).isActive = true
        timeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true

        // let constant = self.view.frame.width - 126
        caloriesLabel.centerYAnchor.constraint(equalTo: timeLabel.centerYAnchor).isActive = true
//        caloriesLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: constant).isActive = true
        caloriesLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        caloriesLabel.heightAnchor.constraint(equalToConstant: 24).isActive = true
        caloriesLabel.widthAnchor.constraint(equalToConstant: 110).isActive = true

        titleLabel.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 8).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true

        view.sizeToFit()
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 80
    }
        
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ingredients.count
    }
        
    private func createArray(ingredients: String) {
        self.ingredients = ingredients.components(separatedBy: ",")
        tableView.reloadData()
    }
        
    @objc func back() {
        self.navigationController?.popViewController(animated: true)
    }
}
