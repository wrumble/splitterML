//
//  String+Localized+Extension.swift
//  splitterML
//
//  Created by Wayne Rumble on 05/08/2018.
//  Copyright © 2018 Wayne Rumble. All rights reserved.
//

import Foundation
import UIKit

extension String {
    var localized: String {
        return Bundle.main.localizedString(forKey: self, value: "", table: nil)
    }
    
    enum Localized {
        enum Common {
            static let cancel = "cancel".localized
            static let ok = "ok".localized
            static let error = "error".localized
            static let success = "success".localized
            static let oops = "oops".localized
        }
        
        enum WelcomeVC {
            static let email = "email".localized
            static let password = "password".localized
            static let enterEmail = "enterEmail".localized
            static let enterEmailAndPassword = "enterEmailAndPassword".localized
            static let login = "login".localized
            static let signUp = "signUp".localized
            static let loginWithFB = "loginWithFB".localized
            static let resetPassword = "resetPassword".localized
            static let passwordResetEmail = "passwordResetEmail".localized
            static let invalidEmail = "invalidEmail".localized
            static let inavalidPassword = "inavalidPassword".localized
        }
        
        enum HomeVC {
            static let logout = "Logout".localized
        }
    }
}
