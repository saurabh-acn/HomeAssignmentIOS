//
//  PayeesModel1.swift
//  HomeAssignmentIOS
//
//  Created by saurabh.a.rana on 17/01/22.
//

import Foundation

// MARK: - PayeesModel
struct PayeesModel: Decodable {
    let status: String
    let data: [PayeeData]?
    let error: String?
    
    enum CodingKeys: String, CodingKey {
        case status, data, error
    }
}

// MARK: - PayeeData
struct PayeeData: Decodable {
    let id, name, accountNo: String
    
    enum CodingKeys: String, CodingKey {
        case id, name, accountNo
    }
}
