//
//  PurchaseError.swift
//  GoldMiner
//
//  Created by Yifan Zhang on 2021-07-25.
//

import Foundation

enum PurchaseError: LocalizedError {
    case noProductPurchased
    case noProductsAvailable
    case cannotMakePayments
    
    var errorDescription: String {
        switch self {
        case .noProductPurchased:
            return "No subscription purchased"
        case .noProductsAvailable:
            return "No products available"
        case .cannotMakePayments:
            return "Can't make payments"
        }
    }
}
