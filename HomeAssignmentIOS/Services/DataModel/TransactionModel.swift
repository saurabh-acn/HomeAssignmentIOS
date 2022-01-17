//
//  TransactionModel.swift
//  HomeAssignmentIOS
//
//  Created by saurabh.a.rana on 17/01/22.
//

import Foundation

// MARK: - TransactionModel
struct TransactionModel: Decodable {
    let status: String
    let data: [Transaction]?
    let error: TransactionError?
    
    enum CodingKeys: String, CodingKey {
        case status, data, error
    }
}

// MARK: - TransactionError
struct TransactionError: Decodable {
    let name: String
    let message: String
    let expireTime: String
    
    enum CodingKeys: String, CodingKey {
        case name, message
        case expireTime = "expiredAt"
    }
}

// MARK: - Transaction
struct Transaction: Decodable {
    let transactionID: String
    let amount: Int
    let transactionDate, transactionType: String
    let description : String?
    let receipient: TransactionSenderDetails?
    let sender: TransactionSenderDetails?
    
    enum CodingKeys: String, CodingKey {
        case transactionID = "transactionId"
        case amount, transactionDate, description, transactionType, receipient, sender
    }
}

// MARK: - TransactionSenderDetails
struct TransactionSenderDetails: Decodable {
    let accountNo, accountHolder: String
}
