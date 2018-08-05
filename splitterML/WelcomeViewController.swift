//
//  ViewController.swift
//  splitterML
//
//  Created by Wayne Rumble on 11/07/2018.
//  Copyright © 2018 Wayne Rumble. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit

class WelcomeViewController: UIViewController {
    
    typealias AuthFunction = (String, String, AuthDataResultCallback?) -> ()
    
    private let emailTextField = UITextField()
    private let passwordTextField = UITextField()
    private let loginButton = UIButton()
    private let facebookLoginButton = FBSDKLoginButton()
    private let signUpButton = UIButton()
    private let resetPasswordButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func showAlert(title: String,
                           message: String,
                           buttonTitle: String? = String.Localized.Common.ok) {
        let alertView = AlertViewFactory.createAlertView(title: title,
                                                         message: message,
                                                         buttonTitle: buttonTitle)
        
        present(alertView, animated: true, completion: nil)
    }
    
    private func checkAfterAuth(_ error: Error?) {
        if error == nil {
            navigationController?.pushViewController(HomeViewController(), animated: true)
        } else {
            guard let errorMessage = error?.localizedDescription else { return }
            showAlert(title: String.Localized.Common.error,
                                 message: errorMessage)
        }
    }
    
    private func textFieldsAreValid() -> Bool {
        if (emailTextField.text?.isEmpty)! || (passwordTextField.text?.isEmpty)! {
            showAlert(title: String.Localized.Common.error,
                      message: String.Localized.WelcomeVC.enterEmailAndPassword)
            return false
        } else if !emailTextFieldValid() {
            return false
        } else if let text = passwordTextField.text, !text.isValidPassword() {
            showAlert(title: String.Localized.Common.error,
                      message: String.Localized.WelcomeVC.inavalidPassword)
            return false
        }
        return true
    }
    
    private func emailTextFieldValid() -> Bool {
        if let text = emailTextField.text, !text.isValidEmail() {
            showAlert(title: String.Localized.Common.error,
                      message: String.Localized.WelcomeVC.invalidEmail)
            return false
        }
        return true
    }
    
    private func checkAuth(authFunc: AuthFunction) {
         if textFieldsAreValid() {
            guard let email = emailTextField.text,
                    let password = passwordTextField.text else { return }
            authFunc(email, password) { [weak self] (user, error) in
                guard let strongSelf = self else { return }
                strongSelf.checkAfterAuth(error)
            }
        }
    }

    @objc func createAccount() {
        checkAuth(authFunc: Auth.auth().createUser)
    }
    
    @objc func login() {
        checkAuth(authFunc: Auth.auth().signIn(withEmail:password:completion:))
    }
    
    @objc func facebookLogin() {
        FBSDKLoginManager().logIn(withReadPermissions: ["public_profile", "email"],
                                  from: self) { [weak self] (_, error) in
            guard let strongSelf = self else { return }
            if let accessToken = FBSDKAccessToken.current(), error != nil {
                let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)
                
                Auth.auth().signInAndRetrieveData(with: credential) { (_, error) in
                    strongSelf.checkAfterAuth(error)
                }
            } else {
                guard let errorMessage = error?.localizedDescription else { return }
                strongSelf.showAlert(title: String.Localized.Common.oops,
                                     message: errorMessage)
            }
        }
    }
    
    @objc func resetPassword() {
        
        if emailTextFieldValid() {
            Auth.auth().sendPasswordReset(withEmail: self.emailTextField.text!, completion: { [weak self] (error) in
                guard let strongSelf = self else { return }
                var title = ""
                var message = ""
                
                if error != nil {
                    guard let errorMessage = error?.localizedDescription else { return }
                    title = String.Localized.Common.error
                    message = errorMessage
                } else {
                    title = String.Localized.Common.success
                    message = String.Localized.WelcomeVC.passwordResetEmail
                    strongSelf.emailTextField.text = ""
                }
                
                strongSelf.showAlert(title: title, message: message)
            })
        }
    }
}

extension WelcomeViewController: Subviewable {
    
