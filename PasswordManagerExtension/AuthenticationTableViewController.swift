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
    
    var hasPasswordManagerInstalled = OnePasswordExtension.shared().isAppExtensionAvailable()
    
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
            
            if hasPasswordManagerInstalled {
                cell.button.isHidden = false
                cell.button.setTitle(nil, for: .normal)
                cell.button.setImage(#imageLiteral(resourceName: "onepassword-button"), for: .normal)
            }
            
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
    
    func buttonTapped(on cell: AuthenticationTableViewCell) {
        view.endEditing(true)
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        
        if indexPath.row == 1 {
            switch viewMode {
            case .login:
                OnePasswordExtension.shared().findLogin(forURLString: "www.myappurl.com", for: self, sender: cell.button, completion: { (loginDictionary: [AnyHashable : Any]?, error: Error?) in
                    
                    let errorCode = Int32((error as NSError?)?.code ?? 0)
                    
                    if loginDictionary?.count == 0 && errorCode != AppExtensionErrorCodeCancelledByUser {
                        print("Error invoking 1Password App Extension for find login: " + String(describing: error?.localizedDescription))
                    } else {
                        self.email = loginDictionary?[AppExtensionUsernameKey] as? String ?? ""
                        self.password = loginDictionary?[AppExtensionPasswordKey] as? String ?? ""
                        self.tableView.reloadData()
                    }
                })
            case .signup:
                let newLoginDetails = [AppExtensionTitleKey: "MyApp",
                                       AppExtensionUsernameKey: self.email,
                                       AppExtensionPasswordKey: self.password,
                                       AppExtensionNotesKey: "Saved with MyApp."]
                
                //optional
                
                let passwordGenerationOptions: [String: Any] = [AppExtensionGeneratedPasswordMinLengthKey: NSNumber(integerLiteral: 8),
                                                                AppExtensionGeneratedPasswordMaxLengthKey: NSNumber(integerLiteral: 30),
                                                                AppExtensionGeneratedPasswordRequireDigitsKey: true,
                                                                AppExtensionGeneratedPasswordRequireSymbolsKey: false,
                                                                AppExtensionGeneratedPasswordForbiddenCharactersKey: "!@#$%/0lIO"]
                
                //</optional>
                
                OnePasswordExtension.shared().storeLogin(forURLString: "www.myappurl.com", loginDetails: newLoginDetails, passwordGenerationOptions: passwordGenerationOptions, for: self, sender: cell.button, completion: { (loginDictionary: [AnyHashable : Any]?, error: Error?) in
                    let errorCode = Int32((error as NSError?)?.code ?? 0)
                    if loginDictionary?.count == 0 && errorCode != AppExtensionErrorCodeCancelledByUser {
                        print("Error invoking 1Password App Extension for find login: " + String(describing: error?.localizedDescription))
                    } else {
                        self.email = loginDictionary?[AppExtensionUsernameKey] as? String ?? ""
                        self.password = loginDictionary?[AppExtensionPasswordKey] as? String ?? ""
                        self.confirmPassword = loginDictionary?[AppExtensionPasswordKey] as? String ?? ""
                        self.tableView.reloadData()
                    }
                })
            }
        }
    }
    
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

