//
//  LoginViewController.swift
//  FledgerMac
//
//  Created by Robert Conrad on 8/16/15.
//  Copyright (c) 2015 Robert Conrad. All rights reserved.
//

import Cocoa
import FledgerCommon


class LoginViewController: NSViewController {
    
    lazy var helper: LoginViewHelper = {
        return LoginViewHelper(self, self)
    }()
    
    var loginHandler: ((Bool) -> ())?
    
    @IBOutlet weak var email: NSTextField!
    @IBOutlet weak var emailLabel: NSTextField!
    @IBOutlet weak var password: NSSecureTextField!
    @IBOutlet weak var passwordLabel: NSTextField!
    @IBOutlet weak var loginButton: NSButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        helper.loginFromCache()
        loginButton.keyEquivalent = "\r"
    }
    
    @IBAction func login(sender: AnyObject) {
        helper.login()
    }
    
    @IBAction func signup(sender: AnyObject) {
        helper.signup()
    }

}

extension LoginViewController: LoginViewHelperDataSource {
    
    func getEmail() -> String {
        return email.stringValue
    }
    
    func getPassword() -> String {
        return password.stringValue
    }
    
}

extension LoginViewController: LoginViewHelperDelegate {
    
    func notifyEmailValidity(valid: Bool) {
        emailLabel.textColor = valid ? AppColors.text() : AppColors.textError()
    }
    
    func notifyPasswordValidity(valid: Bool) {
        passwordLabel.textColor = valid ? AppColors.text() : AppColors.textError()
    }
    
    func notifyLoginResult(valid: Bool) {
        notifyEmailValidity(valid)
        notifyPasswordValidity(valid)
        loginHandler?(valid)
    }
    
}