//
//  Utilities.swift
//  HomeAssignmentIOS
//
//  Created by saurabh.a.rana on 15/01/22.
//

import Foundation
import UIKit
import Security

class Utilities {
    class func saveCredentials(username: String, password: String) {
        // Set username and password
        let username = username
        let password = password.data(using: .utf8)!
        
        // Set attributes
        let attributes: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: username,
            kSecValueData as String: password,
        ]
        
        // Add user
        if SecItemAdd(attributes as CFDictionary, nil) == noErr {
            debugPrint("User saved successfully in the keychain")
        } else {
            debugPrint("Something went wrong trying to save the user in the keychain")
        }
    }
    
    class func updateCredentials(username: String, password: String) {
        let newPassword = password.data(using: .utf8)!
        
        // Set query
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: username,
        ]
        
        // Set attributes for the new password
        let attributes: [String: Any] = [kSecValueData as String: newPassword]
        
        // Find user and update
        if SecItemUpdate(query as CFDictionary, attributes as CFDictionary) == noErr {
            print("Password has changed")
        } else {
            print("Something went wrong trying to update the password")
        }
    }
    
    class func retrieveCredentials(username: String) -> String? {
        // Set query
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: username,
            kSecMatchLimit as String: kSecMatchLimitOne,
            kSecReturnAttributes as String: true,
            kSecReturnData as String: true,
        ]
        var item: CFTypeRef?
        
        // Check if user exists in the keychain
        if SecItemCopyMatching(query as CFDictionary, &item) == noErr {
            // Extract result
            if let existingItem = item as? [String: Any],
               let username = existingItem[kSecAttrAccount as String] as? String,
               let passwordData = existingItem[kSecValueData as String] as? Data,
               let password = String(data: passwordData, encoding: .utf8)
            {
                print(username)
//                print(password)
                return password
            }
        } else {
            print("Something went wrong trying to find the user in the keychain")
        }
        return nil
    }
    
    class func deleteCredentials(username: String) {
        // Set query
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: username,
        ]
        
        // Find user and delete
        if SecItemDelete(query as CFDictionary) == noErr {
            print("User removed successfully from the keychain")
        } else {
            print("Something went wrong trying to remove the user from the keychain")
        }
    }
}
