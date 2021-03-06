//
//  WelcomeViewModel.swift
//  splitterML
//
//  Created by Wayne Rumble on 05/08/2018.
//  Copyright © 2018 Wayne Rumble. All rights reserved.
//

import Foundation
import Firebase

class WelcomeViewModel {
    
    typealias AuthFunction = (String, String, AuthDataResultCallback?) -> Void
    
    var showAlert: ((String, String) -> Void)?
    var resetEmailTextField: (() -> Void)?
    var textFieldsAreValid: (() -> (Bool))?
    var goToHomeViewController: (() -> Void)?
    var goToUpdateProfileViewController: (() -> Void)?
    
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
    
    func signInAndRetrieveData(credentials: AuthCredential) {
        Auth.auth().signInAndRetrieveData(with: credentials) { (userData , error) in
            self.checkAfterAuth(userData, error)
        }
    }
    
    func createFirebaseAccount(email: String, password: String) {
        checkAuth(authFunction: Auth.auth().createUser,
                  email: email,
                  password: password,
                  isNewSignUp: true)
    }
    
    func loginToFirebase(email: String, password: String) {
        checkAuth(authFunction: Auth.auth().signIn(withEmail:password:completion:),
                  email: email,
                  password: password)
    }
    
    private func checkAuth(authFunction: AuthFunction, email: String, password: String, isNewSignUp: Bool = false) {
        guard let textFieldsAreValid = textFieldsAreValid?() else { return }
        if textFieldsAreValid {
            authFunction(email, password) { [weak self] (userData, error) in
                guard let strongSelf = self else { return }
                strongSelf.checkAfterAuth(userData, error, isNewSignUp)
            }
        }
    }
    
    private func checkAfterAuth(_ userData: AuthDataResult?, _ error: Error?, _ isNewSignUp: Bool = false) {
        if let id = userData?.user.uid,
            let email = userData?.user.email, error == nil {
            let user = User(id: id, email: email)
            self.addNewUserToDatabase(user: user)
            isNewSignUp ? goToUpdateProfileViewController?() : goToHomeViewController?()
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
