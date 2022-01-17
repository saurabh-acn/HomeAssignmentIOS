//
//  BalanceModel.swift
//  HomeAssignmentIOS
//
//  Created by saurabh.a.rana on 16/01/22.
//

import Foundation

// MARK: - BalanceModel
struct BalanceModel: Decodable {
    let status: String
    let accountNo: String?
    let balance: Double?
    let error: BalanceError?
    
    enum CodingKeys: String, CodingKey {
        case status, accountNo, balance, error
    }
}

// MARK: - BalanceError
struct BalanceError: Decodable {
    let name, message, expiredAt: String
    
    enum CodingKeys: String, CodingKey {
        case name, message, expiredAt
    }
}
