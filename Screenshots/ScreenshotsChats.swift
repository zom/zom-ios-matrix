//
//  Screenshots.swift
//  Screenshots
//
//  Created by N-Pex on 15.04.19.
//  Copyright © 2019 Zom. All rights reserved.
//

import XCTest

class ScreenshotsChats: XCTestCase {
    
    override func setUp() {
        let app = XCUIApplication()
        // Send launch argument "--mock" to create mock data
        app.launchArguments.append("--mock")
        setupSnapshot(app)
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        
        app.launch()
    }
    
    override func tearDown() {
    }
    
    func testChats() {
        snapshot("03ChatList")

        // Open one of the chats
        //
        let app = XCUIApplication()
        app.tables.staticTexts["Bonjour"].tap()
        sleep(5)
        snapshot("04Chat")

        // Tap on "attach sticker"
        //
        app.buttons[""].tap()
        app.buttons[""].tap()

        // Swipe to the "Olo and Shimi" tab
        let collectionView = app.children(matching: .window).element(boundBy: 0).children(matching: .other).element(boundBy: 1).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .collectionView).element
        collectionView.swipeLeft()
        collectionView.swipeLeft()
        collectionView.swipeLeft()
        snapshot("05Stickers")
    }
}
