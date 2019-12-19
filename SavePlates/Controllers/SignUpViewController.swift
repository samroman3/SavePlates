//
//  SignUpViewController.swift
//  SavePlates
//
//  Created by Sam Roman on 12/18/19.
//  Copyright © 2019 Sam Roman. All rights reserved.
//


import UIKit
import FirebaseAuth

class SignUpViewController: UIViewController {
    

    
    //MARK: UI TextFields
    
    lazy var logoLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont(name: "Trebuchet MS", size: 100)
        let attributedTitle = NSMutableAttributedString(string: "new account", attributes: [NSAttributedString.Key.font: UIFont(name: "Trebuchet MS", size: 80)!, NSAttributedString.Key.foregroundColor: UIColor.systemBlue])
        label.attributedText = attributedTitle
        label.backgroundColor = .clear
        label.textAlignment = .center
        return label
    }()
    lazy var emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = " Enter Email..."
        textField.autocorrectionType = .no
        textField.textAlignment = .left
        textField.layer.cornerRadius = 15
        textField.backgroundColor = .white
        textField.textColor = .black
        textField.borderStyle = .roundedRect
        textField.addTarget(self, action: #selector(validateFields), for: .editingChanged)
        textField.delegate = self
        return textField
    }()
    
    lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = " Enter Password..."
        textField.autocorrectionType = .no
        textField.textAlignment = .left
        textField.isSecureTextEntry = true
        textField.layer.cornerRadius = 15
        textField.backgroundColor = .white
        textField.textColor = .black
        textField.borderStyle = .roundedRect
        textField.addTarget(self, action: #selector(validateFields), for: .editingChanged)
        textField.delegate = self
        return textField
    }()
    
