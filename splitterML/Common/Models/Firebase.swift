//
//  Firebase.swift
//  splitterML
//
//  Created by Wayne Rumble on 11/08/2018.
//  Copyright © 2018 Wayne Rumble. All rights reserved.
//

import Foundation
import FirebaseDatabase

class FirebaseHelper {
    private let databaseReference = Database.database().reference()
    
    func addNewUserToDatabase(user: User, completion: @escaping (_ error: Error?) -> Void) {
        databaseReference.child("users").child(user.id).setValue(["email": user.email]) { (error, _) in
            completion(error)
        }
    }
    
    func getUserData(id: String, completion: @escaping (_ user: User?) -> Void) {
        let userReference = databaseReference.child("users").child(id)
        userReference.observeSingleEvent(of: .value, with: { snapshot in
            if snapshot.exists() {
                guard let email = snapshot.childSnapshot(forPath: "email").value as? String else { return }
                let user = User(id: id, email: email)
                completion(user)
            }
        })
    }
}
