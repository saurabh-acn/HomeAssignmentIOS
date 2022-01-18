//
//  DashboardViewControllerTests.swift
//  HomeAssignmentIOSTests
//
//  Created by saurabh.a.rana on 18/01/22.
//

import XCTest
@testable import HomeAssignmentIOS

class DashboardViewControllerTests: XCTestCase {
    var dashboardVC: DashboardViewController!
    var viewModel: DashboardViewModel!
    
    override func setUpWithError() throws {
        dashboardVC = DashboardViewController()
        viewModel = DashboardViewModel()
        dashboardVC.viewDidLoad()
        dashboardVC.viewWillAppear(true)
    }
    
    override func setUp() {
        dashboardVC.navigateTransferView(UIButton())
        dashboardVC.setDefaultButtonConfig()
    }
    
    func testValidateTextInputs() {
//        let userTextInput = TextInput(frame: .zero)
//        userTextInput.loadSubview()
//        userTextInput.textField?.text = "Alvis"
//        userTextInput.placeHolderLabel?.text = "Payee"
//        XCTAssertNotNil(viewModel.validateTextInputs(textInput: userTextInput,
//                                                     validationString: .passwordRequired))
    }
    
    override func tearDownWithError() throws {
        dashboardVC = nil
    }
}
