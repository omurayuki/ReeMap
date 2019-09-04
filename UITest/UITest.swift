//
//  UITest.swift
//  UITest
//
//  Created by オムラユウキ on 2019/08/30.
//  Copyright © 2019 Swifter. All rights reserved.
//

import XCTest

class UITest: XCTestCase {

    override func setUp() {
        continueAfterFailure = false
        //        XCUIApplication().launch()
        let app = XCUIApplication()
        setupSnapshot(app)
        // snapshot("好きな名前") snapshotで撮影, ""が写真の名前になる
        app.launch()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

}
