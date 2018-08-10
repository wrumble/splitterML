//
//  AlertView.swift
//  splitterML
//
//  Created by Wayne Rumble on 05/08/2018.
//  Copyright © 2018 Wayne Rumble. All rights reserved.
//

import Foundation
import UIKit

class AlertViewFactory {
    
    static func createAlertView(title: String?,
                                message: String?,
                                preferredStyle: UIAlertControllerStyle = .alert) -> UIAlertController {
        let alertView = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        
        alertView.addAction(.okAction)
        
        return alertView
    }
    
    static func createAlertView(title: String?,
                                message: String?,
                                actions: [UIAlertAction],
                                preferredStyle: UIAlertControllerStyle = .alert) -> UIAlertController {
        let alertView = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        
        actions.forEach { alertView.addAction($0) }
        
        return alertView
    }
}

extension UIAlertAction {
    static var cancelAction: UIAlertAction {
        return UIAlertAction(title: String.Localized.Common.cancel, style: .cancel)
    }
    
    static var okAction: UIAlertAction {
        return UIAlertAction(title: String.Localized.Common.ok, style: .cancel)
    }
}
