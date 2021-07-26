//
//  PurchaseError.swift
//  GoldMiner
//
//  Created by Yifan Zhang on 2021-07-25.
//

enum PurchaseError: Error {
    case noSubscriptionPurchased
    case noProductsAvailable
    case cannotMakePayments
    
    var localizedDescription: String {
        switch self {
        case .noSubscriptionPurchased:
            return "No subscription purchased"
        case .noProductsAvailable:
            return "No products available"
        case .cannotMakePayments:
            return "Can't make payments"
        }
    }
}
