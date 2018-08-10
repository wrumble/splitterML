//
//  ViewController.swift
//  splitterML
//
//  Created by Wayne Rumble on 11/07/2018.
//  Copyright © 2018 Wayne Rumble. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import GoogleSignIn

class WelcomeViewController: UIViewController, FBSDKLoginButtonDelegate, GIDSignInUIDelegate {

    private let emailTextField = UITextField()
    private let passwordTextField = UITextField()
    private let loginButton = UIButton()
    private let facebookLoginButton = FBSDKLoginButton()
    private let googleLoginButton = GIDSignInButton()
    private let signUpButton = UIButton()
    private let resetPasswordButton = UIButton()

    private let viewModel: WelcomeViewModel
    
    required init(viewModel: WelcomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
        bindViewModel()
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bindViewModel() {
        viewModel.resetEmailTextField = resetEmailTextField
        viewModel.showAlert = showAlert
        viewModel.textFieldsAreValid = textFieldsAreValid
        viewModel.goToHomeViewController = goToHomeViewController
    }
    
    private func resetEmailTextField() {
        emailTextField.text = ""
    }
    
    private func showAlert(title: String, message: String) {
        let alertView = AlertViewFactory.createAlertView(title: title, message: message)
        present(alertView, animated: true, completion: nil)
    }
    
    private func textFieldsAreValid() -> Bool {
        if textFieldsAreNotEmpty() && emailTextFieldValid() && passwordTextFieldValid() {
            return true
        }
        return false
    }
    
    private func goToHomeViewController() {
        let homeViewModel = HomeViewModel()
        let homeViewController = HomeViewController(viewModel: homeViewModel)
        navigationController?.pushViewController(homeViewController, animated: true)
    }
    
    private func textFieldsAreNotEmpty() -> Bool {
        if (emailTextField.text?.isEmpty)! || (passwordTextField.text?.isEmpty)! {
            showAlert(title: String.Localized.Common.error,
                      message: String.Localized.WelcomeVC.enterEmailAndPassword)
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
    
    private func passwordTextFieldValid() -> Bool {
        if let text = passwordTextField.text, !text.isValidPassword() {
            showAlert(title: String.Localized.Common.error,
                      message: String.Localized.WelcomeVC.inavalidPassword)
            return false
        }
        return true
    }

    @objc private func createFirebaseAccount() {
        guard let email = emailTextField.text,
            let password = passwordTextField.text else { return }
        viewModel.createFirebaseAccount(email: email, password: password)
    }
    
    @objc private func login() {
        guard let email = emailTextField.text,
            let password = passwordTextField.text else { return }
        viewModel.loginToFirebase(email: email, password: password)
    }
    
    private func loginWithFacebook() {
        viewModel.loginWithFacebook()
    }
    
    @objc private func resetPassword() {
        if emailTextFieldValid() {
            guard let email = emailTextField.text else { return }
            viewModel.resetPassword(email: email)
        }
    }
}

extension WelcomeViewController: Subviewable {
    
    func setupSubviews() {
        title = String.Localized.Common.splitter
        
        navigationItem.setHidesBackButton(true, animated: true)

        view.backgroundColor = .white
        view.accessibilityIdentifier = String.AccessID.welcomeVC
        
        GIDSignIn.sharedInstance().uiDelegate = self

        emailTextField.placeholder = String.Localized.WelcomeVC.email
        
        passwordTextField.placeholder = String.Localized.WelcomeVC.password
        passwordTextField.isSecureTextEntry = true
        
        loginButton.addTarget(self, action: #selector(login), for: .touchUpInside)
        loginButton.setTitle(String.Localized.WelcomeVC.login, for: .normal)
        loginButton.titleLabel?.font = Font.printStyle.size(.buttonTitleSize)
        loginButton.backgroundColor = .black
        
        facebookLoginButton.setTitle(String.Localized.WelcomeVC.loginWithFB, for: .normal)
        facebookLoginButton.readPermissions = ["public_profile", "email"]
        facebookLoginButton.delegate = self
        
        signUpButton.addTarget(self, action: #selector(createFirebaseAccount), for: .touchUpInside)
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
        view.addSubview(googleLoginButton)
        view.addSubview(signUpButton)
        view.addSubview(resetPasswordButton)
    }
    
    func setupAutoLayout() {
        emailTextField.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor,
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
        
        googleLoginButton.pinTop(to: facebookLoginButton, anchor: .bottom, constant: Layout.spacer)
        googleLoginButton.pinLeft(to: view, anchor: .left, constant: Layout.spacer)
        googleLoginButton.pinRight(to: view, anchor: .right, constant: -Layout.spacer)
        googleLoginButton.addHeightConstraint(with: Layout.buttonHeight)
        
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

extension WelcomeViewController {
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) { }
    
    func loginButton(_ loginButton: FBSDKLoginButton!,
                     didCompleteWith result: FBSDKLoginManagerLoginResult!,
                     error: Error!) {
        switch result {
        case .none: showAlert(title: String.Localized.Common.oops, message: error.localizedDescription)
        case .some: loginWithFacebook()
        }
    }
}

extension WelcomeViewController {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        GIDSignIn.sharedInstance().signIn()
        if error != nil {
            viewModel.signInWithGoogle(user: user)
        } else {
            guard let error = error?.localizedDescription else { return }
            showAlert(title: String.Localized.Common.oops, message: error)
        }
    }
}
