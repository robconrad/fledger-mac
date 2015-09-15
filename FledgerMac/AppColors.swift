//
//  AppColors.swift
//  FledgerMac
//
//  Created by Robert Conrad on 8/16/15.
//  Copyright (c) 2015 Robert Conrad. All rights reserved.
//

import Cocoa


class AppColors {
    
    enum Token {
        case bgMain
        case bgHighlightTransient
        case bgHighlight
        case bgHeader
        case bgHeaderHighlight
        case bgError
        case text
        case textError
        case textErrorWithBg
    }
    
    // favorite blue: NSColor(red: 13/255, green: 138/255, blue: 245/255, alpha: 1)
    
    private static let darkColors: [Token: NSColor] = [
        Token.bgMain: NSColor.blackColor(),
        Token.bgHighlightTransient: NSColor(red: 75/255, green: 75/255, blue: 75/255, alpha: 1),
        Token.bgHighlight: NSColor(red: 50/255, green: 50/255, blue: 50/255, alpha: 1),
        Token.bgHeader: NSColor(red: 25/255, green: 25/255, blue: 25/255, alpha: 1),
        Token.bgHeaderHighlight: NSColor(red: 40/255, green: 40/255, blue: 40/255, alpha: 1),
        Token.bgError: NSColor.redColor(),
        Token.text: NSColor.whiteColor(),
        Token.textError: NSColor.redColor(),
        Token.textErrorWithBg: NSColor.whiteColor()
    ]
    
    private static let lightColors: [Token: NSColor] = [
        Token.bgMain: NSColor.whiteColor(),
        Token.bgHighlightTransient: NSColor(red: 180/255, green: 180/255, blue: 180/255, alpha: 1),
        Token.bgHighlight: NSColor(red: 205/255, green: 205/255, blue: 205/255, alpha: 1),
        Token.bgHeader: NSColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1),
        Token.bgHeaderHighlight: NSColor(red: 215/255, green: 215/255, blue: 215/255, alpha: 1),
        Token.bgError: NSColor.redColor(),
        Token.text: NSColor.blackColor(),
        Token.textError: NSColor.redColor(),
        Token.textErrorWithBg: NSColor.whiteColor()
    ]
    
    private static func get(token: Token) -> NSColor {
        switch AppStyling.get() {
        case .Light: return lightColors[token]!
        case .Dark: return darkColors[token]!
        }
    }
    
    static func bgMain() -> NSColor { return get(Token.bgMain) }
    static func bgHighlightTransient() -> NSColor { return get(Token.bgHighlightTransient) }
    static func bgHighlight() -> NSColor { return get(Token.bgHighlight) }
    static func bgSelected() -> NSColor { return get(Token.bgHighlightTransient) }
    static func bgHeader() -> NSColor { return get(Token.bgHeader) }
    static func bgHeaderHighlight() -> NSColor { return get(Token.bgHeaderHighlight) }
    static func bgError() -> NSColor { return get(Token.bgError) }
    
    static func text() -> NSColor { return get(Token.text) }
    static func textWeak() -> NSColor { return AppColors.bgHeader() }
    static func textError() -> NSColor { return get(Token.textError) }
    static func textErrorWithBg() -> NSColor { return get(Token.textErrorWithBg) }
    
}