//
//  DashboardViewModel.swift
//  HomeAssignmentIOS
//
//  Created by saurabh.a.rana on 17/01/22.
//

import Foundation

struct UserTransaction {
    let title: String
    let data: [Transaction]
}

class DashboardViewModel {
    
    private var transactionData: [Transaction] = []
    private var userTransactions: [UserTransaction] = []
    
    func getTransactions(completion: @escaping ([UserTransaction], String?) -> Void) {
        transactions { [weak self] data, response, error in
            guard let self = self else { return }
            if error == nil {
                guard let data = data else { return }
                do {
                    let transactionData = try JSONDecoder().decode(TransactionModel.self, from: data)
                    debugPrint("response data:", transactionData)
                    if transactionData.status == StatusReponse.success.rawValue {
                        let userTransactionArray = self.filterTransactionByDate(transactionArray: transactionData.data)
                        completion(userTransactionArray, nil)
                    } else {
                        guard let errorString = transactionData.error?.message else { return completion([], Constants.genericServerErrorMeesage)}
                        completion([], errorString)
                    }
                } catch let err {
                    debugPrint("Error: ", err)
                    completion([], err.localizedDescription)
                }
            } else {
                guard let err = error else { return }
                completion([], err.localizedDescription)
            }
        }
    }
    
    func getBalance(completion: @escaping (BalanceModel?, String?) -> Void) {
        balance { data, response, error in
            if error == nil {
                guard let data = data else { return }
                do {
                    let balanceData = try JSONDecoder().decode(BalanceModel.self, from: data)
                    debugPrint("response data:", balanceData)
                    if balanceData.status == StatusReponse.success.rawValue {
                        completion(balanceData, nil)
                    } else {
                        guard let errorString = balanceData.error?.message else { return completion(nil, Constants.genericServerErrorMeesage)}
                        completion(nil, errorString)
                    }
                } catch let err {
                    debugPrint("Error: ", err)
                    completion(nil, err.localizedDescription)
                }
            } else {
                guard let err = error else { return }
                completion(nil, err.localizedDescription)
            }
        }
    }
    
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
                for item in groupBydate {
                    userTransactions.append(UserTransaction(title: item.key, data: item.value))
                }
                debugPrint("UserTransactionArray ---------------  \(userTransactions)")
                return userTransactions
            }
        }
        return []
    }
}

extension DashboardViewModel: EndpopintAPICall {
    func transactions(completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        let endPoint = EndpointCases.transactions
        ServiceRequest.shared.request(endpoint: endPoint) { data, response, error in
            completion(data, response, error)
        }
    }
    
    func balance(completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        let endPoint = EndpointCases.balance
        ServiceRequest.shared.request(endpoint: endPoint) { data, response, error in
            completion(data, response, error)
        }
    }
}
