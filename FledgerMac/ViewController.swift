//
//  ViewController.swift
//  FledgerMac
//
//  Created by Robert Conrad on 8/9/15.
//  Copyright (c) 2015 Robert Conrad. All rights reserved.
//

import Cocoa
import FledgerCommon

class ViewController: NSViewController {

    @IBOutlet weak var label: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        label.stringValue = Util.getNames()
        
        // Do any additional setup after loading the view.
    }

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

