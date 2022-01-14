//
//  TextInput.swift
//  HomeAssignmentIOS
//
//  Created by saurabh.a.rana on 13/01/22.
//

import UIKit

class TextInput: UITextField {

    @IBOutlet weak var textInputBorderView: UIView!
    @IBOutlet weak var placeHolderLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    /// TextInput XIB name
    private let nibName = "TextInput"
    
     /*Intialzies the control by deserializing it
     - parameter aDecoder the object to deserialize the control from
     */
    public required init?(coder aDecoder: NSCoder) {
        // For use in Interface Builder
        super.init(coder: aDecoder)
        self.loadSubview()
        self.defaultSettings()
    }
    public func loadSubview() {
        guard let view = loadViewFromNib() else { return }
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view)
    }
    /// Load view from XIB - return view
    private func loadViewFromNib() -> UIView? {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }

    /// Load view from XIB - return view
    private func defaultSettings() {
        errorLabel.isHidden = true
        textInputBorderView.addViewBorder(borderColor: UIColor.black.cgColor,
                                          borderWith: 1.5,
                                          borderCornerRadius: 1.0)
    }
}

extension UIView {
    public func addViewBorder(borderColor: CGColor,
                              borderWith: CGFloat,
                              borderCornerRadius: CGFloat) {
        self.layer.borderWidth = borderWith
        self.layer.borderColor = borderColor
        self.layer.cornerRadius = borderCornerRadius
        
    }
}
