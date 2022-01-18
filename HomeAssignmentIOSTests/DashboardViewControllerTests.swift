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
        dashboardVC = DashboardViewController.initializeFromStoryboard()
        viewModel = DashboardViewModel()
        dashboardVC.viewDidLoad()
        dashboardVC.viewWillAppear(true)
    }
    
    override func tearDownWithError() throws {
        dashboardVC = nil
    }
}
