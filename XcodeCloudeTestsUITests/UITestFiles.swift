//
//  UITestFiles.swift
//  XcodeCloudeTestsUITests
//
//  Created by Jan Slusarz on 26/10/2021.
//

import XCTest

let app = XCUIApplication()

let maxTimeout = 20.0
let regularTimeout = 10.0
let minTimeout = 5.0
let notExpectedEnding = " is NOT expected"
let notFoundEnding = " NOT found"
let notAbsentEnding = "NOT absent"

let labelNotFound = " label" + notFoundEnding
let labelNotAbsent = " label" + notAbsentEnding
let textFieldNotFound = "text field " + notFoundEnding

func labelNotFound(label: String) -> String {
  label + notFoundEnding
}

let createAccountActionAccess = " access to the create account action " + notExpectedEnding

class AssertMagicTool {

  class func labelExist(label: String) {
    XCTAssertTrue(app.staticTexts[label].waitForExistence(timeout: minTimeout), labelNotFound(label: label) )
  }

  class func labelAbsent(label: String) {
    XCTAssertFalse(app.staticTexts[label].waitForExistence(timeout: minTimeout), "")
  }

  class func clear(textField: XCUIElement) {
    textField.tap()
    textField.press(forDuration: 1.0)

    if app.menuItems["Select All"].waitForExistence(timeout: 0.5) {
      app.menuItems["Select All"].tap()
    }

    app.keys["delete"].tap()
  }
}

class CreateAccountUITests: XCTestCase {

  override class func setUp() {
    //app.launchArguments = ["-clearLocalStorage", "asdasdasd"]
    app.launch()

  }

  override func setUpWithError() throws {
    continueAfterFailure = false

    CreateAccount.resetForm()
  }

  override func tearDownWithError() throws {
  }

  func testCreateAccountWithEmptyForm() throws {
    CreateAccount.enter(login: "aaa")

    CreateAccountAssert.loginValidatorMessage(enabled: true)
    CreateAccountAssert.passwordValidatorMessage(enabled: false)
    CreateAccountAssert.createAccountAction(enabled: false)
  }

  func testCreateAccountWithInvalidLogin() throws {
    CreateAccount.enter(login: "aaa")

    CreateAccountAssert.loginValidatorMessage(enabled: true)
    CreateAccountAssert.passwordValidatorMessage(enabled: false)
    CreateAccountAssert.createAccountAction(enabled: false)
  }

  func testCreateAccountWithInvalidPassword() throws {
    CreateAccount.enter(password: "sfd")

    CreateAccountAssert.loginValidatorMessage(enabled: false)
    CreateAccountAssert.passwordValidatorMessage(enabled: true)
    CreateAccountAssert.createAccountAction(enabled: false)
  }

  func testCreateAccountWithInvalidAllData() throws {
    XCTContext.runActivity(named: "Enter invalid login") { _ in
      CreateAccount.enter(login: "aaaa")
    }

    XCTContext.runActivity(named: "Enter invalid password") { _ in
      CreateAccount.enter(password: "A")
    }

    XCTContext.runActivity(named: "Enter invalid confirm") { _ in
      CreateAccount.enter(confirm: "Aa!1a")
    }



    CreateAccountAssert.loginValidatorMessage(enabled: true)
    CreateAccountAssert.passwordValidatorMessage(enabled: true)
    CreateAccountAssert.createAccountAction(enabled: false)
  }

  func testCreateAccountWithNoConfirm() throws {
    CreateAccount.enter(login: "aaaaaaaa")
    CreateAccount.enter(password: "Aa!1aaaa")

    CreateAccountAssert.loginValidatorMessage(enabled: false)
    CreateAccountAssert.passwordValidatorMessage(enabled: true)
    CreateAccountAssert.createAccountAction(enabled: false)
  }

  func testCreateAccountWithCorrectData() throws {
    CreateAccount.enter(login: "asdfghjk")
    CreateAccount.enter(password: "Aa!1aaaa")
    CreateAccount.enter(confirm: "Aa!1aaaa")

    CreateAccountAssert.loginValidatorMessage(enabled: false)
    CreateAccountAssert.passwordValidatorMessage(enabled: false)
    CreateAccountAssert.createAccountAction(enabled: true)
  }



  func testExample() throws {
  }
}

class CreateAccount {

  class func createAccount(login: String, password: String, confirm: String) {
    enter(login: login)
    enter(password: password)
    enter(confirm: password)

    let button = app.buttons[UserInterface.CreateAccount.createAccountButton]
    button.tap()
  }

  class func enter(login: String) {
    let field = app.textFields[UserInterface.CreateAccount.loginTextField]
    if login.count > 0 {
      field.tap()
      field.typeText(login)
    } else {
      AssertMagicTool.clear(textField: field)
    }
  }

  class func enter(password: String) {
    let field = app.secureTextFields[UserInterface.CreateAccount.passwordTextField]
    if password.count > 0 {
      field.tap()

      field.typeText(password)
    } else {
      AssertMagicTool.clear(textField: field)
    }
  }

  class func enter(confirm: String) {
    let field = app.secureTextFields[UserInterface.CreateAccount.confirmTextFiled]
    if confirm.count > 0 {
      field.tap()
      field.typeText(confirm)
    } else {
      AssertMagicTool.clear(textField: field)
    }
  }

  class func resetForm() {
    enter(login: "")
    enter(password: "")
    enter(confirm: "")
  }
}

class CreateAccountAssert {

  class func loginValidatorMessage(enabled: Bool) {
    let label = app.staticTexts[UserInterface.CreateAccount.loginValidatorMessage]
      .waitForExistence(timeout: minTimeout)

    XCTAssertEqual(label, enabled, "loginValidatorMessage")
  }

  class func passwordValidatorMessage(enabled: Bool) {
    let label = app.staticTexts[UserInterface.CreateAccount.passwordValidatorMessage]
      .waitForExistence(timeout: minTimeout)

    XCTAssertEqual(label, enabled, "passwordValidatorMessage")
  }

  class func createAccountAction(enabled: Bool) {
    let button = app.buttons[UserInterface.CreateAccount.createAccountButton]

    XCTAssertEqual(button.isEnabled, enabled, createAccountActionAccess)
  }
}
