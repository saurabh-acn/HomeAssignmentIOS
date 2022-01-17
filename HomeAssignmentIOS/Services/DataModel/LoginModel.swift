//
//  LoginModel.swift
//  HomeAssignmentIOS
//
//  Created by saurabh.a.rana on 14/01/22.
//

import Foundation

// MARK: - LoginModel
struct LoginModel: Decodable {
    let status: String
    let token, username, accountNo, error: String?
    
    enum CodingKeys: String, CodingKey {
        case status, token, username, accountNo, error
    }
}
