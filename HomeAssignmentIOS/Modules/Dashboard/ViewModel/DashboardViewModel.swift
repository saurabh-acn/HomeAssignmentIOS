//
//  DashboardViewModel.swift
//  HomeAssignmentIOS
//
//  Created by saurabh.a.rana on 17/01/22.
//

import Foundation

/// UserTransaction Model
struct UserTransaction {
    let title: String
    let data: [Transaction]
}

class DashboardViewModel {
    
    /// Variable used
    private var transactionData: [Transaction] = []
    private var userTransactions: [UserTransaction] = []
    
    /// Function to get transaction of user
    /// - Parameter completion: closure to get response
    func getTransactions(completion: @escaping ([UserTransaction], String?) -> Void) {
        transactions { [weak self] data, response, error in
            guard let self = self else { return completion([], Constants.genericServerErrorMeesage) }
            if error == nil {
                guard let data = data else { return }
                do {
                    let transactionData = try JSONDecoder().decode(TransactionModel.self, from: data)
                    if transactionData.status == StatusReponse.success.rawValue {
                        let userTransactionArray = self.filterTransactionByDate(transactionArray: transactionData.data)
                        completion(userTransactionArray, nil)
                    } else {
                        guard let errorString = transactionData.error?.message else { return completion([], Constants.genericServerErrorMeesage)}
                        completion([], errorString)
                    }
                } catch let err {
                    completion([], err.localizedDescription)
                }
            } else {
                guard let err = error else { return }
                completion([], err.localizedDescription)
            }
        }
    }
    
    /// Function to get balance
    /// - Parameter completion: closure to get response
    func getBalance(completion: @escaping (BalanceModel?, String?) -> Void) {
        balance { data, response, error in
            if error == nil {
                guard let data = data else { return completion(nil, Constants.genericServerErrorMeesage)}
                do {
                    let balanceData = try JSONDecoder().decode(BalanceModel.self,
                                                               from: data)
                    if balanceData.status == StatusReponse.success.rawValue {
                        completion(balanceData, nil)
                    } else {
                        guard let errorString = balanceData.error?.message else { return completion(nil, Constants.genericServerErrorMeesage)}
                        completion(nil, errorString)
                    }
                } catch let err {
                    completion(nil, err.localizedDescription)
                }
            } else {
                guard let err = error else { return }
                completion(nil, err.localizedDescription)
            }
        }
    }
    
    /// Function to filter data array
    /// - Parameter transactionArray: Array of Transaction
    /// - Returns: Array of UserTransaction
    private func filterTransactionByDate(transactionArray: [Transaction]?) -> [UserTransaction] {
        userTransactions.removeAll()
        transactionData.removeAll()
        if let transactions = transactionArray, transactions.count > 0 {
            _ = transactions.map { trans in
                let dateFormatterGet = DateFormatter()
                dateFormatterGet.dateFormat = Constants.dateFormat1
                
                let dateFormatterPrint = DateFormatter()
                dateFormatterPrint.dateFormat = Constants.dateFormat2
                
                if let date = dateFormatterGet.date(from: trans.transactionDate) {
                    let transactiondate = dateFormatterPrint.string(from: date)
                    let transaction = Transaction(transactionID: trans.transactionID,
                                                  amount: trans.amount,
                                                  transactionDate: transactiondate,
                                                  transactionType: trans.transactionType,
                                                  description: trans.description,
                                                  receipient: trans.receipient,
                                                  sender: trans.sender)
                    transactionData.append(transaction)
                } else {
                    debugPrint(Constants.dateErrorMeesage)
                }
            }
            if transactionData.count > 0 {
                let groupBydate = Dictionary(grouping: transactionData) { (transaction) -> String in
                    return transaction.transactionDate
                }
                _ = groupBydate.map({ data in
                    userTransactions.append(UserTransaction(title: data.key,
                                                            data: data.value))
                })
                return userTransactions
            }
        }
        return []
    }
}

extension DashboardViewModel: EndpopintAPICall {
    /// Funciton to call transactions APi
    /// - Parameter completion: Closure to get response of api
    func transactions(completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        let endPoint = EndpointCases.transactions
        ServiceRequest.shared.request(endpoint: endPoint) { data, response, error in
            completion(data, response, error)
        }
    }
    
    /// Funciton to call balance APi
    /// - Parameter completion: Closure to get response of api
    func balance(completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        let endPoint = EndpointCases.balance
        ServiceRequest.shared.request(endpoint: endPoint) { data, response, error in
            completion(data, response, error)
        }
    }
}
