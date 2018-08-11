//
//  WelcomeViewModel.swift
//  splitterML
//
//  Created by Wayne Rumble on 05/08/2018.
//  Copyright © 2018 Wayne Rumble. All rights reserved.
//

import Foundation
import Firebase
import FBSDKLoginKit
import GoogleSignIn

class WelcomeViewModel {
    
    typealias AuthFunction = (String, String, AuthDataResultCallback?) -> Void
    
    var showAlert: ((String, String) -> Void)?
    var resetEmailTextField: (() -> Void)?
    var textFieldsAreValid: (() -> (Bool))?
    var goToHomeViewController: (() -> Void)?
    
    func resetPassword(email: String) {
        Auth.auth().sendPasswordReset(withEmail: email, completion: { [weak self] (error) in
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
                strongSelf.resetEmailTextField?()
            }
            
            strongSelf.showAlert?(title, message)
        })
    }
    
    func loginWithFacebook() {
        if let accessToken = FBSDKAccessToken.current() {
            let credentials = FacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)
            signInAndRetrieveData(credentials: credentials)
        }
    }
    
    func signInWithGoogle(user: GIDGoogleUser) {
        guard let authentication = user.authentication else { return }
        let credentials = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        signInAndRetrieveData(credentials: credentials)
    }
    
    func signInAndRetrieveData(credentials: AuthCredential) {
        Auth.auth().signInAndRetrieveData(with: credentials) { (userData , error) in
            self.checkAfterAuth(userData: userData, error: error)
        }
    }
    
    func createFirebaseAccount(email: String, password: String) {
        checkAuth(authFunction: Auth.auth().createUser,
                  email: email,
                  password: password)
    }
    
    func loginToFirebase(email: String, password: String) {
        checkAuth(authFunction: Auth.auth().signIn(withEmail:password:completion:),
                  email: email,
                  password: password)
    }
    
    private func checkAuth(authFunction: AuthFunction, email: String, password: String) {
        guard let textFieldsAreValid = textFieldsAreValid?() else { return }
        if textFieldsAreValid {
            authFunction(email, password) { [weak self] (userData, error) in
                guard let strongSelf = self else { return }
                strongSelf.checkAfterAuth(userData: userData, error: error)
            }
        }
    }
    
    private func checkAfterAuth(userData: AuthDataResult?, error: Error?) {
        if error == nil && userData != nil {
            guard let id = userData?.user.uid,
                    let email = userData?.user.email else { return }
            let user = User(id: id, email: email)
            self.addNewUserToDatabase(user: user)
        } else {
            guard let errorMessage = error?.localizedDescription else { return }
            showAlert?(String.Localized.Common.error, errorMessage)
        }
    }
    
    private func addNewUserToDatabase(user: User) {
        FirebaseHelper().addNewUserToDatabase(user: user, completion: { error in
            if error == nil {
                self.goToHomeViewController?()
            } else {
                guard let errorMessage = error?.localizedDescription else { return }
                self.showAlert?(String.Localized.Common.error, errorMessage)
            }
        })
    }
}
