//
//  RegisterViewControllerTests.swift
//  HomeAssignmentIOSTests
//
//  Created by saurabh.a.rana on 18/01/22.
//

import XCTest
@testable import HomeAssignmentIOS

class RegisterViewControllerTests: XCTestCase {
    var registerVC: RegisterViewController!
    var viewModel: RegisterViewModel!
    
    override func setUpWithError() throws {
        registerVC = RegisterViewController()
        registerVC.viewDidLoad()
        registerVC.viewWillAppear(true)
        viewModel = RegisterViewModel()
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
    
    func testValidatePaswordTextInputs() {
        let passwordTextInput = TextInput(frame: .zero)
        passwordTextInput.loadSubview()
        passwordTextInput.placeHolderLabel?.text = "Password"
        passwordTextInput.textField?.text = "1233456789"
        XCTAssertNotNil(viewModel.validatePasswordTextInput(textInput: passwordTextInput,
                                            validationString: .passwordStrength) { status in
                XCTAssertFalse(!status)
        })
        
        passwordTextInput.textField?.text = "12345678MM"
        XCTAssertNotNil(viewModel.validatePasswordTextInput(textInput: passwordTextInput,
                                            validationString: .passwordStrength) { status in
                XCTAssertFalse(!status)
        })
        
        passwordTextInput.textField?.text = "12345678M$"
        XCTAssertNotNil(viewModel.validatePasswordTextInput(textInput: passwordTextInput,
                                            validationString: .passwordStrength) { status in
                XCTAssertTrue(!status)
        })
    }
    
    func testValidateConfirmPaswordTextInputs() {
        let passwordTextInput = TextInput(frame: .zero)
        passwordTextInput.loadSubview()
        passwordTextInput.placeHolderLabel?.text = "Password"
        passwordTextInput.textField?.text = "1233456789"
        
        let confirmPasswordTextInput = TextInput(frame: .zero)
        confirmPasswordTextInput.loadSubview()
        confirmPasswordTextInput.placeHolderLabel?.text = "Confirm Password"
        confirmPasswordTextInput.textField?.text = "1233456789"
        
        XCTAssertNotNil(viewModel.validateConfirmPassword(password: passwordTextInput,
                                                          confirmPasword: confirmPasswordTextInput,
                                                          validationString: .confirmPasswordError))
        
    }
    
    override func tearDownWithError() throws {
        registerVC = nil
    }
}
