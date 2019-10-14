//
//  SignInViewController.swift
//  MyFirstProject
//
//  Created by Alex Koblik-Zelter on 9/11/19.
//  Copyright © 2019 Alex Koblik-Zelter. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class SignInViewController: UIViewController {
    
    let resetResultLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .lightGray
        label.font = UIFont.robotoCondensed(size: 16)
        label.alpha = 0
        label.textColor = .white
        label.clipsToBounds = true
        label.layer.cornerRadius = 6
        label.textAlignment = .center
        label.text = "TEST"
        return label
    }()
    let backgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .rgbColor(red: 110, green: 198, blue: 128)
        return view
    }()
    
    let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "KOBLZELV - ТВОЯ ЕДА НА КАЖДЫЙ ДЕНЬ"
        label.numberOfLines = 0
        label.textColor = .white
        label.font = UIFont.robotoCondensed(size: 24)
        return label
    }()
    
    let loginInput: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "Email"
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.addTarget(self, action: #selector(enableSignInButton), for: .editingChanged)
        var imageView = UIImageView(image: UIImage(named: "email"))
        imageView.frame = CGRect(x: 0, y: 0, width: imageView.image!.size.width + 16, height: imageView.image!.size.height)
        imageView.contentMode = .center
        tf.leftView = imageView
        tf.leftViewMode = .never
        
        return tf
    }()
    
    let passwordInput: UITextField = {
        let tf = UITextField()
        tf.isSecureTextEntry = true
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "Password"
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.addTarget(self, action: #selector(enableSignInButton), for: .editingChanged)
        return tf
    }()
    
    let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign In", for: .normal)
        button.backgroundColor = .init(red: 106/255, green: 191/255, blue: 123/255, alpha: 0.5)
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.white, for: .normal)
        button.isEnabled = false
        return button
    }()
    
    let resetPassword: UIButton = {
        let button = UIButton(type: .system)
        
        let attributedTitle = NSMutableAttributedString(string: "Reset Password", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.rgbColor(red: 106, green: 191, blue: 123), NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue])
        
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(reset), for: .touchUpInside)
        return button
    }()
    
    let signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Don't have an account? Sign Up.", for: .normal)
        
        let attributedTitle = NSMutableAttributedString(string: "Don't have an account?   ", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        attributedTitle.append(NSMutableAttributedString(string: "Sign Up", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.rgbColor(red: 106, green: 191, blue: 123)]))
        
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(signUp), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "BackgroundColor")
        //self.navigationController?.isNavigationBarHidden = true
        setupView()
        dismissKey()
        // Do any additional setup after loading the view.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
      //  self.navigationController?.isNavigationBarHidden = true
    }
    
    private func setupView() {
        self.view.addSubview(backgroundView)
        self.view.addSubview(label)
        self.view.addSubview(signUpButton)
        
        signUpButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        signUpButton.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        signUpButton.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        signUpButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        backgroundView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: -45).isActive = true
        backgroundView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        backgroundView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        backgroundView.heightAnchor.constraint(equalToConstant: 220).isActive = true
        
        label.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 45).isActive = true
        label.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 40).isActive = true
        label.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -40).isActive = true
        
        let stackView = UIStackView(arrangedSubviews: [loginInput, passwordInput, loginButton, resetPassword])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 16
        self.view.addSubview(stackView)
        stackView.topAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: 40).isActive = true
        stackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 40).isActive = true
        stackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -40).isActive = true
        stackView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        loginButton.addTarget(self, action: #selector(signIn), for: .touchUpInside)
        
        self.view.addSubview(resetResultLabel)
        resetResultLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        resetResultLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        resetResultLabel.heightAnchor.constraint(equalToConstant: 70).isActive = true
        resetResultLabel.widthAnchor.constraint(equalToConstant: 170).isActive = true
        
    }
    
    @objc func signIn() {
        guard let email = loginInput.text else { return }
        guard let password = passwordInput.text else { return }
        
        Auth.auth().signIn(withEmail: email, password: password) { (res, err) in
            if let err = err {
                print("Fail to sign in", err)
            }
            else { print(res?.user.uid)
                self.dismiss(animated: true)
            }
        }
    }
    
    @objc func reset() {
        
        let alertControler = UIAlertController(title: "Reset password", message: "Enter your email", preferredStyle: .alert)
        let save = UIAlertAction(title: "Send", style: .default) { (alertAction) in
            let textField = alertControler.textFields![0] as UITextField
            textField.keyboardType = .emailAddress
            if textField.text != "" {
                Auth.auth().sendPasswordReset(withEmail: textField.text!) { (err) in
                    if let err = err {
                        print("Fail to reset password", err)
                        //self.animate(message: "Ooops...Error! Try again!")
                        self.result(message: "Your email is invalid!")
                    }
                    else {
                        self.result(message: "Check your email!")
                    }
                }
            } else { self.result(message: "Email address cannot be empty!") }
        }

        alertControler.addTextField { (textField) in
            textField.placeholder = "email address"
        }

        alertControler.addAction(save)
        let cancel = UIAlertAction(title: "Cancel", style: .destructive)
        alertControler.addAction(cancel)
        self.present(alertControler, animated: true, completion: nil)
    }
    
    private func result(message: String) {
       
        let alertControler = UIAlertController(title: "Reset password", message: message, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .destructive)
        alertControler.addAction(cancel)
        let deadline = DispatchTime.now()
       // DispatchQueue.main.asyncAfter(deadline: deadline + 9.5) {
        DispatchQueue.main.asyncAfter(deadline: deadline) {
            self.present(alertControler, animated: true)
        }
    }
    private func hideResult() {
        UIView.animate(withDuration: 0.4, delay: 1, animations: {
            self.resetResultLabel.alpha = 0
        })
    }
    
    private func showResult() {
        UIView.animate(withDuration: 0.4, delay: 0.1, animations: {
            self.resetResultLabel.alpha = 0.5
        })
    }
    
    private func animate(message: String) {
        DispatchQueue.main.async {
            self.resetResultLabel.text = message
            self.showResult()
            self.hideResult()
        }
    }
    
    @objc func enableSignInButton() {
        let isValid = loginInput.text?.count ?? 0 > 0 && passwordInput.text?.count ?? 0 > 6
        if (isValid) {
            loginButton.isEnabled = true
            loginButton.backgroundColor = .rgbColor(red: 106, green: 191, blue: 123)
        }
        else {
            loginButton.isEnabled = false
            loginButton.backgroundColor = .init(red: 106/255, green: 191/255, blue: 123/255, alpha: 0.5)
        }
    }
    
    @objc func signUp() {
        let vc = SignUpViewController()
        self.navigationController?.pushViewController(vc, animated: true)
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



