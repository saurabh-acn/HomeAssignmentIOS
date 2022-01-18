//
//  RoundButton.swift
//  HomeAssignmentIOS
//
//  Created by saurabh.a.rana on 14/01/22.
//

import UIKit

class RoundButton: UIButton {
    
    /// Variable used
    var selectedState: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.borderWidth = 3.0
        layer.borderColor = UIColor.black.cgColor
    }
    
    override func layoutSubviews(){
        super.layoutSubviews()
        layer.cornerRadius = frame.height / 2
        backgroundColor = selectedState ? UIColor.black : UIColor.white
        self.titleLabel?.textColor = selectedState ? UIColor.white : UIColor.black
    }
}
