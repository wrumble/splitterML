//
//  ViewController.swift
//  splitterML
//
//  Created by Wayne Rumble on 11/07/2018.
//  Copyright © 2018 Wayne Rumble. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
}

extension WelcomeViewController: Subviewable {
    
    func setupSubviews() {
        view.accessibilityIdentifier = "WelcomeViewController"
        
    }
    
    func setupHierarchy() {
        
    }
    
    func setupAutoLayout() {
        
    }
}

