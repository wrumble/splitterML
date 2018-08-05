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

class WelcomeViewModel {
    
    typealias AuthFunction = (String, String, AuthDataResultCallback?) -> ()
    
    var showAlert: ((String, String) -> ())?
    var resetEmailTextField: (() -> ())?
    var textFieldsAreValid: (() -> (Bool))?
    var goToHomeViewController: (() -> ())?
    
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
    
    func loginWithFacebook(viewController: WelcomeViewController) {
        FBSDKLoginManager().logIn(withReadPermissions: ["public_profile", "email"],
                                  from: viewController) { [weak self] (_, error) in
            guard let strongSelf = self else { return }
            if let accessToken = FBSDKAccessToken.current(), error != nil {
                let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)
                
                Auth.auth().signInAndRetrieveData(with: credential) { (_, error) in
                    strongSelf.checkAfterAuth(error)
                }
            } else {
                guard let errorMessage = error?.localizedDescription else { return }
                strongSelf.showAlert?(String.Localized.Common.oops, errorMessage)
            }
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
            authFunction(email, password) { [weak self] (user, error) in
                guard let strongSelf = self else { return }
                strongSelf.checkAfterAuth(error)
            }
        }
    }
    
    private func checkAfterAuth(_ error: Error?) {
        if error == nil {
            goToHomeViewController?()
        } else {
            guard let errorMessage = error?.localizedDescription else { return }
            showAlert?(String.Localized.Common.error, errorMessage)
        }
    }
}
