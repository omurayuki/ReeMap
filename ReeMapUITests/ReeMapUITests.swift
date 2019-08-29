//
//  ReeMapUITests.swift
//  ReeMapUITests
//
//  Created by オムラユウキ on 2019/08/29.
//  Copyright © 2019 Swifter. All rights reserved.
//

import XCTest

class ReeMapUITests: XCTestCase {

    func testExample() {
        let app = XCUIApplication()
        setupSnapshot(app)
        app.launch()
        
//        let chipCountTextField = app.textFields["chip count"]
//        chipCountTextField.tap()
//        chipCountTextField.typeText("10")
//
//        let bigBlindTextField = app.textFields["big blind"]
//        bigBlindTextField.tap()
//        bigBlindTextField.typeText("100")
//        
//        snapshot("01UserEntries")
//
//        app.buttons["what should i do"].tap()
//        snapshot("02Suggestion")
    }
}
