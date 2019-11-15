//
//  SearchViewController.swift
//  MyFirstProject
//
//  Created by Alex Koblik-Zelter on 9/20/19.
//  Copyright © 2019 Alex Koblik-Zelter. All rights reserved.
//

import UIKit
import PinterestLayout
import MaterialComponents
import CoreData
import Alamofire

let chipsHeaderID = "chipsHeaderID"
class SearchViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchControllerDelegate, UISearchBarDelegate, UIGestureRecognizerDelegate, CategoryDelegate {
    
    static let name = NSNotification.Name(rawValue: "update tableView")
    let pinterestLayout: PinterestLayout = PinterestLayout()
    var collectionView: UICollectionView!
    var chipsHandler = ChipsHandler()
    var recipes: [Post] = []
    var selectedRecipes: [Post] = []
    var savedRecipes: [Recipe] = []
    var categories: [Category] = []
    var searchController : UISearchController!
    var selectedCategory: Category?
    
    let refreshControl: UIRefreshControl = {
        let rc = UIRefreshControl()
        rc.translatesAutoresizingMaskIntoConstraints = false
        rc.tintColor = .rgbColor(red: 106, green: 191, blue: 123)
        return rc
    }()

    
    private lazy var addBarButtonItem: UIBarButtonItem = {
        return UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addBarButtonTapped))
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.extendedLayoutIncludesOpaqueBars = false
        self.updateNavButtonsState()
        self.setupViews()
        self.setupSearchBar()
        self.setupNavBar()
        self.setupLongRec()
        self.downloadCategories()
       // self.downloadRecipes()
        self.fetchSavedRecipes()
        
    }
    
    private func updateNavButtonsState() {
        addBarButtonItem.isEnabled = selectedRecipes.count != 0
    }
    
    
    private func setupViews() {
        collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: pinterestLayout)
        collectionView.backgroundColor = UIColor(named: "BackgroundColor")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.bounces = true
        collectionView.register(HomePostCell.self, forCellWithReuseIdentifier: cellID)
        self.view.addSubview(collectionView)
        collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 16).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        collectionView.dataSource = self
        //collectionView.allowsMultipleSelection
        collectionView.delegate = self
        collectionView.keyboardDismissMode = .onDrag
        collectionView.register(ChipsHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: chipsHeaderID)
        
        collectionView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(updateData), for: .valueChanged)
        self.pinterestLayout.delegate = self
        self.pinterestLayout.cellPadding = 0
        self.pinterestLayout.numberOfColumns = 2
        self.definesPresentationContext = true
        self.chipsHandler.delegate = self
    }

    private func setupSearchBar() {
        //Search at the top
        self.navigationController?.navigationBar.barTintColor = UIColor(named: "NavBarColor")
        self.searchController = UISearchController(searchResultsController:  nil)
        
        self.searchController.delegate = self
        self.searchController.searchBar.delegate = self
        
        self.searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.obscuresBackgroundDuringPresentation = true
        self.searchController.searchBar.clipsToBounds = true
        searchController.searchBar.sizeToFit()
        let attributes = [NSAttributedString.Key.foregroundColor : UIColor(named: "SearchColor")]
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).backgroundColor = UIColor(named: "SearchColor")
       
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).clipsToBounds = true
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).layer.cornerRadius = 22
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).setTitleTextAttributes(attributes, for: .normal)       
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).tintColor = UIColor(named: "TextSearchColor")
        
        self.navigationItem.titleView = searchController.searchBar
        searchController.searchBar.becomeFirstResponder()

        let barButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(telegram))
        self.navigationItem.rightBarButtonItem = barButton
    }
    
    func setupNavBar() {
        addBarButtonItem.tintColor = .white
        self.navigationItem.rightBarButtonItems = [addBarButtonItem]
        addBarButtonItem.isEnabled = false
    }
    
    private func setupLongRec() {
        let lpgr = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        lpgr.minimumPressDuration = 0.25
        lpgr.delaysTouchesBegan = true
        lpgr.delegate = self
        self.collectionView.addGestureRecognizer(lpgr)
    }
    
    private func checkForSaving(post: Post) -> Bool {
        var result = true
        savedRecipes.forEach { (recipe) in
            if (recipe.title == post.title) {
                result = false
            }
        }
        return result
    }
    
    @objc func handleLongPress(gestureReconizer: UILongPressGestureRecognizer) {
        if gestureReconizer.state != UIGestureRecognizer.State.ended {
            return
        }

        let location = gestureReconizer.location(in: self.collectionView)
        let indexPath = self.collectionView.indexPathForItem(at: location)
        if let index = indexPath {
            guard let cell = self.collectionView.cellForItem(at: index) as? HomePostCell else { return }
            if cell.isPressed {
                guard let index = selectedRecipes.firstIndex(of: cell.post!) else { return }
                selectedRecipes.remove(at: index)
            }
            else if checkForSaving(post: cell.post!) {
                selectedRecipes.append(cell.post!)
            }
            else {
                alreadySavedFunc()
                return
            }
            cell.isPressed = !cell.isPressed
            updateNavButtonsState()
        } else {
            print("Could not find index path")
        }
    }
    
    
    private func fetchSavedRecipes() {
        self.savedRecipes = CoreDataManager.shared.fetchRecipes()
    }
    
    
    private func downloadCategories() {
        APIManager.shared.downloadCategories(childKey: "RecipesCategories") { (categories) in
            self.categories.append(contentsOf: categories)
            self.categories.sort { return $0.id < $1.id }
            self.didTapOn(category: self.categories[0])
            self.chipsHandler.addCategories(categories: self.categories)
            DispatchQueue.main.async {
                let header = self.getCollectionHeader()
                self.collectionView.collectionViewLayout.invalidateLayout()
                header?.categoryCollection.reloadData()
                self.collectionView.reloadData()
            }
        }
    }
    
    private func alreadySavedFunc() {
        let alertController = UIAlertController(title: "Сохранение", message: "Вы уже сохранили данный рецепт", preferredStyle: .alert)
        let action = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(action)
        self.present(alertController, animated: true)
    }
    
    /*
    private func downloadRecipes() {
        APIManager.shared.downloadRecipes(completion: { (recipes) in
            self.recipes.removeAll()
            self.recipes.append(contentsOf: recipes)
            DispatchQueue.main.async {
                self.collectionView.refreshControl?.endRefreshing()
                self.collectionView.reloadData()
            }
        })
    }
 */
    
    func didTapOn(category: Category) {
        self.selectedCategory = category
        self.collectionView.refreshControl?.endRefreshing()
        APIManager.shared.downloadPosts(childKey: "RecipesByCategory", categoryID: category.id) { (recipes) in
            self.recipes.removeAll()
            self.recipes.append(contentsOf: recipes)
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    @objc func updateData() {
        collectionView.refreshControl?.beginRefreshing()
        self.didTapOn(category: self.selectedCategory!)
    }
    
    
    @objc func addBarButtonTapped() {
        let alert = UIAlertController(title: "Рецепты на вашем устройстве", message: "Сохранить выбранные рецепты?", preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Yes", style: .default) { (action) in
            // TODO SAVING PHOTO
            self.selectedRecipes.forEach { (post) in
                self.saveRecipe(post: post)
                self.postBadge()
            }
            NotificationCenter.default.post(name: SearchViewController.name, object: nil)
            self.selectedRecipes.removeAll()
            self.updateNavButtonsState()
            self.collectionView.reloadData()
        }
        
        let noAction = UIAlertAction(title: "No", style: .destructive) { (action) in
            self.collectionView.reloadData()
            self.selectedRecipes.removeAll()
        }
        
        alert.addAction(saveAction)
        alert.addAction(noAction)
        self.present(alert, animated: true)
    }
    
    private func saveRecipe(post: Post) {
        print("Trying to save recipe")
        let context = CoreDataManager.shared.persistentContainer.viewContext
        
        let recipe = NSEntityDescription.insertNewObject(forEntityName: "Recipe", into: context)
        
        recipe.setValue(post.title, forKey: "title")
        recipe.setValue(post.calories, forKey: "calories")
        recipe.setValue(post.imageHeight, forKey: "imageHeight")
        recipe.setValue(post.time, forKey: "time")
        recipe.setValue(post.ingredients, forKey: "ingredients")
        
        do {
            try context.save()
            self.fetchSavedRecipes()
            print("success")
        }
        catch let saveErr {
            print("Fail to save", saveErr)
        }
    }
    
    private func postBadge() {
        if let tabItems = tabBarController?.tabBar.items {
            // In this case we want to modify the badge number of the third tab:
            let tabItem = tabItems[2]
            tabItem.isEnabled = true
            tabItem.badgeValue = "\(selectedRecipes.count)"
        }
    }
    private func getCollectionHeader() -> ChipsHeader? {
        return self.collectionView.supplementaryView(forElementKind: UICollectionView.elementKindSectionHeader, at: IndexPath(row: 0, section: 0)) as? ChipsHeader
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recipes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as? HomePostCell else { return UICollectionViewCell() }
        
        print(cell.frame.origin.x)
        if cell.frame.origin.x != 0 {
            cell.isRight = true
        }
        else {
            cell.isRight = false
        }
        cell.post = recipes[indexPath.item]
        return cell
    }
    

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = UICollectionReusableView()
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: chipsHeaderID, for: indexPath) as? ChipsHeader else { return UICollectionReusableView() }
            header.categoryCollection.register(MDCChipCollectionViewCell.self, forCellWithReuseIdentifier: categoryCellID)
            header.categoryCollection.delegate = chipsHandler
            header.categoryCollection.dataSource = chipsHandler
            return header
        default:
            assert(false, "Unexpected element kind")
        }
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = TestViewController()
        vc.post = recipes[indexPath.item]
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if(!(searchBar.text?.isEmpty)!){
            //reload your data source if necessary
            guard let text = searchBar.text else { return }
            APIManager.shared.findInDB(text: text)
        }
    }
    
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        // do your thing
        searchController.searchBar.resignFirstResponder()
    }
 
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if(!searchText.isEmpty) {
            //reload your data source if necessary
            //guard let text = searchBar.text else { return }
            print(searchText)
            //self.downloadPosts(id: text)
          //  self.collectionView?.reloadData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 32, left: 0, bottom: 16, right: 0)
    }
    
    func image(indexPath: IndexPath, completion: @escaping(Data) -> Void) {
        let post = recipes[indexPath.item]
        Alamofire.request(post.imageURL).responseData { (response) in
            if response.error == nil {
                print(response.result)
                    // Show the downloaded image:
                if let data = response.data {
                    completion(data)
                    //vc.categoryImageView.image = UIImage(data: data)
                    //self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
    }
}


extension SearchViewController: PinterestLayoutDelegate {
    func collectionView(collectionView: UICollectionView, heightForAnnotationAtIndexPath indexPath: IndexPath, withWidth: CGFloat) -> CGFloat {
        return 60
    }
    
    func collectionView(collectionView: UICollectionView, heightForImageAtIndexPath indexPath: IndexPath, withWidth: CGFloat) -> CGFloat {
        let recipe = self.recipes[indexPath.item]
        let height = recipe.imageHeight
        return height
    }
    func collectionView(collectionView: UICollectionView, sizeForSectionHeaderViewForSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 50)
    }
    
  
}
 

