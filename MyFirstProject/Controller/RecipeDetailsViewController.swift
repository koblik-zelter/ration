////
////  RecipeDetailsViewController.swift
////  MyFirstProject
////
////  Created by Alex Koblik-Zelter on 9/28/19.
////  Copyright © 2019 Alex Koblik-Zelter. All rights reserved.
////
//
//import UIKit
//import Alamofire
//import ParallaxHeader
//import Kingfisher
//import MaterialComponents
//
//fileprivate let recipeDetailCellId = "recipeDetailCellId"
//fileprivate let headerId = "RecipeHeaderID"
//class RecipeDetailsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate, UICollectionViewDelegateFlowLayout {
//
//
//    let colectionViewLayout = UICollectionViewFlowLayout()
//    var collectionView: UICollectionView!
//
//    var post: Post? {
//        didSet {
//            guard let post = post else { return }
//            guard let url = URL(string: post.imageURL) else { return }
//            let imageResource = ImageResource(downloadURL: url)
//            self.categoryImageView.kf.setImage(with: imageResource)
//        }
//    }
//    var ingredients: [String] = []
//    var backButton: MDCButton = {
//        let backButton = MDCFloatingButton()
//        backButton.inkColor = UIColor.lightGray
//        backButton.setBackgroundColor(.init(white: 1, alpha: 1), for: .normal)
//        backButton.setImage(UIImage(named: "arrow-left-black"), for: .normal)
//        backButton.translatesAutoresizingMaskIntoConstraints = false
//        backButton.contentMode = .scaleAspectFill
//        return backButton
//    }()
//
//    var likeButton: MDCButton = {
//          let backButton = MDCFloatingButton()
//          backButton.inkColor = UIColor.lightGray
//          backButton.setBackgroundColor(.init(white: 1, alpha: 1), for: .normal)
//          backButton.setImage(UIImage(named: "icons8-heart-outline-24-2"), for: .normal)
//          backButton.translatesAutoresizingMaskIntoConstraints = false
//          backButton.contentMode = .scaleAspectFill
//          return backButton
//      }()
//    let categoryImageView: UIImageView = {
//        let iv = UIImageView()
//        iv.clipsToBounds = true
//        iv.contentMode = .scaleAspectFill
//        iv.translatesAutoresizingMaskIntoConstraints = false
//        return iv
//    }()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        self.view.backgroundColor = .white
//        setupCollection()
//        // Do any additional setup after loading the view.
//    }
//
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(true)
//        //self.navigationController?.isNavigationBarHidden = true
//    }
//
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        self.navigationController?.setNavigationBarHidden(true, animated: animated)
//       // self.navigationController?.navigationBar.barTintColor = .white
//    }
//
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(true)
//        self.navigationController?.setNavigationBarHidden(false, animated: animated)
//        self.navigationController?.navigationBar.barTintColor = .rgbColor(red: 106, green: 191, blue: 123)
//    }
//    private func setupCollection() {
//        collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: colectionViewLayout)
//        collectionView.backgroundColor = .white
//        collectionView.translatesAutoresizingMaskIntoConstraints = false
//        collectionView.showsHorizontalScrollIndicator = false
//        collectionView.clipsToBounds = true
//        collectionView.register(IngredientCell.self, forCellWithReuseIdentifier: recipeDetailCellId)
//        self.view.addSubview(collectionView)
//        collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
//        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
//        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
//        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
//        collectionView.dataSource = self
//        collectionView.delegate = self
//        collectionView.register(RecipeDetailHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
//        collectionView.parallaxHeader.view = categoryImageView
//        guard let post = post else { return }
//        collectionView.parallaxHeader.height = 500
//        collectionView.parallaxHeader.minimumHeight = 0
//        collectionView.parallaxHeader.mode = .topFill
//        guard let ingr = post.ingredients else { return }
//        self.createArray(ingredients: ingr)
//        setupNavBar()
//        setupNavBar1()
//    }
//    /*
//    private func setupViews() {
//        self.view.addSubview(tableView)
//        tableView.delegate = self
//        tableView.dataSource = self
//        tableView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
//        tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
//        tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
//        tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
//        tableView.register(UITableViewCell.self, forCellReuseIdentifier: recipeDetailCellId)
//        //tableView.register(RecipeDetailHeader.self, forHeaderFooterViewReuseIdentifier: headerId)
//        tableView.layer.cornerRadius = 16
//        tableView.clipsToBounds = true
//        tableView.parallaxHeader.view = categoryImageView
//        guard let post = post else { return }
//        tableView.parallaxHeader.height = post.imageHeight * 2
//        tableView.parallaxHeader.minimumHeight = 0
//        tableView.parallaxHeader.mode = .topFill
//        guard let ingr = post.ingredients else { return }
//        self.createArray(ingredients: ingr)
//        setupNavBar()
//        setupNavBar1()
//    }
//    */
//    private func setupNavBar() {
//        let backButton = UIButton()
//       // backButton.inkColor = UIColor.lightGray
//        backButton.backgroundColor = .clear
//        //backButton.setBackgroundColor(.clear, for: .normal)
//        backButton.setImage(UIImage(named: "arrow-left-black"), for: .normal)
//        //backButton.setImage(UIImage(named: "arrow-left-black"), for: .highlighted)
//        backButton.translatesAutoresizingMaskIntoConstraints = false
//        backButton.contentMode = .scaleAspectFill
//        backButton.addTarget(self, action: #selector(back), for: .touchUpInside)
//        let barLeftButton = UIBarButtonItem(customView: backButton)
//        self.navigationItem.leftBarButtonItem = barLeftButton
//        let likeButton = MDCButton()
//        likeButton.inkColor = UIColor.lightGray
//        likeButton.layer.cornerRadius = 48
//        likeButton.setBackgroundColor(.clear, for: .normal)
//        // button.setBackgroundColor(.gray, for: .normal)
//        likeButton.setImage(UIImage(named: "icons8-heart-outline-24-2"), for: .normal)
//               //backButton.setImage(UIImage(named: "arrow-left-black"), for: .highlighted)
//        likeButton.translatesAutoresizingMaskIntoConstraints = false
//        likeButton.contentMode = .scaleAspectFill
//        let barRightButton = UIBarButtonItem(customView: likeButton)
//        self.navigationItem.rightBarButtonItem = barRightButton
//
//    }
//
//    private func setupNavBar1() {
//        self.view.addSubview(backButton)
//        self.view.addSubview(likeButton)
//        backButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 8).isActive = true
//        backButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16).isActive = true
//        backButton.heightAnchor.constraint(equalToConstant: 48).isActive = true
//        backButton.widthAnchor.constraint(equalToConstant: 48).isActive = true
//        backButton.addTarget(self, action: #selector(back), for: .touchUpInside)
//
//        likeButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 8).isActive = true
//        likeButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16).isActive = true
//        likeButton.heightAnchor.constraint(equalToConstant: 48).isActive = true
//        likeButton.widthAnchor.constraint(equalToConstant: 48).isActive = true
//
//    }
//
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        print(scrollView.contentOffset.y)
//        if scrollView.contentOffset.y > -100 {
//            self.backButton.isHidden = true
//            self.likeButton.isHidden = true
//            self.navigationController?.setNavigationBarHidden(false, animated: true)
//        }
//        else {
//            self.backButton.isHidden = false
//            self.likeButton.isHidden = false
//            self.navigationController?.setNavigationBarHidden(true, animated: true)
//        }
//    }
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return ingredients.count
//    }
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//
//        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: recipeDetailCellId, for: indexPath) as? IngredientCell else { return UICollectionViewCell() }
//        cell.titleLabel.text = ingredients[indexPath.item]
//        //cell.titleLabel.text = "\(indexPath.item)"
//        return cell
//    }
//
//    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//        let header = UICollectionReusableView()
//        switch kind {
//            case UICollectionView.elementKindSectionHeader:
//                guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as? RecipeDetailHeader else { return UICollectionReusableView() }
//                header.post = self.post
//                return header
//            default:
//                assert(false, "Unexpected element kind")
//            }
//        return header
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: self.view.frame.width, height: 25)
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
//        return CGSize(width: self.view.frame.width, height: 80)
//    }
//
//
////    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
////        let cell = tableView.dequeueReusableCell(withIdentifier: recipeDetailCellId)!
////        cell.textLabel?.text = ingredients[indexPath.item]
////        return cell
////    }
////
////    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
////        let view = RecipeDetailHeader()
////        view.post = self.post
////        return view
////    }
////
////    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
////        return 70
////    }
////    func numberOfSections(in tableView: UITableView) -> Int {
////        return 2
////    }
////
////    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
////        tableView.deselectRow(at: indexPath, animated: true)
////    }
////    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
////        return ingredients.count
////    }
//
//    private func createArray(ingredients: String) {
//        self.ingredients = ingredients.components(separatedBy: ",")
//        collectionView.reloadData()
//    }
//
//    @objc func back() {
//        self.navigationController?.popViewController(animated: true)
//    }
//
//    /*
//    // MARK: - Navigation
//
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destination.
//        // Pass the selected object to the new view controller.
//    }
//    */
//
//}
//
