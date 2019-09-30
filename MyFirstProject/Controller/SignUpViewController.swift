//
//  SignUpViewController.swift
//  MyFirstProject
//
//  Created by Alex Koblik-Zelter on 9/12/19.
//  Copyright © 2019 Alex Koblik-Zelter. All rights reserved.
//

import UIKit
import FirebaseAuth
import AlertOnboarding

class SignUpViewController: UIViewController, UITextFieldDelegate, AlertOnboardingDelegate {
    
    func alertOnboardingSkipped(_ currentStep: Int, maxStep: Int) {
        print("Skip")
        self.dismiss(animated: true)
    }
    
    func alertOnboardingCompleted() {
        print("Complete")
        self.dismiss(animated: true)
    }
    
    func alertOnboardingNext(_ nextStep: Int) {
        print("Next")
    }
    
    
    var alertView: AlertOnboarding!
    var arrayOfImage = ["onboard1", "onboard2", "onboard3", "onboard4"]
    var arrayOfDescription = ["Найдите подходящий рациона и мы вместе рассчитаем КБЖУ и размер порций специально для вас! Выбор за вами!", "Приготовим вкусные и полезные блюда для вас! Или найдите любимый рецепт прямо в приложении!", "Наши курьеры доставят вам еду в любое удобное для вас время!", "Любое наше блюдо из готовых рационов или же рецепт - сплошное наслаждение!"]
    var arrayOfTitle = ["Выбор рациона",
                              "Вкусно и полезно",
                              "Доставим в любое время","Наслаждайтесь"]
    
    var sex: String?
    let source = ["", "Female", "Male", "Other","Denis"]
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
        button.setTitle("Sign Up", for: .normal)
        button.backgroundColor = .init(red: 106/255, green: 191/255, blue: 123/255, alpha: 0.5)
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.white, for: .normal)
        button.isEnabled = false
        return button
    }()
    
    
    let dataInput: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "Data"
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.addTarget(self, action: #selector(enableSignInButton), for: .allEvents)
      //  tf.addTarget(self, action: #selector(enableSignInButton), for: .editingChanged)
        
        return tf
    }()
    
    let sexInput: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "Sex"
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.addTarget(self, action: #selector(enableSignInButton), for: .allEvents)
        return tf
    }()
    
    let datePicker: UIDatePicker = {
        let dp = UIDatePicker()
        dp.datePickerMode = .date
        dp.translatesAutoresizingMaskIntoConstraints = false
        return dp
    }()
    
    let sexPicker: UIPickerView = {
        let pv = UIPickerView()
        //dp.datePickerMode = .date
        pv.translatesAutoresizingMaskIntoConstraints = false
        return pv
    }()
    
    let signUpButton: UIButton = {
        let button = UIButton(type: .system)
     //   button.setTitle("Already have an account? Sign In.", for: .normal)
        
        let attributedTitle = NSMutableAttributedString(string: "Already have an account?   ", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        attributedTitle.append(NSMutableAttributedString(string: "Sign In", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.rgbColor(red: 106, green: 191, blue: 123)]))
        
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(signIn), for: .touchUpInside)
        //button.addTarget(self, action: #selector(signUp), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.setupView()
        self.dismissKey()
        // Do any additional setup after loading the view.
    }
    
    private func setupView() {
        self.view.addSubview(dataInput)
        
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
        
        let stackView = UIStackView(arrangedSubviews: [loginInput, passwordInput, dataInput, sexInput, loginButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 16
        
        self.view.addSubview(stackView)
        
        stackView.topAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: 40).isActive = true
        stackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 40).isActive = true
        stackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -40).isActive = true
        stackView.heightAnchor.constraint(equalToConstant: 250).isActive = true
        loginButton.addTarget(self, action: #selector(signUp), for: .touchUpInside)
        
        self.dataKeyboard()
        self.sexKeyboard()
    }
    
    private func dataKeyboard() {
       // self.view.addSubview(datePicker)
        
        
        datePicker.maximumDate = Date()
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneAction))
        toolBar.setItems([doneButton], animated: true)
        dataInput.inputAccessoryView = toolBar
        dataInput.inputView = datePicker
    }
    
    private func sexKeyboard() {
       
        self.sexPicker.delegate = self
        self.sexPicker.dataSource = self
        
        
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneSexAction))
        toolBar.setItems([doneButton], animated: true)
        
        sexInput.inputAccessoryView = toolBar
        sexInput.inputView = sexPicker
        
        
        
    }
    @objc func signUp() {
        guard let email = loginInput.text else { return }
        guard let password = passwordInput.text else { return }
        guard let date = dataInput.text else { return }
        guard let sex = sexInput.text else { return }
        Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
            if let result = result {
                print(result.user.uid)
                let uid = result.user.uid
                APIManager.shared.createUser(uid: uid, email: email, date: date, sex: sex)
                self.alertView = AlertOnboarding(arrayOfImage: self.arrayOfImage, arrayOfTitle: self.arrayOfTitle, arrayOfDescription: self.arrayOfDescription)
                self.alertView.delegate = self
                self.alertView.colorButtonText = .white
                self.alertView.colorTitleLabel = .rgbColor(red: 106, green: 191, blue: 123)
               // self.alertView.colorDescriptionLabel = UIColor.whiteColor()
                self.alertView.colorButtonBottomBackground = .rgbColor(red: 106, green: 191, blue: 123)
                DispatchQueue.main.async {
                    self.alertView.show()
                }
            } else {
                print("Fail to signIn", err)
            }
        }
        
    }
    @objc func doneAction() {
        
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy"
        let dateString = dateFormatter.string(from: date)
        self.dataInput.text = dateString
        self.view.endEditing(true)
    }
    
    @objc func doneSexAction() {
        sexInput.text = sex
        self.view.endEditing(true)
    }
    
    @objc func signIn() {
        self.navigationController?.popViewController(animated: true)
        
    }
    
    @objc func enableSignInButton() {
        let isValid = loginInput.text?.count ?? 0 > 0 && passwordInput.text?.count ?? 0 > 6 && sexInput.text?.count ?? 0 > 0 && dataInput.text?.count ?? 0 > 0
        if (isValid) {
            loginButton.isEnabled = true
            loginButton.backgroundColor = .rgbColor(red: 106, green: 191, blue: 123)
        }
        else {
            loginButton.isEnabled = false
            loginButton.backgroundColor = .init(red: 106/255, green: 191/255, blue: 123/255, alpha: 0.5)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

}

extension SignUpViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return source.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return source[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        sex = source[row]
    }
    
    
}
