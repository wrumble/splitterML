//
//  String+Extension.swift
//  splitterML
//
//  Created by Wayne Rumble on 05/08/2018.
//  Copyright © 2018 Wayne Rumble. All rights reserved.
//

import UIKit

extension String {
    func isValidEmail() -> Bool {
        //`try!` will always succeed because the pattern is valid
        let regex = try! NSRegularExpression(pattern: Regex.email, options: .caseInsensitive)
        return regex.firstMatch(in: self,
                                options: [],
                                range: NSRange(location: 0,
                                               length: count)) != nil
    }
    
    func isValidPassword() -> Bool {
        let regex = try! NSRegularExpression(pattern: Regex.password, options: .caseInsensitive)
        return regex.firstMatch(in: self,
                                options: [],
                                range: NSRange(location: 0,
                                               length: count)) != nil
    }
}
