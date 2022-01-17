//
//  RegisterModel.swift
//  TestTableView
//
//  Created by saurabh.a.rana on 13/01/22.
//

import Foundation

// MARK: - RegisterModel
struct RegisterModel: Decodable {
    let status: String
    let token: String?
    let error: String?

    enum CodingKeys: String, CodingKey {
        case status, token, error
    }
}
