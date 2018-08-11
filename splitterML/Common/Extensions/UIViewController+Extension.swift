//
//  UIViewController+Extension.swift
//  splitterML
//
//  Created by Wayne Rumble on 11/08/2018.
//  Copyright © 2018 Wayne Rumble. All rights reserved.
//

import UIKit

extension UIViewController {
    func setupHideKeyboardOnTap() {
        view.addGestureRecognizer(self.endEditingRecognizer())
        navigationController?.navigationBar.addGestureRecognizer(self.endEditingRecognizer())
    }
    
    private func endEditingRecognizer() -> UIGestureRecognizer {
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(self.view.endEditing(_:)))
        tap.cancelsTouchesInView = false
        return tap
    }
}
