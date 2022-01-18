//
//  TransferViewController.swift
//  HomeAssignmentIOS
//
//  Created by saurabh.a.rana on 17/01/22.
//

import UIKit

class TransferViewController: UIViewController {
    
    /// IBOutlet used
    @IBOutlet weak var payeeTextInput: TextInput!
    @IBOutlet weak var amountTextInput: TextInput!
    @IBOutlet weak var descriptionViewBackView: UIView!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var transferButton: RoundButton!
    @IBOutlet weak var errorView: CustomErrorView!
    
    /// Variables used
    var itemPicker: UIPickerView! = UIPickerView()
    
    private var transferViewModel: TransferViewModel?
    private var payeesDataList: [PayeeData]?
    private var index: Int = 0
    private var senderAccountNo = ""
    
    /// View Controller life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        transferViewModel = TransferViewModel()
        setupUI()
        getListOfPayees()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false,
                                                     animated: animated)
    }
    
    /// Funciton to setup UI
    private func setupUI() {
        addBackButton()
        setUpTextfields()
        descriptionViewBackView?.addViewBorder(borderColor: UIColor.black.cgColor,
                                              borderWith: 1.5,
                                              borderCornerRadius: 1.0)
        setUpPickerView()
    }
    
    /// Funciton to setup textfields
    private func setUpTextfields() {
        payeeTextInput?.placeHolderLabel.text = Constants.payeeText
        amountTextInput?.placeHolderLabel.text = Constants.amountText
        amountTextInput?.textField.keyboardType = .numberPad
        payeeTextInput?.textField.delegate = self
        amountTextInput?.textField.delegate = self
        descriptionTextView?.delegate = self
        payeeTextInput?.textField .inputView = itemPicker
        payeeTextInput?.textField.tintColor = .clear
        payeeTextInput?.textField.setLeftImage(imageName: Constants.downButtonImage)
        
        let tapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(self.dismissKeyboard (_:)))
        self.view.addGestureRecognizer(tapGesture)
        addDoneButtonOnKeyboard()
    }
    
    /// Funciton to setup picker view
    private func setUpPickerView() {
        itemPicker.delegate = self
        itemPicker.dataSource = self
        itemPicker.reloadAllComponents()
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.black
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: Constants.done,
                                         style: .plain,
                                         target: self,
                                         action: #selector(self.doneTapped))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                          target: nil,
                                          action: nil)
        let cancelButton = UIBarButtonItem(title: Constants.cancel,
                                           style: .plain,
                                           target: self,
                                           action: #selector(self.cancelTapped))
        
        toolBar.setItems([cancelButton, spaceButton, doneButton],
                         animated: false)
        toolBar.isUserInteractionEnabled = true
        
        payeeTextInput?.textField.inputView = itemPicker
        payeeTextInput?.textField.inputAccessoryView = toolBar
    }
    
    /// Funciton to close picker after selection
    @objc func doneTapped() {
        guard let payees = payeesDataList else { return }
        payeeTextInput.textField.text = payees[index].name
        senderAccountNo = payees[index].accountNo
        payeeTextInput.textField.resignFirstResponder()
    }
    
    /// Funciton to close picker
    @objc func cancelTapped() {
        payeeTextInput.textField.resignFirstResponder()
    }
    
    /// Funciton to dismiss keyboard
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    /// Funciton to validate inputtexts
    private func validateTextInputs() {
        guard let viewModel = transferViewModel else { return }
        viewModel.validateTextInputs(textInput: payeeTextInput,
                                     validationString: .payeeRequired)
    }
    
    /// Function to make tranfer
    /// - Parameter sender: Instance of button
    @IBAction func transferAction(_ sender: Any) {
        guard let viewModel = transferViewModel else { return }
        validateTextInputs()
        
        if viewModel.textInputValidationStatus {
            makeTransfer()
        } else {
            errorView.errorString = nil
        }
    }
}

