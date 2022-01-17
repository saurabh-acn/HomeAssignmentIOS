//
//  TransferViewModel.swift
//  HomeAssignmentIOS
//
//  Created by saurabh.a.rana on 17/01/22.
//

import Foundation

class TransferViewModel {
    private var isValidated = false
    var textInputValidationStatus: Bool {
        return isValidated
    }
    
    func validateTextInputs(textInput: TextInput,
                            validationString: ValidationStrings) {
        Validators.validateTextInputs(textInput: textInput,
                                      validationString: validationString) { [weak self] success in
            guard let self = self else { return }
            self.isValidated = success
        }
    }
    
    func getPayeesList(completion: @escaping (PayeesModel?,
                                              String?) -> Void) {
        payees { data, response, error in
            if error == nil {
                guard let data = data else { return }
                do {
                    let payeesList = try JSONDecoder().decode(PayeesModel.self,
                                                              from: data)
                    if payeesList.status == StatusReponse.success.rawValue {
                        completion(payeesList, nil)
                    } else {
                        guard let errorString = payeesList.error else { return completion(nil, Constants.genericServerErrorMeesage)}
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
    
    func makeTransfer(receipient: String,
                      amount: String,
                      description: String,
                      completion: @escaping (TransferModel?, String?) -> Void) {
        transfer(receipient: receipient,
                 amount: amount,
                 description: description) { data, response, error in
            if error == nil {
                guard let data = data else { return }
                do {
                    let transferData = try JSONDecoder().decode(TransferModel.self,
                                                                from: data)
                    if transferData.status == StatusReponse.success.rawValue {
                        completion(transferData, nil)
                    } else {
                        guard let errorString = transferData.error else { return completion(nil, Constants.genericServerErrorMeesage)}
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
}

extension TransferViewModel: EndpopintAPICall {
    func payees(completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        let endPoint = EndpointCases.payees
        ServiceRequest.shared.request(endpoint: endPoint) { data, response, error in
            completion(data, response, error)
        }
    }
    
    func transfer(receipient: String,
                  amount: String,
                  description: String,
                  completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        let amountInt = Int(amount)
        let endPoint = EndpointCases.transfer(receipient: receipient,
                                              amount: amountInt ?? 0,
                                              description: description)
        ServiceRequest.shared.request(endpoint: endPoint) { data, response, error in
            completion(data, response, error)
        }
    }
}
