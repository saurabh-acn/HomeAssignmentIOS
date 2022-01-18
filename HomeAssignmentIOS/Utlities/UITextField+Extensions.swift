//
//  UITextField+Extensions.swift
//  HomeAssignmentIOS
//
//  Created by saurabh.a.rana on 15/01/22.
//

import UIKit

extension UITextField {
    
    /// Function to validate according to type given
    /// - Parameter validationType: ValidatorType
    /// - Returns: Error string
    func validatedText(validationType: ValidatorType) throws -> String {
        let validator = VaildatorFactory.validatorFor(type: validationType)
        return try validator.validated(self.text!)
    }
    
    /// Function to add image in textfield to left side
    /// - Parameter imageName: <#imageName description#>
    func setLeftImage(imageName:String) {
        let imageView = UIImageView(frame: CGRect(x: 0,
                                                  y: 0,
                                                  width: 10,
                                                  height: 10))
        imageView.image = UIImage(named: imageName)
        self.rightView = imageView
        self.rightViewMode = .always
    }
}
