//
//  KeychainServiceTests.swift
//  HomeAssignmentIOSTests
//
//  Created by saurabh.a.rana on 18/01/22.
//

import XCTest
@testable import HomeAssignmentIOS

class KeychainServiceTests: XCTestCase {

    override func setUpWithError() throws {
        XCTAssertNotNil(KeychainService.saveCredentials(username: "testuser", password: "12345678M$"))
        XCTAssertNotNil(KeychainService.retrieveCredentials(username: "testuser"))
        XCTAssertNotNil(KeychainService.updateCredentials(username: "testuser", password: "12345678M$"))
        XCTAssertNotNil(KeychainService.deleteCredentials(username: "testuser"))
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
}
