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
        
        window = NSApplication.sharedApplication().windows.first as? NSWindow
        storyboard = NSStoryboard(name: "Main", bundle: nil)
   
        ServiceBootstrap.preRegister()
        
        if (ParseSvc().isLoggedIn()) {
            ServiceBootstrap.register()
        }
        else {
            showLoginSheet()
        }
        
    }
	
    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }
    
    func showLoginSheet() {
        
        let loginController = storyboard?.instantiateControllerWithIdentifier("loginViewController") as! LoginViewController
        let loginSheet = NSPanel(contentViewController: loginController)
        
        loginController.loginHandler = { valid in
            if valid {
                self.window?.endSheet(loginSheet, returnCode: NSModalResponseStop)
            }
        }
        
        window?.beginSheet(loginSheet, completionHandler: { (response) -> Void in })
        
    }

    @IBAction func logout(sender: AnyObject) {
        ParseSvc().logout()
        showLoginSheet()
    }
    
}