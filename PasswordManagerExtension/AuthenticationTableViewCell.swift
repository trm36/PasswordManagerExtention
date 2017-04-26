//
//  AuthenticationTableViewCell.swift
//  PasswordManagerExtension
//
//  Created by Taylor Mott on 26-Apr-17.
//  Copyright © 2017 Mott Applications. All rights reserved.
//

import UIKit

protocol AuthenticationTableViewCellDelegate: class {
    func buttonTapped(on cell: AuthenticationTableViewCell)
    func textFieldDidFinishEditing(on cell: AuthenticationTableViewCell)
}

class AuthenticationTableViewCell: UITableViewCell, UITextFieldDelegate {
    
    static var identifier = "AuthenticationCell"
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var borderView: UIView!
    @IBOutlet weak var button: UIButton!
    
    weak var delegate: AuthenticationTableViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        textField.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func buttonTapped() {
        self.delegate?.buttonTapped(on: self)
    }
    
    // MARK: - Text Field Delegate
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        self.delegate?.textFieldDidFinishEditing(on: self)
    }
}