//    lazy var userNameTextField: UITextField = {
//        let textField = UITextField()
//        textField.placeholder = " Enter Username..."
//        textField.autocorrectionType = .no
//        textField.textAlignment = .left
//        textField.layer.cornerRadius = 15
//        textField.backgroundColor = .init(white: 1.0, alpha: 0.2)
//        textField.textColor = .black
//        textField.borderStyle = .roundedRect
//        textField.addTarget(self, action: #selector(validateFields), for: .editingChanged)
//        return textField
//    }()
    
    lazy var emailIcon: UIImageView = {
        let icon = UIImageView()
        icon.image = UIImage(systemName: "at", withConfiguration: .none)
        icon.tintColor = .lightGray
        icon.backgroundColor = .clear
        return icon
    }()
    
    lazy var passwordIcon: UIImageView = {
        let icon = UIImageView()
        icon.image = UIImage(systemName: "lock.circle", withConfiguration: .none)
        icon.tintColor = .lightGray
        icon.backgroundColor = .clear
        return icon
    }()
    
    lazy var alreadyHaveAccountButton: UIButton = {
        let button = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(string: "Already have an account?  ", attributes: [NSAttributedString.Key.font: UIFont(name: "Verdana", size: 14)!, NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        attributedTitle.append(NSAttributedString(string: "Login!", attributes: [NSAttributedString.Key.font: UIFont(name: "Verdana-Bold", size: 14)!, NSAttributedString.Key.foregroundColor:  UIColor.systemBlue ]))
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.addTarget(self, action: #selector(showLogIn), for: .touchUpInside)
     
        return button
    }()
    
    lazy var signUpButton: UIButton = {
        let button = UIButton()
        button.setTitle("Sign Up", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = button.titleLabel?.font.withSize(34)
        button.backgroundColor = .systemBlue
        button.addTarget(self, action: #selector(trySignUp), for: .touchUpInside)
        button.isEnabled = true
        return button
    }()
    
    override func viewDidLoad() {
        ColorScheme.setUpBackgroundColor(view)
        setUpConstraints()
        super.viewDidLoad()
    }
    
    //MARK: Private Methods
    private func showAlert(with title: String, and message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
    
  
    
    //MARK: OBJC Methods
    
    @objc func trySignUp() {
           guard let email = emailTextField.text, let password = passwordTextField.text else {
               showAlert(with: "Error", and: "Please fill out all fields.")
               return
           }
           
           guard email.isValidEmail else {
               showAlert(with: "Error", and: "Please enter a valid email")
               return
           }
           
           guard password.isValidPassword else {
            
               showAlert(with: "Error", and: "Please enter a valid password. Passwords must have at least 8 characters.")
               return
           }
           
           FirebaseAuthService.manager.createNewUser(email: email.lowercased(), password: password) { [weak self] (result) in
               self?.handleCreateAccountResponse(with: result)
           }
       }
   
    private func handleCreateAccountResponse(with result: Result<User, Error>) {
           DispatchQueue.main.async { [weak self] in
               switch result {
               case .success(let user):
                   FirestoreService.manager.createAppUser(user: AppUser(from: user)) { [weak self] newResult in
                       self?.handleCreatedUserInFirestore(result: newResult)
                   }
               case .failure(let error):
                   self?.showAlert(with: "Error creating user", and: "An error occured while creating new account \(error)")
               }
           }
       }
       
       private func handleCreatedUserInFirestore(result: Result<(), Error>) {
           switch result {
           case .success:
               guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                   let sceneDelegate = windowScene.delegate as? SceneDelegate, let window = sceneDelegate.window
                   else {
                       //MARK: TODO - handle could not swap root view controller
                       return
               }
               
               //MARK: TODO - refactor this logic into scene delegate
               UIView.transition(with: window, duration: 0.3, options: .transitionFlipFromBottom, animations: {
                       window.rootViewController = {
                           let mainVC = MainScreenTabBarViewController()
                           return mainVC
                       }()
               }, completion: nil)
           case .failure(let error):
               self.showAlert(with: "Error creating user", and: "An error occured while creating new account \(error)")
           }
       }
    
    @objc func showLogIn() {
        dismiss(animated: true, completion: nil)
    }
    @objc func validateFields() {
              guard emailTextField.hasText, passwordTextField.hasText else {
                  signUpButton.isEnabled = false
                  return
              }
              signUpButton.isEnabled = true
      
          }
    
    
    //MARK: UI Setup
    
    private func setUpConstraints(){
        setupLoginStackView()
        setupHaveAccountButton()
        setupEmailIcon()
        setupPasswordIcon()
        setUpSignUpButton()
        setupHaveAccountButton()
        setupLogoLabel()
        
    }
    
    private func setupLogoLabel() {
              view.addSubview(logoLabel)
              
              logoLabel.translatesAutoresizingMaskIntoConstraints = false
              NSLayoutConstraint.activate([logoLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 20), logoLabel.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 16), logoLabel.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -16)])
          }
    
     private func setupLoginStackView() {
           let stackView = UIStackView(arrangedSubviews: [emailTextField, passwordTextField])
           stackView.axis = .vertical
           stackView.spacing = 20
           stackView.distribution = .fillEqually
           self.view.addSubview(stackView)
           
           stackView.translatesAutoresizingMaskIntoConstraints = false
           NSLayoutConstraint.activate([stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -300),
                                        stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
                                        stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
                                        stackView.heightAnchor.constraint(equalToConstant: 100)])
       }
    private func setupHaveAccountButton() {
            view.addSubview(alreadyHaveAccountButton)
            
            alreadyHaveAccountButton.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([alreadyHaveAccountButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                                         alreadyHaveAccountButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                                         alreadyHaveAccountButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
                                         alreadyHaveAccountButton.heightAnchor.constraint(equalToConstant: 50)])
        }
       
    
    private func setUpSignUpButton(){
        view.addSubview(signUpButton)
        signUpButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            signUpButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 30), signUpButton.widthAnchor.constraint(equalTo: self.view.widthAnchor),
            signUpButton.heightAnchor.constraint(equalToConstant: 70),
            signUpButton.leadingAnchor.constraint(equalTo: view.leadingAnchor)])
        view.layoutIfNeeded()
        
    }
       
       
       private func setupEmailIcon(){
           view.addSubview(emailIcon)
           emailIcon.translatesAutoresizingMaskIntoConstraints = false
           NSLayoutConstraint.activate([
               emailIcon.trailingAnchor.constraint(equalTo: emailTextField.leadingAnchor, constant: -10),
               emailIcon.centerYAnchor.constraint(equalTo: emailTextField.centerYAnchor),
               emailIcon.heightAnchor.constraint(equalToConstant: 30),
               emailIcon.widthAnchor.constraint(equalToConstant: 30)])
       }
       
       private func setupPasswordIcon(){
           view.addSubview(passwordIcon)
           passwordIcon.translatesAutoresizingMaskIntoConstraints = false
           NSLayoutConstraint.activate([
               passwordIcon.trailingAnchor.constraint(equalTo: passwordTextField.leadingAnchor, constant: -10),
               passwordIcon.centerYAnchor.constraint(equalTo: passwordTextField.centerYAnchor),
               passwordIcon.heightAnchor.constraint(equalToConstant: 30),
               passwordIcon.widthAnchor.constraint(equalToConstant: 30)])
       }
       
    
    
}
extension SignUpViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}
