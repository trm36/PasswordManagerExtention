//
//  ViewController.swift
//  PasswordManagerExtension
//
//  Created by Taylor Mott on 26-Apr-17.
//  Copyright © 2017 Mott Applications. All rights reserved.
//

import UIKit

class AuthenticationTableViewController: UITableViewController, AuthenticationTableViewCellDelegate {
    
    enum ViewMode {
        case login
        case signup
    }

    var viewMode = ViewMode.login
    
    @IBOutlet weak var modeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var actionBarButtonItem: UIBarButtonItem!
    
    var email = ""
    var password = ""
    var confirmPassword = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table View Data Source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch viewMode {
        case .login:
            return 2
        case .signup:
            return 3
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: AuthenticationTableViewCell.identifier, for: indexPath) as! AuthenticationTableViewCell
        cell.button.isHidden = true
        cell.delegate = self
        cell.selectionStyle = .none

        switch indexPath.row {
        case 0:
            cell.textField.placeholder = "email"
            cell.textField.text = email
            cell.textField.isSecureTextEntry = false
        case 1:
            cell.textField.placeholder = "password"
            cell.textField.text = password
            cell.textField.isSecureTextEntry = true
        case 2:
            cell.textField.placeholder = "confirm password"
            cell.textField.text = confirmPassword
            cell.textField.isSecureTextEntry = true
        default:
            break
        }
        
        return cell
    }
    
    // MARK: - Segmented Control Methods

    @IBAction func modeSegmentedControlValueChanged() {
        let indexPathOfConfirmCell = IndexPath(row: 2, section: 0)
        
        view.endEditing(true)
        
        if viewMode == .login {
            viewMode = .signup
            actionBarButtonItem.title = "Sign Up"
            tableView.insertRows(at: [indexPathOfConfirmCell], with: .fade)
        } else {
            viewMode = .login
            actionBarButtonItem.title = "Log In"
            tableView.deleteRows(at: [indexPathOfConfirmCell], with: .fade)
        }
    }
    
    // MARK: - Authentication Table View Cell Delegate
    
    func buttonTapped(on cell: AuthenticationTableViewCell) {}
    
    func textFieldDidFinishEditing(on cell: AuthenticationTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        
        switch indexPath.row {
        case 0:
            email = cell.textField.text ?? ""
        case 1:
            password = cell.textField.text ?? ""
        case 2:
            confirmPassword = cell.textField.text ?? ""
        default:
            break
        }
    }
    
    // MARK: - Bar Button Methods
    
    @IBAction func actionButtonTapped() {
        switch viewMode {
        case .login:
            print("Log In")
        case .signup:
            print("Sign Up")
        }
    }

}

