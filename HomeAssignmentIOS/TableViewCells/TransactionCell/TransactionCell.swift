//
//  TransactionCell.swift
//  HomeAssignmentIOS
//
//  Created by Saurabh Rana on 14/01/22.
//

import UIKit

class TransactionCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    
    /// To set name title.
    public var name: String? {
        didSet {
            nameLabel.isHidden = name == nil ? true : false
            nameLabel.text = nameLabel.isHidden ? "" : name
        }
    }
    
    /// To set amount
    public var amount: String? {
        didSet {
            amountLabel.isHidden = amount == nil ? true : false
            amountLabel.text = amountLabel.isHidden ? "" : amount
        }
    }
    
    /// To change lable font color
    public var amountTextColor: Bool = false {
        didSet {
            if amountTextColor { amountLabel.textColor = UIColor(named: Constants.transactionAmountColor) } else {
                amountLabel.textColor = .gray
            }
        }
    }
    
    /// To set id
    public var transactionId: String? {
        didSet {
            idLabel.isHidden = transactionId == nil ? true : false
            idLabel.text = idLabel.isHidden ? "" : transactionId
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        nameLabel.isHidden = true
        amountLabel.isHidden = true
        idLabel.isHidden = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
