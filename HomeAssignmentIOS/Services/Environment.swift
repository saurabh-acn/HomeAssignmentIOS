//
//  Environment.swift
//  TestTableView
//
//  Created by saurabh.a.rana on 13/01/22.
//

import Foundation
import UIKit

enum Environment {
    case development
    case production             // Incase for Produciton Approach
}

enum EnvironmentConstant {
    static let baseURL = "https://green-thumb-64168.uc.r.appspot.com/"
    static let contentType = "application/json"
    static let accept = "application/json"
}

extension Environment {
    static var current: Environment {
        let targetName = Bundle.main.infoDictionary?["TargetName"] as? String
        switch targetName {
        case "HomeAssignmentIOS":
            return Environment.development
        default:
            return Environment.development
        }
    }
    
    var baseUrlPath: String {
        switch self {
        case .development: return EnvironmentConstant.baseURL
        case .production: return EnvironmentConstant.baseURL
        }
    }
    
    var contentType: String {
        return EnvironmentConstant.contentType
    }
    
    var acceptJson: String {
        return EnvironmentConstant.accept
    }
    
    var authToken: String {
        if let username = UserDefaults.standard.string(forKey: Constants.username) {
            if let token = Utilities.retrieveCredentials(username: username+Constants.tokenKey) {
                return token
            }
            return ""
        }
        return ""
    }
}

extension Environment {
    static let login = "login"
    static let register = "register"
    static let transactions = "transactions"
    static let payees = "payees"
    static let balance = "balance"
    static let transfer = "transfer"
}
