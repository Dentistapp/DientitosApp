//
//  dientitosAppUITests.swift
//  dientitosAppUITests
//
//  Created by Itzel GoOm on 1/5/19.
//  Copyright © 2019 DentistaApp. All rights reserved.
//

import XCTest

class dientitosAppUITests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    


    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testAppLogginSucces() {
        let app = XCUIApplication()
        let emailTextField = app.textFields["emailTextField"]
        emailTextField.tap()
        emailTextField.typeText("a@a.com")
        
        let passwordTextField = app.secureTextFields["passwordTextField"]
        passwordTextField.tap()
        passwordTextField.typeText("123456")
        
        let loginbutton = app.buttons["singinbutton"]
        loginbutton.tap()
        XCTAssertTrue(app.isDisplayMusic)
    }

}

extension XCUIApplication{
    var isDisplayMusic: Bool{
        return otherElements["HomeView"].exists
    }
}
