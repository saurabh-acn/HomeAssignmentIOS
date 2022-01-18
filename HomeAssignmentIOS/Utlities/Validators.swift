import Foundation

/// Enum to maintain validation error strings
enum ValidationStrings: String {
    case usernameRequired = "Username is required"
    case passwordRequired = "Password is required"
    case confirmRequired = "Confirm Password is required"
    case confirmPasswordError = "Confirm Password not match"
    case payeeRequired = "Payee field is required"
    case passwordStrength = "Password must be more than 8 characters, with at least one special character, one uppercase character and one numeric character"
}

class Validators {
    
    /// Function to validate required fileds
    /// - Parameters:
    ///   - textInput: Instance of textinput
    ///   - validationString: Validatoin error string
    ///   - validate: Validation status
    class func validateTextInputs(textInput: TextInput,
                                  validationString: ValidationStrings,
                                  validate: @escaping (Bool) -> Void) {
        do {
            _ = try textInput.textField.validatedText(validationType: .requiredField(field: textInput.placeHolderLabel.text!))
            textInput.errorString = nil
            validate(true)
        } catch(let error) {
            debugPrint(error)
            textInput.errorString = validationString.rawValue
            validate(false)
        }
    }
    
    /// Function to validate strength of password textfileds
    /// - Parameters:
    ///   - textInput: Instance of textinput
    ///   - validationString: Validatoin error string
    ///   - validate: Validation status
    class func validatePasswordTextInput(textInput: TextInput,
                                  validationString: ValidationStrings,
                                  validate: @escaping (Bool) -> Void) {
        do {
            _ = try textInput.textField.validatedText(validationType: .password)
            textInput.errorString = nil
            validate(true)
        } catch(let error) {
            debugPrint(error)
            textInput.errorString = nil
            validate(false)
        }
    }
    
    ///  Function to validate two textfield for same text
    /// - Parameters:
    ///   - password: Instance of textinput
    ///   - confirmPasword: Instance of textinput
    ///   - validationString: Validaiton error string
    ///   - validate: Validaiton status
    class func confirmPasswordFields(password: TextInput,
                                     confirmPasword: TextInput,
                                     validationString: ValidationStrings,
                                     validate: @escaping (Bool) -> Void) {
        if password.textField.text == confirmPasword.textField.text {
            confirmPasword.errorString = nil
            validate(true)
        } else {
            confirmPasword.errorString = validationString.rawValue
            validate(false)
        }
    }
}

/// Class to show validation error
class ValidationError: Error {
    var message: String
    
    init(_ message: String) {
        self.message = message
    }
}

protocol ValidatorConvertible {
    func validated(_ value: String) throws -> String
}

/// Enums used to for diferentiating between different validations
enum ValidatorType {
    case password
    case requiredField(field: String)
}

enum VaildatorFactory {
    static func validatorFor(type: ValidatorType) -> ValidatorConvertible {
        switch type {
        case .password: return PasswordValidator()
        case .requiredField(let fieldName): return RequiredFieldValidator(fieldName)
        }
    }
}

/// Regex used for password strengths
enum ValidatorRegularExpression {
    static let password = "^(?=.*[A-Za-z])(?=.*\\d)(?=.*[$@$!%*#?&])[A-Za-z\\d$@$!%*#?&]{8,}$"

}

struct RequiredFieldValidator: ValidatorConvertible {
    private let fieldName: String
    
    init(_ field: String) {
        fieldName = field
    }
    
    func validated(_ value: String) throws -> String {
        guard !value.isEmpty else {
            let message = "Please ENTER"
            let field = fieldName
            throw ValidationError( message + " " + field)
        }
        return value
    }
}

struct PasswordValidator: ValidatorConvertible {
    func validated(_ value: String) throws -> String {
        guard value != "" else {throw ValidationError("Password is Required")}
        guard value.count >= 8 else { throw ValidationError("Password must have at least 8 characters") }
        
        do {
            if try NSRegularExpression(pattern: ValidatorRegularExpression.password,  options: .caseInsensitive).firstMatch(in: value, options: [], range: NSRange(location: 0, length: value.count)) == nil {
                throw ValidationError("Password must be more than 8 characters, with at least one special character, one uppercase character and one numeric character")
            }
        } catch {
            throw ValidationError("Password must be more than 8 characters, with at least one special character, one uppercase character and one numeric character")
        }
        return value
    }
}
