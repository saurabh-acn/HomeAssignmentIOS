//
//  ViewController.swift
//  HomeAssignmentIOS
//
//  Created by saurabh.a.rana on 14/01/22.
//

import UIKit
import Security

class LoginViewController: UIViewController {
    
    /// IBOutlet used
    @IBOutlet weak var usernameTextInput: TextInput!
    @IBOutlet weak var passwordTextInput: TextInput!
    @IBOutlet weak var loginButton: RoundButton!
    @IBOutlet weak var registerButton: RoundButton!
    @IBOutlet weak var errorView: CustomErrorView!
    
    /// Variables used
    private var loginViewModel: LoginViewModel?
    
    /// View Controller life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        loginViewModel = LoginViewModel()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true,
                                                     animated: animated)
        clearTextInputs()
    }
    
    /// Funciton to setup UI
    func setupUI() {
        setUpTextfields()
    }
    
    /// Funciton to setup textinputs
    func setUpTextfields() {
        usernameTextInput?.placeHolderLabel.text = Constants.username
        passwordTextInput?.placeHolderLabel.text = Constants.password
        usernameTextInput?.textField.delegate = self
        passwordTextInput?.textField.delegate = self
        usernameTextInput?.textField.returnKeyType = .next
        passwordTextInput?.textField.isSecureTextEntry = true
        
        let tapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(self.dismissKeyboard (_:)))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    /// Funciton to set default state of screen
    private func clearTextInputs() {
        usernameTextInput?.textField.text = nil
        passwordTextInput?.textField.text = nil
        usernameTextInput?.errorString = nil
        passwordTextInput?.errorString = nil
        loginButton?.selectedState = false
        registerButton?.selectedState = false
        loginButton?.layoutSubviews()
        registerButton?.layoutSubviews()
        errorView?.errorString = nil
        view.endEditing(true)
    }
    
    /// Function to call login api after validation
    @IBAction func loginAction(_ sender: Any) {
        guard let viewModel = loginViewModel else { return }
        loginButton?.selectedState = true
        registerButton?.selectedState = false
        registerButton?.layoutSubviews()
        validateTextInputs(username: usernameTextInput,
                           password: passwordTextInput)
        
        if viewModel.textInputValidationStatus {
            aunthenticate()
        } else {
            errorView.errorString = nil
        }
    }
    
    /// Funciton to navigte to registre screen
    @IBAction func registerAction(_ sender: Any) {
        registerButton?.selectedState = true
        loginButton?.selectedState = false
        loginButton?.layoutSubviews()
    }
}

extension LoginViewController {
    /// Funciton to call login api
    private func aunthenticate() {
        guard let viewModel = loginViewModel else { return }
        guard let username = usernameTextInput.textField.text,
              let password = passwordTextInput.textField.text else { return }
        Spinner.start(style: .large,
                      baseColor: .black)
        viewModel.makeAuthenticationCall(username: username,
                                         password: password) { [weak self] loginData, error in
            guard let self = self else { return }
            if error == nil {
                // Navigate to dashboard
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
    
    /// Fucniton to validate textinputs
    /// - Parameters:
    ///   - username: Instance of TextInput
    ///   - password: Instance of TextInput
    func validateTextInputs(username: TextInput,
                            password: TextInput) {
        guard let viewModel = loginViewModel else { return }
        viewModel.validateTextInputs(textInput: username,
                                     validationString: .usernameRequired)
        viewModel.validateTextInputs(textInput: password,
                                     validationString: .passwordRequired)
    }
    
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    private func navigateToDashboad() {
        guard let viewController = DashboardViewController.initializeFromStoryboard() else { return }
        navigationController?.pushViewController(viewController,
                                                 animated: true)
    }
}

extension LoginViewController: UITextFieldDelegate {
    /// Textfield delegates
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
