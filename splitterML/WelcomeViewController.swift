//
//  ViewController.swift
//  splitterML
//
//  Created by Wayne Rumble on 11/07/2018.
//  Copyright © 2018 Wayne Rumble. All rights reserved.
//

import UIKit
import Firebase

class WelcomeViewController: UIViewController {
    
    private let emailTextField = UITextField()
    private let passwordTextField = UITextField()
    private let loginButton = UIButton()
    private let signUpButton = UIButton()
    private let resetPasswordButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    @objc func createAccount(_ sender: AnyObject) {
        if emailTextField.text == "" {
            let alertController = UIAlertController(title: "Error",
                                                    message: "Please enter your email and password",
                                                    preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK",
                                              style: .cancel,
                                              handler: nil)
            alertController.addAction(defaultAction)
            
            present(alertController, animated: true, completion: nil)
        } else {
            Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
                
                if error == nil {
                    self.navigationController?.pushViewController(HomeViewController(), animated: true)
                } else {
                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
    
    @objc func login(_ sender: AnyObject) {
        
        if self.emailTextField.text == "" || self.passwordTextField.text == "" {
            
            let alertController = UIAlertController(title: "Error", message: "Please enter an email and password.", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            self.present(alertController, animated: true, completion: nil)
            
        } else {
            
            Auth.auth().signIn(withEmail: self.emailTextField.text!, password: self.passwordTextField.text!) { (user, error) in
                
                if error == nil {
                    self.navigationController?.pushViewController(HomeViewController(), animated: true)
                } else {
                    
                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
    
    @objc func resetPassword(_ sender: AnyObject) {
        
        if self.emailTextField.text == "" {
            let alertController = UIAlertController(title: "Oops!", message: "Please enter an email.", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            present(alertController, animated: true, completion: nil)
            
        } else {
            Auth.auth().sendPasswordReset(withEmail: self.emailTextField.text!, completion: { (error) in
                
                var title = ""
                var message = ""
                
                if error != nil {
                    title = "Error!"
                    message = (error?.localizedDescription)!
                } else {
                    title = "Success!"
                    message = "Password reset email sent."
                    self.emailTextField.text = ""
                }
                
                let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
                
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                
                self.present(alertController, animated: true, completion: nil)
            })
        }
    }
}

extension WelcomeViewController: Subviewable {
    
    func setupSubviews() {
        navigationItem.setHidesBackButton(true, animated: true)
        
        view.backgroundColor = .white
        view.accessibilityIdentifier = "WelcomeViewController"
        
        emailTextField.placeholder = "E-mail"
        
        passwordTextField.placeholder = "Password"
        
        loginButton.addTarget(self, action: #selector(login), for: .touchUpInside)
        loginButton.setTitle("Login", for: .normal)
        loginButton.backgroundColor = .black
        
        signUpButton.addTarget(self, action: #selector(createAccount), for: .touchUpInside)
        signUpButton.setTitle("Sign Up", for: .normal)
        signUpButton.setTitleColor(.black, for: .normal)
        signUpButton.backgroundColor = .white
        
        resetPasswordButton.addTarget(self, action: #selector(resetPassword), for: .touchUpInside)
        resetPasswordButton.setTitle("Reset Password", for: .normal)
        resetPasswordButton.setTitleColor(.black, for: .normal)
        resetPasswordButton.backgroundColor = .white
    }
    
    func setupHierarchy() {
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(loginButton)
        view.addSubview(signUpButton)
        view.addSubview(resetPasswordButton)
    }
    
    func setupAutoLayout() {
        emailTextField.topAnchor.constraint(equalTo: topLayoutGuide.topAnchor, constant: Layout.spacer).isActive = true

        if #available(iOS 11.0, *) {
            emailTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Layout.spacer).isActive = true
        }
        
        emailTextField.pinLeft(to: view, anchor: .left, constant: Layout.spacer)
        emailTextField.pinRight(to: view, anchor: .right, constant: -Layout.spacer)
        emailTextField.addHeightConstraint(with: 44)
        
        passwordTextField.pinTop(to: emailTextField, anchor: .bottom, constant: Layout.spacer)
        passwordTextField.pinLeft(to: view, anchor: .left, constant: Layout.spacer)
        passwordTextField.pinRight(to: view, anchor: .right, constant: -Layout.spacer)
        passwordTextField.addHeightConstraint(with: 44)
        
        loginButton.pinTop(to: passwordTextField, anchor: .bottom, constant: Layout.spacer)
        loginButton.pinLeft(to: view, anchor: .left, constant: Layout.spacer)
        loginButton.pinRight(to: view, anchor: .right, constant: -Layout.spacer)
        loginButton.addHeightConstraint(with: 44)
        
        signUpButton.pinBottom(to: resetPasswordButton, anchor: .top, constant: -Layout.spacer)
        signUpButton.pinLeft(to: view, anchor: .left, constant: Layout.spacer)
        signUpButton.pinRight(to: view, anchor: .right, constant: -Layout.spacer)
        signUpButton.addHeightConstraint(with: 44)
        
        resetPasswordButton.pinBottom(to: view, anchor: .bottom, constant: -Layout.spacer)
        resetPasswordButton.pinLeft(to: view, anchor: .left, constant: Layout.spacer)
        resetPasswordButton.pinRight(to: view, anchor: .right, constant: -Layout.spacer)
        resetPasswordButton.addHeightConstraint(with: 44)
    }
}
