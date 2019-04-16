//
//  Screenshots.swift
//  Screenshots
//
//  Created by N-Pex on 15.04.19.
//  Copyright © 2019 Zom. All rights reserved.
//

import XCTest

class Screenshots: XCTestCase {

    override func setUp() {
        let app = XCUIApplication()
        setupSnapshot(app)
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        
        app.launch()
    }

    override func tearDown() {
    }

    func testWelcome() {
        // Take a snap of welcome screen and add/existing account screen
        snapshot("01Welcome")
        XCUIApplication().buttons[">>"].tap()
        snapshot("02CreateAccount")
    }
}
