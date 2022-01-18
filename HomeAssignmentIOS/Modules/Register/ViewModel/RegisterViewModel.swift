//
//  RegisterViewModel.swift
//  HomeAssignmentIOS
//
//  Created by saurabh.a.rana on 17/01/22.
//

import Foundation

class RegisterViewModel {
    /// Variable used
    private var isValidated = false
    var textInputValidationStatus: Bool {
        return isValidated
    }
    
    /// Function to to validate textinputs
    /// - Parameters:
    ///   - textInput: Instance of TextInput
    ///   - validationString: Validation error string
    func validateTextInputs(textInput: TextInput, validationString: ValidationStrings) {
        Validators.validateTextInputs(textInput: textInput,
                                      validationString: validationString) { [weak self] success in
            guard let self = self else { return }
            self.isValidated = success
        }
    }
    
    /// Function to to validate textinputs
    /// - Parameters:
    ///   - textInput: Instance of TextInput
    ///   - validationString: Validation error string
    ///   - completion: Closure to get status
    func validatePasswordTextInput(textInput: TextInput,
                                   validationString: ValidationStrings,
                                   completion: @escaping (Bool) -> Void) {
        if !(textInput.textField.text?.isEmpty ?? true) {
            Validators.validatePasswordTextInput(textInput: textInput,
                                                 validationString: .passwordStrength) { [weak self] success in
                guard let self = self else { return }
                self.isValidated = success
                completion(!success)
            }
        }
    }
    
    /// Function to to validate textinputs
    /// - Parameters:
    ///   - password: Instance of TextInput
    ///   - confirmPasword: Instance of TextInput
    ///   - validationString: Validation error string
    func validateConfirmPassword(password: TextInput,
                                 confirmPasword: TextInput,
                                 validationString: ValidationStrings) {
        if let passwordText = password.textField.text,
           passwordText.count > 8,
           let confirmPasswordText = confirmPasword.textField.text,
           confirmPasswordText.count > 8 {
            Validators.confirmPasswordFields(password: password,
                                             confirmPasword: confirmPasword,
                                             validationString: .confirmPasswordError) { [weak self] success in
                guard let self = self else { return }
                self.isValidated = success
            }
        }
    }
    
    /// Function to call register api
    /// - Parameters:
    ///   - username: username
    ///   - password: password
    ///   - completion: Closure to get response from api
    func registerUser(username: String,
                      password: String,
                      completion: @escaping (RegisterModel?, String?) -> Void) {
        register(username: username,
                 password: password) { data, response, error in
            if error == nil {
                guard let data = data else { return completion(nil, Constants.genericServerErrorMeesage)}
                do {
                    let registerData = try JSONDecoder().decode(RegisterModel.self, from: data)
                    if registerData.status == StatusReponse.success.rawValue {
                        completion(registerData, nil)
                    } else {
                        completion(nil, registerData.error)
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

extension RegisterViewModel: EndpopintAPICall {
    /// Funciton to call api
    /// - Parameters:
    ///   - username: username
    ///   - password: password
    ///   - completion: Closure to get response from api
    func register(username: String,
                  password: String,
                  completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        let endPoint = EndpointCases.register(username: username,
                                              password: password)
        ServiceRequest.shared.request(endpoint: endPoint) { data, response, error in
            completion(data, response, error)
        }
    }
}
