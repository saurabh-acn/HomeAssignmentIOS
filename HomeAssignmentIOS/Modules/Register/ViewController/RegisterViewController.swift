//
//  RegisterViewController.swift
//  HomeAssignmentIOS
//
//  Created by saurabh.a.rana on 17/01/22.
//

import UIKit

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var usernameTextInput: TextInput!
    @IBOutlet weak var passwordTextInput: TextInput!
    @IBOutlet weak var confirmTextInput: TextInput!
    @IBOutlet weak var registerButton: RoundButton!
    @IBOutlet weak var errorView: CustomErrorView!
    
    private var registerViewModel: RegisterViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerViewModel = RegisterViewModel()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    private func setupUI() {
        addBackButton()
        setUpTextfields()
    }
    
    private func setUpTextfields() {
        usernameTextInput.placeHolderLabel.text = Constants.username
        passwordTextInput.placeHolderLabel.text = Constants.password
        confirmTextInput.placeHolderLabel.text = Constants.confirmPassword
        usernameTextInput.textField.delegate = self
        passwordTextInput.textField.delegate = self
        confirmTextInput.textField.delegate = self
        usernameTextInput.textField.returnKeyType = .next
        passwordTextInput.textField.returnKeyType = .next
        passwordTextInput.textField.isSecureTextEntry = true
        confirmTextInput.textField.isSecureTextEntry = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @IBAction func registerAction(_ sender: Any) {
        guard let viewModel = registerViewModel else { return }
        registerButton.selectedState = true
        validateTextInputs()
        
        if viewModel.textInputValidationStatus {
            userRegistration()
        } else {
            errorView.errorString = nil
        }
    }
}

extension RegisterViewController {
    private func validateTextInputs() {
        guard let viewModel = registerViewModel else { return }
        viewModel.validateTextInputs(textInput: usernameTextInput, validationString: .usernameRequired)
        viewModel.validateTextInputs(textInput: passwordTextInput, validationString: .passwordRequired)
        viewModel.validateTextInputs(textInput: confirmTextInput, validationString: .confirmRequired)
        viewModel.validateConfirmPassword(password: passwordTextInput, confirmPasword: confirmTextInput, validationString: .confirmPasswordError)
    }
    
    private func userRegistration() {
        guard let viewModel = registerViewModel else { return }
        guard let username = usernameTextInput.textField.text, let password = passwordTextInput.textField.text else { return }
        Spinner.start(style: .large, baseColor: .black)
        viewModel.registerUser(username: username, password: password) { loginData, error in
            if error == nil {
                // Navigate to dashboard
                guard let data = loginData else { return }
                debugPrint("Status of API: ------------- \(data)")
                DispatchQueue.main.async {
                    self.errorView.errorString = nil
//                    self.navigateToDashboad()
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
}

extension RegisterViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switchBasedNextTextField(textField)
        return true
    }
    
    private func switchBasedNextTextField(_ textField: UITextField) {
        switch textField {
        case usernameTextInput.textField:
            passwordTextInput.textField.becomeFirstResponder()
        case passwordTextInput.textField:
            confirmTextInput.textField.becomeFirstResponder()
        case confirmTextInput.textField:
            confirmTextInput.textField.resignFirstResponder()
        default:
            confirmTextInput.textField.becomeFirstResponder()
        }
    }
}