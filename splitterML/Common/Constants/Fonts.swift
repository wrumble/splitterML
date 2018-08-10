//
//  Fonts.swift
//  splitterML
//
//  Created by Wayne Rumble on 10/08/2018.
//  Copyright © 2018 Wayne Rumble. All rights reserved.
//

import UIKit

enum Font: String {
    case printStyle = "SF Pro Display"
    case fancyStyle = "SignPainterHouseScript"
    
    func size(_ size: CGFloat) -> UIFont {
        return UIFont(name: self.rawValue, size: size)!
    }
}

extension CGFloat {
    static let navBarTitleSize: CGFloat = 100
    static let buttonTitleSize: CGFloat = 30
    static let textFieldPlaceHolderSize: CGFloat = 20
}
