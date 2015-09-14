//
//  ItemsViewController.swift
//  FledgerMac
//
//  Created by Robert Conrad on 8/16/15.
//  Copyright (c) 2015 Robert Conrad. All rights reserved.
//

import Cocoa
import FledgerCommon


class ItemsViewController: NSViewController {
    
    @IBOutlet weak var table: ItemsTableView!
    
    var itemFilters: ItemFilters?
    var isSearchable = true
    
    private var syncListener: ParseSyncListener?
    
    private let dataQueue: NSOperationQueue = {
        var q = NSOperationQueue()
        q.name = "Items View Sum Background/Data Queue"
        q.maxConcurrentOperationCount = 5
        return q
    }()
    
    private let uiQueue: NSOperationQueue = {
        var q = NSOperationQueue()
        q.name = "Items View Sum Foreground/UI Queue"
        q.maxConcurrentOperationCount = 1
        return q
    }()
    
    deinit {
        if let listener = syncListener {
            ParseSvc().ungregisterSyncListener(listener)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        table.itemSumOperationFactory = { item, row, itemFilters in
            self.dataQueue.addOperation(ItemSumOperation(item: item, controller: self, row: row, filters: itemFilters))
        }
     
        if let filters = itemFilters {
            table.itemFilters = filters
        }
        table.itemFilters.count = 30
        table.itemFilters.offset = 0
        
        let listener = ParseSyncListener { syncType in
            if syncType == .From {
                dispatch_sync(dispatch_get_main_queue()) {
                    self.table.reloadData()
                }
            }
        }
        ParseSvc().registerSyncListener(listener)
        syncListener = listener
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        
        table.setDelegate(table)
        table.setDataSource(table)
        
        // when the view is appearing we reload data because it could have been changed
        table.reloadData()
    }
    
    override func viewWillDisappear() {
        super.viewWillDisappear()
        uiQueue.cancelAllOperations()
        dataQueue.cancelAllOperations()
        table.itemSums = [:]
    }
    
}

class ItemSumOperation: NSOperation {
    
    let item: Item
    let controller: ItemsViewController
    let row: Int
    let filters: ItemFilters
    
    init(item: Item, controller: ItemsViewController, row: Int, filters: ItemFilters) {
        self.item = item
        self.controller = controller
        self.row = row
        self.filters = filters
    }
    
    override func main() {
        if self.cancelled {
            return
        }
        
        if controller.table.itemSums[item.id!] == nil {
            controller.table.itemSums[item.id!] = ItemSvc().getSum(item, filters: filters)
        }
        else {
            return
        }
        
        if self.cancelled {
            return
        }
        
        if controller.uiQueue.operationCount == 0 {
            controller.uiQueue.addOperation(ReloadTableOperation(controller: controller))
        }
    }
    
}

class ReloadTableOperation: NSOperation {
    
    let controller: ItemsViewController
    
    init(controller: ItemsViewController) {
        self.controller = controller
    }
    
    override func main() {
        if self.cancelled {
            return
        }
        
        dispatch_sync(dispatch_get_main_queue()) {
            self.controller.table.reloadData()
        }
    }
    
}
