//
//  UIViewController+Extensions.swift
//  HomeAssignmentIOS
//
//  Created by saurabh.a.rana on 15/01/22.
//

import UIKit

extension UIViewController {
    func addBackButton() {
        let backButton = UIButton(type: .custom)
        backButton.setImage(UIImage(named: Constants.backButtonImage),
                            for: .normal)
        backButton.setTitleColor(.white,
                                 for: .normal)
        backButton.frame = CGRect(x: 0,
                                  y: 0,
                                  width: 30,
                                  height: 30)
        backButton.addTarget(self,
                             action: #selector (backButtonClick(sender:)),
                             for: .touchUpInside)
        backButton.backgroundColor = .clear
        
        let view = UIView(frame: CGRect(x: 0,
                                        y: 0,
                                        width: 80,
                                        height: 30))
        view.bounds = view.bounds.offsetBy(dx: -5,
                                           dy: 0)
        view.addSubview(backButton)
        let backButtonView = UIBarButtonItem(customView: view)
        view.backgroundColor = .clear
        navigationItem.leftBarButtonItem = backButtonView
    }
    
    @objc func backButtonClick(sender : UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func addLogoutButton() {
        let backButton = UIButton(type: .custom)
        backButton.setTitle(Constants.logout,
                            for: .normal)
        backButton.titleLabel?.font = UIFont.systemFont(ofSize: 15,
                                                        weight: .bold)
        backButton.setTitleColor(.black,
                                 for: .normal)
        backButton.frame = CGRect(x: 0,
                                  y: 0,
                                  width: 70,
                                  height: 30)
        backButton.addTarget(self,
                             action: #selector(logOut(sender:)),
                             for: UIControl.Event.touchUpInside)
        backButton.backgroundColor = .clear
        
        let view = UIView(frame: CGRect(x: 0,
                                        y: 0,
                                        width: 80,
                                        height: 30))
        view.bounds = view.bounds.offsetBy(dx: -5,
                                           dy: 0)
        view.addSubview(backButton)
        let backButtonView = UIBarButtonItem(customView: view)
        view.backgroundColor = .clear
        navigationItem.rightBarButtonItem = backButtonView
    }
    
    @objc func logOut(sender : UIButton) {
        KeychainService.logOut()
        self.navigationController?.popViewController(animated: true)
    }
}

extension UIView {
    func dropShadow() {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 2, height: 3)
        layer.masksToBounds = false
        
        layer.shadowOpacity = 0.3
        layer.shadowRadius = 3
        layer.rasterizationScale = UIScreen.main.scale
        layer.shouldRasterize = true
    }
}

extension Formatter {
    static let withSeparator: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = ","
        return formatter
    }()
}

extension Numeric {
    var formattedWithSeparator: String { Formatter.withSeparator.string(for: self) ?? "" }
}

extension UIViewController {
    func popupAlert(title: String?,
                    message: String?,
                    actionTitles:[String?],
                    actions:[((UIAlertAction) -> Void)?]) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        for (index, title) in actionTitles.enumerated() {
            let action = UIAlertAction(title: title,
                                       style: .default,
                                       handler: actions[index])
            alert.addAction(action)
        }
        self.present(alert,
                     animated: true,
                     completion: nil)
    }
}
