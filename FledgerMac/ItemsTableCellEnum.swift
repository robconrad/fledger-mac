//
//  ItemsTableCellEnum.swift
//  FledgerMac
//
//  Created by Robert Conrad on 9/13/15.
//  Copyright (c) 2015 Robert Conrad. All rights reserved.
//



enum ItemsTableCellEnum: Int {
    
    case id = 0
    case account = 1
    case date = 2
    case comments = 3
    case type = 4
    case debit = 5
    case credit = 6
    case subtotal = 7
    
    func storyboardId() -> String {
        switch self {
        case id: return "idCell"
        case account: return "accountCell"
        case date: return "dateCell"
        case comments: return "commentsCell"
        case type: return "typeCell"
        case debit: return "debitCell"
        case credit: return "creditCell"
        case subtotal: return "subtotalCell"
        }
    }
    
    static func fromColumnStoryboardId(columnId: String) -> ItemsTableCellEnum {
        switch columnId {
        case "idColumn": return .id
        case "accountColumn": return .account
        case "dateColumn": return .date
        case "commentsColumn": return .comments
        case "typeColumn": return .type
        case "debitColumn": return .debit
        case "creditColumn": return .credit
        case "subtotalColumn": return .subtotal
        default: fatalError("invalid column storyboard id")
        }
    }
    
}