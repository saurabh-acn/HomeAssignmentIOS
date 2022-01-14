//
//  ViewController.swift
//  HomeAssignmentIOS
//
//  Created by saurabh.a.rana on 13/01/22.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var usernameTextInput: TextInput!
    @IBOutlet weak var passwordTextInput: TextInput!
    @IBOutlet weak var loginButton: RoundButton!
    @IBOutlet weak var registerButton: RoundButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        setupUI()
    }
    
    func setupUI() {
        setUpTextfields()
    }
    
    func setUpTextfields() {
        usernameTextInput.placeHolderLabel.text = "Username"
        passwordTextInput.placeHolderLabel.text = "Password"
    }
    
    @IBAction func loginAction(_ sender: Any) {
        loginButton.selectedState = true
        registerButton.selectedState = false
        registerButton.layoutSubviews()
        validateTextInputs()
    }
    
    @IBAction func registerAction(_ sender: Any) {
        registerButton.selectedState = true
        loginButton.selectedState = false
        loginButton.layoutSubviews()
    }
}

extension LoginViewController {
    func validateTextInputs() {
        do {
            _ = try usernameTextInput.textField.validatedText(validationType: .requiredField(field: usernameTextInput.placeHolderLabel.text!))
            usernameTextInput.errorString = nil
        } catch(let error) {
            usernameTextInput.errorString = "Username is required"
            debugPrint("------------VALIDATION ERROR \(error)")
        }
        
        do {
            _ = try passwordTextInput.textField.validatedText(validationType: .requiredField(field: passwordTextInput.placeHolderLabel.text!))
            passwordTextInput.errorString = nil
        } catch(let error) {
            passwordTextInput.errorString = "Password is required"
            debugPrint("------------VALIDATION ERROR \(error)")
        }
    }
}


extension UITextField {
    func validatedText(validationType: ValidatorType) throws -> String {
        let validator = VaildatorFactory.validatorFor(type: validationType)
        return try validator.validated(self.text!)
    }
}
