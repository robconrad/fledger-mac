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
    
    static let currencyFormatter: NSNumberFormatter = {
        let f = NSNumberFormatter()
        f.numberStyle = .CurrencyStyle
        f.locale = NSLocale(localeIdentifier: "en_US")
        return f
    }()

    var items: [Item]?
    var itemSums = Dictionary<Int64, Double>()
    
    lazy var itemFilters = ItemSvc().getFiltersFromDefaults()
    
    var itemSumOperationFactory: ((Item, Int, ItemFilters) -> Void)?
    var selectRowHandler: ((Item?) -> Void)?
    
    private let dateFormat: NSDateFormatter = {
        let df = NSDateFormatter()
        df.dateFormat = "YYYY-MM-dd"
        return df
        }()
    
    override func reloadData() {
        // we have to pull the entire amount of data that has been pulled through infinite scrolling so that the table can
        //  be scrolled to the same point the user left (e.g. when leaving to edit item #100 and returning)
        itemFilters.count = itemFilters.offset! + itemFilters.count!
        itemFilters.offset = 0
        items = ItemSvc().select(itemFilters)
        
        super.reloadData()
    }
    
    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        return items.map { items in items.count } ?? 0
    }
    
    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let cellType = ItemsTableCellEnum.fromColumnStoryboardId(tableColumn!.identifier)
        let cell = makeViewWithIdentifier(cellType.storyboardId(), owner: self) as! NSTableCellView
        
        if let i = items {
            let item = i[row]
            
            cell.textField?.stringValue = { _ in
                switch cellType {
                case .id: return "\(item.id!)"
                case .account: return item.account().name
                case .date: return self.dateFormat.stringFromDate(i[row].date)
                case .comments: return item.comments.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
                case .type: return item.type().name
                case .debit: return item.amount < 0 ? ItemsTableView.currencyFormatter.stringFromNumber(-item.amount)! : ""
                case .credit: return item.amount > 0 ? ItemsTableView.currencyFormatter.stringFromNumber(item.amount)! : ""
                case .subtotal:
                    if let sum = self.itemSums[item.id!] {
                        return ItemsTableView.currencyFormatter.stringFromNumber(sum)!
                    }
                    else {
                        self.itemSumOperationFactory?(item, row, self.itemFilters)
                        return "-"
                    }
                }
            }()
        }
        
        return cell
    }
    
}