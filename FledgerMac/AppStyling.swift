//
//  AppStyling.swift
//  fledger-ios
//
//  Created by Robert Conrad on 4/25/15.
//  Copyright (c) 2015 Robert Conrad. All rights reserved.
//

import Cocoa


class AppStyling {
    
    enum Mode: Int {
        case Light = 0
        case Dark = 1
    }
    
    private static let modeKey = "appStylingMode"
    
    static func set(mode: Mode) {
        NSUserDefaults.standardUserDefaults().setInteger(mode.rawValue, forKey: modeKey)
    }
    
    static func get() -> Mode {
        return Mode(rawValue: NSUserDefaults.standardUserDefaults().integerForKey(modeKey))!
    }
    
}