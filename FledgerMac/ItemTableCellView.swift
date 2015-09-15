//
//  ItemsTableCellViews.swift
//  FledgerMac
//
//  Created by Robert Conrad on 9/15/15.
//  Copyright (c) 2015 Robert Conrad. All rights reserved.
//

import Cocoa
import FledgerCommon


class ItemTableCellView: NSTableCellView, NSTextFieldDelegate {
    
    private var reloadData: () -> () = { _ in }
    private var dataProvider: ItemsTableViewDataProvider?
    private var row: Int?
    
    private var bgColor: NSColor?
    
    static let currencyFormatter: NSNumberFormatter = {
        let f = NSNumberFormatter()
        f.numberStyle = .CurrencyStyle
        f.locale = NSLocale(localeIdentifier: "en_US")
        return f
    }()
    
    static let dateFormat: NSDateFormatter = {
        let df = NSDateFormatter()
        df.dateFormat = "YYYY-MM-dd"
        return df
    }()
    
    func setup(reloadData: () -> (), dataProvider: ItemsTableViewDataProvider, row: Int) {
        self.reloadData = reloadData
        self.dataProvider = dataProvider
        self.row = row
    }
    
    func getItem() -> Item? {
        return row.flatMap { dataProvider?.getItem($0) }
    }
    
    func isEditable() -> Bool {
        return true
    }
    
    func isEdited() -> Bool {
        return getStringValue() == getDefaultStringValue()
    }
    
    func isEditValid() -> Bool {
        return false
    }
    
    func applyEditToItem(item: Item) -> Item {
        // update the item's appropriate field to the edited value
        return item
    }
    
    func getStringValue() -> String {
        return textField?.stringValue ?? ""
    }
    
    func getDefaultStringValue() -> String {
        return ""
    }
    
    func setViewAttributes() {
        textField?.stringValue = getDefaultStringValue()
        textField?.editable = isEditable()
        textField?.delegate = self
    }
    
    override func drawRect(dirtyRect: NSRect) {
        if let color = bgColor {
            color.set()
        }
        else {
            NSColor.clearColor().set()
        }
        NSRectFill(bounds)
    }
    
    func setViewValidityStyle(valid: Bool) {
        bgColor = valid ? nil : AppColors.bgError()
        needsDisplay = true
    }
    
    override func controlTextDidEndEditing(obj: NSNotification) {
        // if no change occurred, leave it alone
        if isEdited() {
            setViewValidityStyle(true)
            return
        }
        
        // invalid edits draw angry background
        if !isEditValid() {
            setViewValidityStyle(false)
            return
        }
        
        // valid edits return the cell to valid styles
        setViewValidityStyle(true)
        
        if let provider = dataProvider, r = row, item = getItem() {
            let updatedItem = applyEditToItem(item)
            if ItemSvc().update(updatedItem) {
                provider.setItem(updatedItem, row: r)
                updateComplete()
            }
        }
    }
    
    func updateComplete() {
        // do nothing usually
    }
    
}

class IdItemTableCellView: ItemTableCellView {
    
    override func isEditable() -> Bool {
        return false
    }
    
    override func getDefaultStringValue() -> String {
        return getItem().map {"\($0.id!)"} ?? ""
    }
    
}

class AccountItemTableCellView: ItemTableCellView {
    
    private var account: Account?
    
    override func isEditValid() -> Bool {
        account = AccountSvc().withName(getStringValue())
        return account != nil
    }
    
    override func applyEditToItem(item: Item) -> Item {
        if let accountId = account?.id {
            return item.copy(accountId: accountId)
        }
        else {
            return item
        }
    }
    
    override func getDefaultStringValue() -> String {
        return getItem().map { $0.account().name } ?? ""
    }
    
}

class DateItemTableCellView: ItemTableCellView {
    
    func getDate() -> NSDate? {
        return ItemTableCellView.dateFormat.dateFromString(getStringValue())
    }
    
    override func isEditValid() -> Bool {
        return getDate() != nil
    }
    
    override func applyEditToItem(item: Item) -> Item {
        return item.copy(date: getDate())
    }
    
    override func getDefaultStringValue() -> String {
        return getItem().map { ItemTableCellView.dateFormat.stringFromDate($0.date) } ?? ""
    }
    
    override func updateComplete() {
        reloadData()
    }
    
}

class CommentsItemTableCellView: ItemTableCellView {
    
    override func isEditValid() -> Bool {
        return count(getStringValue()) > 0
    }
    
    override func applyEditToItem(item: Item) -> Item {
        return item.copy(comments: getStringValue())
    }
    
    override func getDefaultStringValue() -> String {
        return getItem().map { item in
            item.comments.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        } ?? ""
    }
    
}

class TypeItemTableCellView: ItemTableCellView {
    
    private var type: Type?
    
    override func isEditValid() -> Bool {
        type = TypeSvc().withName(getStringValue())
        return type != nil
    }
    
    override func applyEditToItem(item: Item) -> Item {
        if let typeId = type?.id {
            return item.copy(typeId: typeId)
        }
        else {
            return item
        }
    }
    
    override func getDefaultStringValue() -> String {
        return getItem().map { $0.type().name } ?? ""
    }
    
}

class CurrencyItemTableCellView: ItemTableCellView {
    
    func getAmount(string: String) -> Double? {
        return ItemTableCellView.currencyFormatter.numberFromString(string) as Double?
    }
    
    func getAmount() -> Double? {
        return getAmount(getStringValue())
    }
    
    override func isEdited() -> Bool {
        return getAmount() == getAmount(getDefaultStringValue())
    }
    
    override func isEditValid() -> Bool {
        return getAmount() > 0
    }
    
    override func updateComplete() {
        dataProvider?.resetItemSums()
        reloadData()
    }
    
}

class DebitItemTableCellView: CurrencyItemTableCellView {
    
    override func getDefaultStringValue() -> String {
        return getItem().map { $0.amount < 0 ? ItemTableCellView.currencyFormatter.stringFromNumber(-$0.amount)! : "" } ?? ""
    }
    
    override func applyEditToItem(item: Item) -> Item {
        if let amount = getAmount() {
            return item.copy(amount: -amount)
        }
        else {
            return item
        }
    }
    
}

class CreditItemTableCellView: CurrencyItemTableCellView {
    
    override func getDefaultStringValue() -> String {
        return getItem().map { $0.amount > 0 ? ItemTableCellView.currencyFormatter.stringFromNumber($0.amount)! : "" } ?? ""
    }
    
    override func applyEditToItem(item: Item) -> Item {
        if let amount = getAmount() {
            return item.copy(amount: amount)
        }
        else {
            return item
        }
    }
    
}

class SubtotalItemTableCellView: ItemTableCellView {

    override func isEditable() -> Bool {
        return false
    }
    
    override func getDefaultStringValue() -> String {
        var stringValue = "-"
        if let item = getItem() {
            if let sum = dataProvider?.getItemSum(item.id!) {
                stringValue = ItemTableCellView.currencyFormatter.stringFromNumber(sum)!
            }
            else {
                row.map { dataProvider?.enqueueSumRequest($0) }
            }
        }
        return stringValue
    }
    
}

