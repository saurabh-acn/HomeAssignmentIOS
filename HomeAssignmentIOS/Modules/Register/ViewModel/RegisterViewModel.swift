//
//  RegisterViewModel.swift
//  HomeAssignmentIOS
//
//  Created by saurabh.a.rana on 17/01/22.
//

import Foundation

class RegisterViewModel {
    private var isValidated = false
    var textInputValidationStatus: Bool {
        return isValidated
    }
    
    func validateTextInputs(textInput: TextInput, validationString: ValidationStrings) {
        Validators.validateTextInputs(textInput: textInput,
                                      validationString: validationString) { [weak self] success in
            guard let self = self else { return }
            self.isValidated = success
        }
    }
    
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
    
    func registerUser(username: String,
                      password: String,
                      completion: @escaping (RegisterModel?, String?) -> Void) {
        register(username: username,
                 password: password) { data, response, error in
            if error == nil {
                guard let data = data else { return }
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
