//
//  AppDelegate.swift
//  FledgerMac
//
//  Created by Robert Conrad on 8/9/15.
//  Copyright (c) 2015 Robert Conrad. All rights reserved.
//

import Cocoa
import FledgerCommon


@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    var window: NSWindow?
    var storyboard: NSStoryboard?
    
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        
        window = NSApplication.sharedApplication().windows.first!
        storyboard = NSStoryboard(name: "Main", bundle: nil)
   
        ServiceBootstrap.preRegister()
        
        if (UserSvc().isLoggedIn()) {
            ServiceBootstrap.register()
            showMainTabView()
        }
        else {
            showLoginView()
        }
        
    }
	
    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }
    
    func showMainTabView() {
        let mainTabController = storyboard?.instantiateControllerWithIdentifier("mainTabViewController") as! MainTabViewController
        
        window?.contentViewController = mainTabController
        window?.contentView = mainTabController.view
    }
    
    func showLoginView() {
        let loginController = storyboard?.instantiateControllerWithIdentifier("loginViewController") as! LoginViewController
        
        loginController.loginHandler = { valid in
            if valid {
                self.showMainTabView()
            }
        }
        
        window?.contentViewController = loginController
        window?.contentView = loginController.view
        window?.makeFirstResponder(loginController.email)
    }

    @IBAction func logout(sender: AnyObject) {
        UserSvc().logout()
        showLoginView()
    }
    
    override func validateMenuItem(menuItem: NSMenuItem) -> Bool {
        if let item = menuItem as? AppMenuItem {
            return item.isValid()
        }
        return true
    }
    
}