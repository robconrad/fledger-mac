//
//  LogoutMenuItem.swift
//  FledgerMac
//
//  Created by Robert Conrad on 9/13/15.
//  Copyright (c) 2015 Robert Conrad. All rights reserved.
//

import Cocoa
import FledgerCommon


class LogoutMenuItem: AppMenuItem {
    
    override func isValid() -> Bool {
        return UserSvc().isLoggedIn()
    }
    
}
