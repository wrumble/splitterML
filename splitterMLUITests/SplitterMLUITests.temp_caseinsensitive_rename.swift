//
//  SplitterMLUITests.swift
//  SplitterMLUITests
//
//  Created by Wayne Rumble on 11/07/2018.
//  Copyright © 2018 Wayne Rumble. All rights reserved.
//

import XCTest

class SplitterMLUITests: XCTestCase {
    
    private let app = XCUIApplication()
    
    override func setUp() {
        super.setUp()
        app.launch()
    }
    
    func testWelcomeViewControllerAppears() {
        let welcomeViewController = app.otherElements[String.AccessID.welcomeVC]

        XCTAssertTrue(welcomeViewController.exists)
    }
}
