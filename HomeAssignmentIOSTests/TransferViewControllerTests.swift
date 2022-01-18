//
//  TransferViewControllerTests.swift
//  HomeAssignmentIOSTests
//
//  Created by saurabh.a.rana on 18/01/22.
//

import XCTest
@testable import HomeAssignmentIOS

class TransferViewControllerTests: XCTestCase {
    var transferVC: TransferViewController!
    var viewModel: TransferViewModel!
    
    override func setUpWithError() throws {
        transferVC = TransferViewController()
        transferVC.viewDidLoad()
        transferVC.viewWillAppear(true)
        viewModel = TransferViewModel()
    }
    
    func testValidateTextInputs() {
        let userTextInput = TextInput(frame: .zero)
        userTextInput.loadSubview()
        userTextInput.textField?.text = "Alvis"
        userTextInput.placeHolderLabel?.text = "Payee"
        XCTAssertNotNil(viewModel.validateTextInputs(textInput: userTextInput,
                                                     validationString: .passwordRequired))
    }
    
    override func tearDownWithError() throws {
        transferVC = nil
    }
}
