//
//  CustomErrorView.swift
//  HomeAssignmentIOS
//
//  Created by saurabh.a.rana on 17/01/22.
//

import Foundation
import UIKit

class CustomErrorView: UIView {
    
    @IBOutlet private weak var backgroundView: UIView!
    @IBOutlet private weak var errorLabel: UILabel!
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    /// TextInput XIB name
    private let nibName = Constants.customErrorView
    
    var errorString: String? {
        didSet {
            if let error = errorString {
                self.isHidden = false
                errorLabel.text = error
            } else {
                self.isHidden = true
            }
        }
    }
    
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
        view.autoresizingMask = [.flexibleWidth,
                                 .flexibleHeight]
        self.addSubview(view)
    }
    
    /// Load view from XIB - return view
    private func loadViewFromNib() -> UIView? {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName,
                        bundle: bundle)
        return nib.instantiate(withOwner: self,
                               options: nil).first as? UIView
    }
    
    /// Load view from XIB - return view
    private func defaultSettings() {
        backgroundView.addViewBorder(borderColor: UIColor.red.cgColor,
                                     borderWith: 1.2,
                                     borderCornerRadius: 12.0)
    }
}
