//
//  LoginViewController.swift
//  SavePlates
//
//  Created by Sam Roman on 12/18/19.
//  Copyright © 2019 Sam Roman. All rights reserved.


import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {


    //MARK: UI TextFields

    lazy var logoLabel: UILabel = {
        let label = UILabel()
        ColorScheme.styleHeaderLabel(label)
        label.font = UIFont(name: "Trebuchet MS", size: 100)
        let attributedTitle = NSMutableAttributedString(string: "Save Plates", attributes: [NSAttributedString.Key.font: UIFont(name: "Trebuchet MS", size: 80)!])
        label.attributedText = attributedTitle
        return label
    }()

    lazy var emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = " Enter Email..."
        ColorScheme.styleTextField(textField)
        textField.addTarget(self, action: #selector(validateFields), for: .editingChanged)
        textField.delegate = self
        return textField
    }()

    lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        ColorScheme.styleTextField(textField)
        textField.placeholder = " Enter Password..."
        textField.isSecureTextEntry = true
        textField.addTarget(self, action: #selector(validateFields), for: .editingChanged)
        textField.delegate = self
        return textField
    }()


    lazy var emailIcon: UIImageView = {
        let icon = UIImageView()
        icon.image = UIImage(systemName: "at", withConfiguration: .none)
        icon.tintColor = .white
        icon.backgroundColor = .clear
        return icon
    }()

    lazy var passwordIcon: UIImageView = {
        let icon = UIImageView()
        icon.image = UIImage(systemName: "lock.circle", withConfiguration: .none)
        icon.tintColor = .white
        icon.backgroundColor = .clear
        return icon
    }()

    lazy var loginButton: UIButton = {
        let button = UIButton()
        ColorScheme.styleHollowButton(button)
        button.setTitle("Login", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = button.titleLabel?.font.withSize(34)
        button.addTarget(self, action: #selector(tryLogin), for: .touchUpInside)
        button.isEnabled = false
        return button
    }()

    lazy var createAccountButton: UIButton = {
        let button = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(string: "Dont have an account?  ",
                                                        attributes: [
                                                            NSAttributedString.Key.font: UIFont(name: "Verdana", size: 14)!,
                                                            NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        attributedTitle.append(NSAttributedString(string: "Sign Up",
                                                  attributes: [NSAttributedString.Key.font: UIFont(name: "Verdana-Bold", size: 14)!,
                                                               NSAttributedString.Key.foregroundColor: UIColor.cyan ]))
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.addTarget(self, action: #selector(showSignUp), for: .touchUpInside)
        return button
    }()


    override func viewDidLoad() {
        super.viewDidLoad()
        ColorScheme.setUpBackgroundColor(view)
        setUpConstraints()
    }

    //MARK: Private Methods
    private func clearAllFields(){
        emailTextField.text = ""
        passwordTextField.text = ""
    }

    private func showAlert(with title: String, and message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }

    //MARK: OBJ-C Methods

    @objc func validateFields() {
        guard emailTextField.hasText, passwordTextField.hasText else {
            loginButton.isEnabled = false
            return
        }
        loginButton.isEnabled = true

    }


    @objc func tryLogin() {

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
        FirebaseAuthService.manager.loginUser(email: email.lowercased(), password: password) { (result) in
            self.handleLoginResponse(with: result)
        }
    }

    //MARK: Firebase Authentication Methods
    private func handleLoginResponse(with result: Result<(), Error>) {
        switch result {
        case .failure(let error):
            print(error)
        self.showAlert(with: "Error", and: "Could not log in. Error: \(error)")
        
        case .success:
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                let sceneDelegate = windowScene.delegate as? SceneDelegate, let window = sceneDelegate.window
                else { return }
            print("login successful")
            UIView.transition(with: window, duration: 0.3, options: .transitionFlipFromBottom, animations: {
                           window.rootViewController = {
                                      let mainvc = MainScreenTabBarViewController()
                                      return mainvc
                                  }()
                              
                          }, completion: nil)
        }
    }

    @objc func showSignUp() {
        let signupVC = SignUpViewController()
        signupVC.modalPresentationStyle = .currentContext
        present(signupVC, animated: true, completion: nil)
    }



    //MARK: UI Setup

    private func setUpConstraints(){
        setupLoginStackView()
        setupEmailIcon()
        setupPasswordIcon()
        setUpLoginButton()
        setupCreateAccountButton()
        setupLogoLabel()
    }

    private func setupLogoLabel() {
        view.addSubview(logoLabel)

        logoLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([logoLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 60), logoLabel.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 16), logoLabel.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -16)])
    }
    private func setupLoginStackView() {
        let stackView = UIStackView(arrangedSubviews: [emailTextField, passwordTextField])
        stackView.axis = .vertical
        stackView.spacing = 15
        stackView.distribution = .fillEqually
        self.view.addSubview(stackView)

        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -400),
                                     stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
                                     stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
                                     stackView.heightAnchor.constraint(equalToConstant: 100)])
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

    private func setUpLoginButton(){
        view.addSubview(loginButton)
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 30), loginButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -25),
            loginButton.heightAnchor.constraint(equalToConstant: 70),
            loginButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 25)])
        view.layoutIfNeeded()

    }

    private func setupCreateAccountButton() {
        view.addSubview(createAccountButton)

        createAccountButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            createAccountButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            createAccountButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            createAccountButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            createAccountButton.heightAnchor.constraint(equalToConstant: 50)])
    }

}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}
