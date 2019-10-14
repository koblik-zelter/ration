//
//  AboutUsViewController.swift
//  MyFirstProject
//
//  Created by Alex Koblik-Zelter on 10/8/19.
//  Copyright © 2019 Alex Koblik-Zelter. All rights reserved.
//

import UIKit

class AboutUsViewController: UIViewController {
    let scrollView = UIScrollView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(named: "BackgroundColor")
        self.setupNavBar()
        self.setupScrollView()
        // Do any additional setup after loading the view.
    }
    
    private func setupNavBar() {
         self.navigationController?.navigationBar.barTintColor = .rgbColor(red: 106, green: 191, blue: 123)
    }
    
    private func setupScrollView() {
        self.view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = UIColor(named: "BackgroundColor")
       // scrollView.alwaysBounceVertical = true
        scrollView.isScrollEnabled = true
        scrollView.showsVerticalScrollIndicator = true
        scrollView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        let label = UILabel()
        label.text = "TEST"
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        self.scrollView.addSubview(label)
        label.bottomAnchor.constraint(equalTo: self.scrollView.topAnchor, constant: 1000).isActive = true
        label.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
    
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