    func setupSubviews() {
        navigationItem.setHidesBackButton(true, animated: true)
        
        view.backgroundColor = .white
        view.accessibilityIdentifier = String.AccessID.welcomeVC

        emailTextField.placeholder = String.Localized.WelcomeVC.email
        
        passwordTextField.placeholder = String.Localized.WelcomeVC.password
        passwordTextField.isSecureTextEntry = true
        
        loginButton.addTarget(self, action: #selector(login), for: .touchUpInside)
        loginButton.setTitle(String.Localized.WelcomeVC.login, for: .normal)
        loginButton.backgroundColor = .black
        
        facebookLoginButton.addTarget(self, action: #selector(facebookLogin), for: .touchUpInside)
        facebookLoginButton.setTitle(String.Localized.WelcomeVC.loginWithFB, for: .normal)
        
        signUpButton.addTarget(self, action: #selector(createAccount), for: .touchUpInside)
        signUpButton.setTitle(String.Localized.WelcomeVC.signUp, for: .normal)
        signUpButton.setTitleColor(.black, for: .normal)
        signUpButton.backgroundColor = .white
        
        resetPasswordButton.addTarget(self, action: #selector(resetPassword), for: .touchUpInside)
        resetPasswordButton.setTitle(String.Localized.WelcomeVC.resetPassword, for: .normal)
        resetPasswordButton.setTitleColor(.black, for: .normal)
        resetPasswordButton.backgroundColor = .white
    }
    
    func setupHierarchy() {
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(loginButton)
        view.addSubview(facebookLoginButton)
        view.addSubview(signUpButton)
        view.addSubview(resetPasswordButton)
    }
    
    func setupAutoLayout() {
        emailTextField.topAnchor.constraint(equalTo: topLayoutGuide.topAnchor,
                                            constant: Layout.spacer).isActive = true

        if #available(iOS 11.0, *) {
            emailTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,
                                                constant: Layout.spacer).isActive = true
        }
        
        emailTextField.pinLeft(to: view, anchor: .left, constant: Layout.spacer)
        emailTextField.pinRight(to: view, anchor: .right, constant: -Layout.spacer)
        emailTextField.addHeightConstraint(with: Layout.textFieldHeight)
        
        passwordTextField.pinTop(to: emailTextField, anchor: .bottom, constant: Layout.spacer)
        passwordTextField.pinLeft(to: view, anchor: .left, constant: Layout.spacer)
        passwordTextField.pinRight(to: view, anchor: .right, constant: -Layout.spacer)
        passwordTextField.addHeightConstraint(with: Layout.textFieldHeight)
        
        loginButton.pinTop(to: passwordTextField, anchor: .bottom, constant: Layout.spacer)
        loginButton.pinLeft(to: view, anchor: .left, constant: Layout.spacer)
        loginButton.pinRight(to: view, anchor: .right, constant: -Layout.spacer)
        loginButton.addHeightConstraint(with: Layout.buttonHeight)
        
        facebookLoginButton.pinTop(to: loginButton, anchor: .bottom, constant: Layout.spacer)
        facebookLoginButton.pinLeft(to: view, anchor: .left, constant: Layout.spacer)
        facebookLoginButton.pinRight(to: view, anchor: .right, constant: -Layout.spacer)
        facebookLoginButton.addHeightConstraint(with: Layout.buttonHeight)
        
        signUpButton.pinBottom(to: resetPasswordButton, anchor: .top, constant: -Layout.spacer)
        signUpButton.pinLeft(to: view, anchor: .left, constant: Layout.spacer)
        signUpButton.pinRight(to: view, anchor: .right, constant: -Layout.spacer)
        signUpButton.addHeightConstraint(with: Layout.buttonHeight)
        
        resetPasswordButton.pinBottom(to: view, anchor: .bottom, constant: -Layout.spacer)
        resetPasswordButton.pinLeft(to: view, anchor: .left, constant: Layout.spacer)
        resetPasswordButton.pinRight(to: view, anchor: .right, constant: -Layout.spacer)
        resetPasswordButton.addHeightConstraint(with: Layout.buttonHeight)
    }
}
