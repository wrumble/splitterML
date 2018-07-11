//
//  Subviewable.swift
//  splitterML
//
//  Created by Wayne Rumble on 11/07/2018.
//  Copyright © 2018 Wayne Rumble. All rights reserved.
//

import Foundation

@objc protocol Subviewable {
    func setupSubviews()
    func setupHierarchy()
    func setupAutoLayout()
}

extension Subviewable {
    func setup() {
        setupSubviews()
        setupHierarchy()
        setupAutoLayout()
    }
}
