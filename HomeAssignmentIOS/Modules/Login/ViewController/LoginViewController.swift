//
//  ViewController.swift
//  HomeAssignmentIOS
//
//  Created by saurabh.a.rana on 13/01/22.
//

import UIKit
import Security

class LoginViewController: UIViewController {
    @IBOutlet weak var usernameTextInput: TextInput!
    @IBOutlet weak var passwordTextInput: TextInput!
    @IBOutlet weak var loginButton: RoundButton!
    @IBOutlet weak var registerButton: RoundButton!
    @IBOutlet weak var errorView: CustomErrorView!
    
    private var loginViewModel: LoginViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginViewModel = LoginViewModel()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    private func setupUI() {
        setUpTextfields()
    }
    
    private func setUpTextfields() {
        usernameTextInput.placeHolderLabel.text = Constants.username
        passwordTextInput.placeHolderLabel.text = Constants.password
        usernameTextInput.textField.delegate = self
        passwordTextInput.textField.delegate = self
        usernameTextInput.textField.returnKeyType = .next
        passwordTextInput.textField.isSecureTextEntry = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    @IBAction func loginAction(_ sender: Any) {
        guard let viewModel = loginViewModel else { return }
        loginButton.selectedState = true
        registerButton.selectedState = false
        registerButton.layoutSubviews()
        validateTextInputs()
        
        if viewModel.textInputValidationStatus {
            aunthenticate()
        } else {
            errorView.errorString = nil
        }
    }
    
    @IBAction func registerAction(_ sender: Any) {
        registerButton.selectedState = true
        loginButton.selectedState = false
        loginButton.layoutSubviews()
    }
}

extension LoginViewController {
    private func aunthenticate() {
        guard let viewModel = loginViewModel else { return }
        guard let username = usernameTextInput.textField.text, let password = passwordTextInput.textField.text else { return }
        Spinner.start(style: .large, baseColor: .black)
        
        viewModel.makeAuthenticationCall(username: username, password: password) { [weak self] loginData, error in
            guard let self = self else { return }
            if error == nil {
                // Navigate to dashboard
                guard let data = loginData else { return }
                debugPrint("Status of API: ------------- \(data)")
                DispatchQueue.main.async {
                    self.errorView.errorString = nil
                    Spinner.stop()
                    self.navigateToDashboad()
                }
            } else {
                // Show Error
                DispatchQueue.main.async {
                    self.errorView.errorString = error
                }
            }
            DispatchQueue.main.async {
                Spinner.stop()
            }
        }
    }
    
    private func validateTextInputs() {
        guard let viewModel = loginViewModel else { return }
        viewModel.validateTextInputs(textInput: usernameTextInput, validationString: .usernameRequired)
        viewModel.validateTextInputs(textInput: passwordTextInput, validationString: .passwordRequired)
    }
    
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    private func navigateToDashboad() {
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switchBasedNextTextField(textField)
        return true
    }
    
    private func switchBasedNextTextField(_ textField: UITextField) {
        switch textField {
        case usernameTextInput.textField:
            passwordTextInput.textField.becomeFirstResponder()
        case passwordTextInput.textField:
            passwordTextInput.textField.resignFirstResponder()
        default:
            passwordTextInput.textField.becomeFirstResponder()
        }
    }
}
