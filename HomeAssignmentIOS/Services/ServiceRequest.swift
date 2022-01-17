//
//  APIManager.swift
//  TestTableView
//
//  Created by saurabh.a.rana on 14/01/22.
//

import Foundation

protocol Endpoint {
    var httpMethod: ReuestType { get }
    var baseURLString: String { get }
    var path: String { get }
    var headers: [String: Any]? { get }
    var body: [String: Any]? { get }
}

@objc protocol EndpopintAPICall {
    @objc optional func register(username: String,
                                 password: String,
                                 completion: @escaping (Data?, URLResponse?, Error?) -> Void)
    @objc optional func login(username: String,
                              password: String,
                              completion: @escaping (Data?, URLResponse?, Error?) -> Void)
    @objc optional func transfer(receipient: String,
                                 amount: String,
                                 description: String,
                                 completion: @escaping (Data?, URLResponse?, Error?) -> Void)
    @objc optional func transactions(completion: @escaping (Data?, URLResponse?, Error?) -> Void)
    @objc optional func balance(completion: @escaping (Data?, URLResponse?, Error?) -> Void)
    @objc optional func payees(completion: @escaping (Data?, URLResponse?, Error?) -> Void)
}

extension Endpoint {
    // a default extension that creates the full URL
    var url: String {
        return baseURLString + path
    }
}

enum ReuestType: String {
    case post = "POST"
    case get = "GET"
}

enum StatusReponse: String {
    case success = "success"
    case failure = "failed"
}

enum EndpointCases: Endpoint {
    case login(username: String,
               password: String)
    case register(username: String,
                  password: String)
    case transfer(receipient: String,
                  amount: Int,
                  description: String)
    case transactions
    case balance
    case payees
    
    var httpMethod: ReuestType {
        switch self {
        case .login,
                .register,
                .transfer:
            return .post
        case .transactions,
                .balance,
                .payees:
            return .get
        }
    }
    
    var baseURLString: String {
        return Environment.current.baseUrlPath
    }
    
    var path: String {
        switch self {
        case .login:
            return Environment.login
        case .register:
            return Environment.register
        case .transactions:
            return Environment.transactions
        case .balance:
            return Environment.balance
        case .payees:
            return Environment.payees
        case .transfer:
            return Environment.transfer
        }
    }
    
    var headers: [String: Any]? {
        switch self {
        case .register,
                .login:
            return [Constants.contentType: Environment.current.contentType,
                    Constants.accept: Environment.current.acceptJson
            ]
        case .transactions,
                .balance,
                .payees,
                .transfer:
            return [Constants.contentType: Environment.current.contentType,
                    Constants.accept: Environment.current.acceptJson,
                    Constants.authorization: Environment.current.authToken,
            ]
        }
    }
    
    var body: [String : Any]? {
        switch self {
        case .login(let username, let password):
            return [Constants.username.lowercased(): username,
                    Constants.password.lowercased() : password]
        case .register(let username, let password):
            return [Constants.username.lowercased(): username,
                    Constants.password.lowercased() : password]
        case .transfer(let receipient, let amount, let description):
            return [Constants.receipient: receipient,
                    Constants.amountText.lowercased() : amount,
                    Constants.description : description]
        case .transactions,
                .balance,
                .payees:
            return nil
        }
    }
}

class ServiceRequest {
    static let shared = ServiceRequest()
    private init() { }
    
    func request(endpoint: Endpoint,
                 completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        let session = URLSession.shared
        
        // URL
        let url = URL(string: endpoint.url)!
        var urlRequest = URLRequest(url: url)
        
        // HTTP Method
        urlRequest.httpMethod = endpoint.httpMethod.rawValue.uppercased()
        if urlRequest.httpMethod == ReuestType.post.rawValue.uppercased() {
            guard let httpBody = try? JSONSerialization.data(withJSONObject: endpoint.body ?? [:],
                                                             options: []) else {
                return
            }
            urlRequest.httpBody = httpBody
        } else {
            urlRequest.httpBody = nil
        }
        
        // Header fields
        endpoint.headers?.forEach({ header in
            urlRequest.setValue(header.value as? String,
                                forHTTPHeaderField: header.key)
        })
        
        let task = session.dataTask(with: urlRequest) { data, response, error in
            completion(data, response, error)
        }
        task.resume()
    }
}
