//
//  MainTabBarController.swift
//  MyFirstProject
//
//  Created by Alex Koblik-Zelter on 9/10/19.
//  Copyright © 2019 Alex Koblik-Zelter. All rights reserved.
//

import UIKit
import FirebaseAuth

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUser()
        setupViewControllers()
        // Do any additional setup after loading the view.
    }
    
    private func setupUser() {
        if Auth.auth().currentUser == nil {
            DispatchQueue.main.async {
                let vc = SignInViewController()
                vc.view.backgroundColor = UIColor(named: "BackgroundColor")
                let navController = UINavigationController(rootViewController: vc)
                navController.modalPresentationStyle = .fullScreen
                navController.isNavigationBarHidden = true
                self.present(navController, animated: true)
            }
            return
        }
        else { print(Auth.auth().currentUser?.uid) }
    }
    private func setupViewControllers() {
        let homeController = HomeViewController()
        let homeNavController = UINavigationController(rootViewController: homeController)
        //homeNavController.tabBarItem.title = "home"
        homeNavController.tabBarItem.image = UIImage(named: "home-0")
        let searchController = SearchViewController()
        let searchNavController = UINavigationController(rootViewController: searchController)
        searchNavController.tabBarItem.image = UIImage(named: "cooking")
        
        let savedController = SavedRecipesViewController()
        let savedNavController = UINavigationController(rootViewController: savedController)
        savedNavController.tabBarItem.image = UIImage(named: "pin")
        
        let aboutUsController = AboutUsViewController()
        let aboutUsNavController = UINavigationController(rootViewController: aboutUsController)
        aboutUsNavController.tabBarItem.image = UIImage(named: "profile-0")

        tabBar.tintColor = UIColor(named: "TabColor")
        tabBar.isTranslucent = false
        viewControllers = [homeNavController, searchNavController, savedNavController, aboutUsNavController]
        
        
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
