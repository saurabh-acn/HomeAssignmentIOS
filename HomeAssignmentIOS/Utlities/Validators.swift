import Foundation

class ValidationError: Error {
    var message: String
    
    init(_ message: String) {
        self.message = message
    }
}

protocol ValidatorConvertible {
    func validated(_ value: String) throws -> String
}

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

enum ValidatorRegularExpression {
    static let password = "^(?=.*[0-9!@#$%^&*])(?=.*[A-Z])(?=.*[a-z])[a-zA-Z0-9!@#$%^&*]{8,}$"
    static let email = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}$"
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

extension String {
    func hasAlphaNumeric() -> Bool {
        return true
    }
    
    func hasOnlyNumbers() -> Bool {
        return !isEmpty && range(of: "[^0-9]", options: .regularExpression) == nil
    }
    
    func hasOnlyAlphabets() -> Bool {
        return !isEmpty && range(of: "[^a-zA-Z]", options: .regularExpression) == nil
    }
    
    func validatedText(validationType: ValidatorType) throws -> String {
        let validator = VaildatorFactory.validatorFor(type: validationType)
        return try validator.validated(self)
    }
}
