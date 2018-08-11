//
//  HomeViewModel.swift
//  splitterML
//
//  Created by Wayne Rumble on 05/08/2018.
//  Copyright © 2018 Wayne Rumble. All rights reserved.
//

import Foundation
import Firebase
import GoogleSignIn
import FBSDKLoginKit

class HomeViewModel {
 
    var popHomeViewController: (() -> Void)?
    var showAlert: ((String, String) -> Void)?
    var setNavBarTitle: ((String) -> Void)?
    
    init() {
        getUserData()
    }
    
    private func getUserData() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        FirebaseHelper().getUserData(id: userId, completion: { user in
            guard let user = user else { return }
            self.setNavBarTitle?(user.email)
        })
    }
    
    func logOut() {
        if Auth.auth().currentUser != nil {
            do {
                try Auth.auth().signOut()
                popHomeViewController?()
                GIDSignIn.sharedInstance().signOut()
            } catch let error as NSError {
                showAlert?(String.Localized.Common.oops, error.localizedDescription)
            }
        }
    }
}
