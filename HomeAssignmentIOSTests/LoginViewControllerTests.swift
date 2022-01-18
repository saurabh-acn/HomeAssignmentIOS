//
//  LoginViewControllerTests.swift
//  HomeAssignmentIOSTests
//
//  Created by saurabh.a.rana on 18/01/22.
//

import XCTest
@testable import HomeAssignmentIOS

class LoginViewControllerTests: XCTestCase {
    var loginVC: LoginViewController!
    var viewModel: LoginViewModel!
    
    override func setUpWithError() throws {
        loginVC = LoginViewController()
        loginVC.viewDidLoad()
        loginVC.viewWillAppear(true)
        viewModel = LoginViewModel()
    }
    
    func testValidateTextInputs() {
        let userTextInput = TextInput(frame: .zero)
        userTextInput.loadSubview()
        userTextInput.textField?.text = "Test"
        userTextInput.placeHolderLabel?.text = "Username"
        XCTAssertNotNil(viewModel.validateTextInputs(textInput: userTextInput,
                                                     validationString: .passwordRequired))
        userTextInput.textField?.text = ""
        XCTAssertNotNil(viewModel.validateTextInputs(textInput: userTextInput,
                                                     validationString: .passwordRequired))
    }

    override func tearDownWithError() throws {
        loginVC = nil
    }
}
