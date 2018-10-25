//
//  UIStackView+Extension.swift
//  splitterML
//
//  Created by Wayne Rumble on 11/08/2018.
//  Copyright © 2018 Wayne Rumble. All rights reserved.
//

import UIKit

extension UIStackView {
    
    func addBackgroundColor(_ color: UIColor) {
        let subView = UIView(frame: bounds)
        subView.backgroundColor = color
        subView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        insertSubview(subView, at: 0)
    }
}
