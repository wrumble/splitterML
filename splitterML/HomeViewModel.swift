//
//  HomeViewModel.swift
//  splitterML
//
//  Created by Wayne Rumble on 05/08/2018.
//  Copyright © 2018 Wayne Rumble. All rights reserved.
//

import Foundation
import Firebase

class HomeViewModel {
 
    var popHomeViewController: (() -> ())?
    var showAlert: ((String, String) -> ())?
    
    func logOut() {
        if Auth.auth().currentUser != nil {
            do {
                try Auth.auth().signOut()
                popHomeViewController?()
            } catch let error as NSError {
                showAlert?(String.Localized.Common.oops, error.localizedDescription)
            }
        }
    }
}
