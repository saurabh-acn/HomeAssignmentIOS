//
//  TransferViewModel.swift
//  HomeAssignmentIOS
//
//  Created by saurabh.a.rana on 17/01/22.
//

import Foundation

class TransferViewModel {
    
    /// Variable used
    private var isValidated = false
    var textInputValidationStatus: Bool {
        return isValidated
    }
    
    /// Function to to validate textinputs
    /// - Parameters:
    ///   - textInput: Instance of TextInput
    ///   - validationString: Validation error string
    func validateTextInputs(textInput: TextInput,
                            validationString: ValidationStrings) {
        Validators.validateTextInputs(textInput: textInput,
                                      validationString: validationString) { [weak self] success in
            guard let self = self else { return }
            self.isValidated = success
        }
    }
    
    /// Function to get list of payee service
    /// - Parameter completion: closure to get response
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
    
    /// Function to transfer money to payee
    /// - Parameters:
    ///   - receipient: account number of receipient
    ///   - amount: amount to tranfer
    ///   - description: description
    ///   - completion: closure to get resonse of api
    func makeTransfer(receipient: String,
                      amount: String,
                      description: String,
                      completion: @escaping (TransferModel?, String?) -> Void) {
        transfer(receipient: receipient,
                 amount: amount,
                 description: description) { data, response, error in
            if error == nil {
                guard let data = data else { return completion(nil, Constants.genericServerErrorMeesage) }
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
    ///  API call to get list of payees
    /// - Parameter completion: closure to get resopnse of api
    func payees(completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        let endPoint = EndpointCases.payees
        ServiceRequest.shared.request(endpoint: endPoint) { data, response, error in
            completion(data, response, error)
        }
    }
    
    /// API call to transfer money to another account
    /// - Parameters:
    ///   - receipient: receipient account number
    ///   - amount: amount to tranfer
    ///   - description: description
    ///   - completion: closure to get resopnse of api
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