extension TransferViewController {
    /// Function to get instance of viewController
    /// - Returns: Instance of viewController
    static func initializeFromStoryboard() -> TransferViewController? {
        if let controller = UIStoryboard(name: Constants.main,
                                         bundle: nil).instantiateViewController(withIdentifier: Constants.transferVC) as? TransferViewController {
            return controller
        } else { return nil }
    }
    
    /// Function to add done button on keyboard
    private func addDoneButtonOnKeyboard(){
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0,
                                                                  y: 0,
                                                                  width: UIScreen.main.bounds.width,
                                                                  height: 50))
        doneToolbar.barStyle = .default
        doneToolbar.isTranslucent = true
        doneToolbar.tintColor = UIColor.black
        doneToolbar.sizeToFit()
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                        target: nil,
                                        action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: Constants.done,
                                                    style: .done,
                                                    target: self,
                                                    action: #selector(self.doneButtonAction))
        
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        amountTextInput?.textField.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction(){
        amountTextInput.textField.resignFirstResponder()
    }
    
    /// Function to get list of payees
    private func getListOfPayees() {
        guard let viewModel = transferViewModel else { return }
        Spinner.start(style: .large,
                      baseColor: .black)
        viewModel.getPayeesList { [weak self] payeesList, error in
            guard let self = self else { return }
            if error == nil {
                DispatchQueue.main.async {
                    self.payeesDataList = payeesList?.data
                    self.itemPicker.reloadAllComponents()
                    Spinner.stop()
                }
            } else {
                DispatchQueue.main.async {
                    self.popupAlert(title: Constants.errorTitle,
                                    message: error,
                                    actionTitles: [Constants.ok], actions:[{ action in
                    }])
                    Spinner.stop()
                }
            }
        }
    }
    
    /// Function to call api of tranfer money
    private func makeTransfer() {
        guard let viewModel = transferViewModel else { return }
        Spinner.start(style: .large,
                      baseColor: .black)
        let amount = amountTextInput.textField.text ?? ""
        let description = descriptionTextView.text ?? ""
        viewModel.makeTransfer(receipient: senderAccountNo,
                               amount: amount,
                               description: description) { [weak self] transferData, error in
            guard let self = self else { return }
            if error == nil {
                DispatchQueue.main.async {
                    self.popupAlert(title: "", message: Constants.SuccessMessge,
                                    actionTitles: [Constants.ok],
                                    actions:[{ action in
                        self.navigationController?.popViewController(animated: true)
                    }])
                    Spinner.stop()
                }
            } else {
                DispatchQueue.main.async {
                    self.errorView.errorString = error
                    Spinner.stop()
                }
            }
        }
    }
}

extension TransferViewController: UITextFieldDelegate, UITextViewDelegate {
    /// Textfield delegates
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switchBasedNextTextField(textField)
        return true
    }
    
    private func switchBasedNextTextField(_ textField: UITextField) {
        switch textField {
        case payeeTextInput.textField:
            amountTextInput.textField.becomeFirstResponder()
        case amountTextInput.textField:
            descriptionTextView.becomeFirstResponder()
        default:
            descriptionTextView.becomeFirstResponder()
        }
    }
    
    /// Textview delegate
    func textView(_ textView: UITextView,
                  shouldChangeTextIn range: NSRange,
                  replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}

extension TransferViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    /// Pickerview delegate and datasources
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        guard let payees = payeesDataList else { return 0 }
        return payees.count
    }
    
    func pickerView( _ pickerView: UIPickerView,
                     titleForRow row: Int,
                     forComponent component: Int) -> String? {
        guard let payees = payeesDataList else { return "" }
        let conditionIndex = payees[row].accountNo.count - 5
        let maskedName = String(payees[row].accountNo.enumerated().map { (index, element) -> Character in
            return index < conditionIndex ? "X" : element
        })
        return payees[row].name + " " +  maskedName
    }
    
    func pickerView( _ pickerView: UIPickerView,
                     didSelectRow row: Int,
                     inComponent component: Int) {
        index = row
    }
}
