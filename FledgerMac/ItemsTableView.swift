//
//  ItemsTableView.swift
//  FledgerMac
//
//  Created by Robert Conrad on 9/13/15.
//  Copyright (c) 2015 Robert Conrad. All rights reserved.
//

import Cocoa
import FledgerCommon


class ItemsTableView: NSTableView, NSTableViewDataSource, NSTableViewDelegate {

    var dataProvider: ItemsTableViewDataProvider?
    
    var selectRowHandler: ((Item?) -> Void)?
    
    override func reloadData() {
        if let provider = dataProvider {
            // we have to pull the entire amount of data that has been pulled through infinite scrolling so that the table can
            //  be scrolled to the same point the user left (e.g. when leaving to edit item #100 and returning)
            provider.getFilters().count = provider.getFilters().offset! + provider.getFilters().count!
            provider.getFilters().offset = 0
            provider.setItems(ItemSvc().select(provider.getFilters()))
        }
        
        super.reloadData()
    }
    
    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        return dataProvider?.getItems().map { items in items.count } ?? 0
    }
    
    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let cellType = ItemTableCellEnum.fromColumnStoryboardId(tableColumn!.identifier)
        let cell = makeViewWithIdentifier(cellType.storyboardId(), owner: self) as! ItemTableCellView
        
        dataProvider.map { cell.setup(self.reloadData, dataProvider: $0, row: row) }
        cell.setViewAttributes()
        
        return cell
    }
    
}

class ItemsTableViewDataProvider {
    
    private var items: [Item] = []
    private var sums = Dictionary<Int64, Double>()
    private let sumFactory: ((Item, Int, ItemFilters) -> Void)
    private let filters: ItemFilters
    
    required init(sumFactory: ((Item, Int, ItemFilters) -> Void), filters: ItemFilters) {
        self.sumFactory = sumFactory
        self.filters = filters
    }
    
    func setItem(item: Item, row: Int) {
        items[row] = item
    }
    
    func setItems(items: [Item]) {
        self.items = items
    }
    
    func getItems() -> [Item]? {
        return items
    }
    
    func getItem(row: Int) -> Item? {
        return items[row]
    }
    
    func setItemSum(id: Int64, _ sum: Double) {
        sums[id] = sum
    }
    
    func resetItemSums() {
        sums = [:]
    }
    
    func getItemSum(id: Int64) -> Double? {
        return sums[id]
    }
    
    func getFilters() -> ItemFilters {
        return filters
    }
    
    func enqueueSumRequest(row: Int) {
        if let item = getItem(row) {
            sumFactory(item, row, filters)
        }
    }
    
}