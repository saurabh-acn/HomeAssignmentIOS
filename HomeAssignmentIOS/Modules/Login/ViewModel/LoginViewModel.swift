//
//  LoginViewModel.swift
//  HomeAssignmentIOS
//
//  Created by saurabh.a.rana on 14/01/22.
//

import Foundation

class LoginViewModel {
    
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
    
    
    /// Function to call login api
    /// - Parameters:
    ///   - username: username
    ///   - password: password
    ///   - completion: Closure to get response from api
    func makeAuthenticationCall(username: String,
                                password: String,
                                completion: @escaping (LoginModel?, String?) -> Void) {
        login(username: username,
              password: password) { data, response, error in
            if error == nil {
                guard let data = data else { return completion(nil, Constants.genericServerErrorMeesage) }
                do {
                    let loginData = try JSONDecoder().decode(LoginModel.self,
                                                             from: data)
                    if loginData.status == StatusReponse.success.rawValue {
                        if let jwtToken = loginData.token {
                            KeychainService.deleteCredentials(username: Constants.userKey)
                            KeychainService.deleteCredentials(username: username+Constants.tokenKey)
                            KeychainService.deleteCredentials(username: username+Constants.passwordKey)
                            KeychainService.saveCredentials(username: Constants.userKey, password: username)
                            if let username = KeychainService.retrieveCredentials(username: Constants.userKey) {
                                KeychainService.saveCredentials(username: username+Constants.tokenKey, password: jwtToken)
                                KeychainService.saveCredentials(username: username+Constants.passwordKey, password: password)
                            }
                        }
                        completion(loginData, nil)
                    } else {
                        completion(nil, loginData.error)
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

extension LoginViewModel: EndpopintAPICall {
    /// Function to call login api
    /// - Parameters:
    ///   - username: username
    ///   - password: password
    ///   - completion: Closure to get response from api
    func login(username: String,
               password: String,
               completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        let endPoint = EndpointCases.login(username: username,
                                           password: password)
        ServiceRequest.shared.request(endpoint: endPoint) { data, response, error in
            completion(data, response, error)
        }
    }
}
