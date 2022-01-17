//
//  TransferModel.swift
//  HomeAssignmentIOS
//
//  Created by saurabh.a.rana on 17/01/22.
//

import Foundation

// MARK: - TransferModel
struct TransferModel: Codable {
    let status, transactionID, recipientAccount, welcomeDescription: String?
    let amount: Int?
    let error: String?

    enum CodingKeys: String, CodingKey {
        case status, amount, recipientAccount, error
        case transactionID = "transactionId"
        case welcomeDescription = "description"
    }
}
