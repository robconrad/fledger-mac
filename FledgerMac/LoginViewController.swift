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
    
    @IBOutlet weak var email: NSTextField!
    @IBOutlet weak var emailLabel: NSTextField!
    @IBOutlet weak var password: NSSecureTextField!
    @IBOutlet weak var passwordLabel: NSTextField!
    
    @IBOutlet weak var status: NSTextField!
    
    override func viewDidLoad() {
        ServiceBootstrap.preRegister()
        helper.loginFromCache()
        super.viewDidLoad()
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
        emailLabel.textColor = valid ? NSColor.blackColor() : NSColor.redColor()
    }
    
    func notifyPasswordValidity(valid: Bool) {
        passwordLabel.textColor = valid ? NSColor.blackColor() : NSColor.redColor()
    }
    
    func notifyLoginResult(valid: Bool) {
        notifyEmailValidity(valid)
        notifyPasswordValidity(valid)
        status.stringValue = valid ? "success!" : "failure :("
    }
    
}