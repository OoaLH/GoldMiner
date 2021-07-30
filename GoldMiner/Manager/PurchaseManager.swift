//
//  PurchaseManager.swift
//  GoldMiner
//
//  Created by Yifan Zhang on 2021-07-25.
//

import StoreKit

protocol PurchaseManagerDelegate: AnyObject {
    func purchaseManager(didFinishProductRequestWith products: [SKProduct]?, isSuccess: Bool)
    
    func purchaseManager(didStart transaction: SKPaymentTransaction, productType: ProductType)
    
    func purchaseManager(didSucceedWith transaction: SKPaymentTransaction, productType: ProductType)
    
    func purchaseManager(didFailWithError error: Error?)
    
    func purchaseManager(didUpdatePurchaseStatusOf productType: ProductType?)
}

extension PurchaseManagerDelegate {
    func purchaseManager(didFinishProductRequestWith products: [SKProduct]?, isSuccess: Bool) {}
    
    func purchaseManager(didStart transaction: SKPaymentTransaction, productType: ProductType) {}
    
    func purchaseManager(didSucceedWith transaction: SKPaymentTransaction, productType: ProductType) {}
    
    func purchaseManager(didFailWithError error: Error?) {}
    
    func purchaseManager(didUpdatePurchaseStatusOf productType: ProductType?) {}
}

class PurchaseManager: NSObject {
    public static let shared = PurchaseManager()
    
    public var purchasedProduct: ProductType? {
        didSet {
            delegate?.purchaseManager(didUpdatePurchaseStatusOf: purchasedProduct)
        }
    }
    
    weak var delegate: PurchaseManagerDelegate?
    
    private let productIdentifiers: Set<String> = Set(ProductType.all.map({$0.rawValue}))
    private var productsRequest: SKProductsRequest?
    private var products: [SKProduct]?
    
    private override init() {
        super.init()
        
        SKPaymentQueue.default().add(self)
    }
    
    public func requestProducts() {
        productsRequest?.cancel()
        productsRequest = SKProductsRequest(productIdentifiers: productIdentifiers)
        productsRequest?.delegate = self
        productsRequest?.start()
    }
    
    public func buyProduct() {
        guard canMakePayments() else {
            delegate?.purchaseManager(didFailWithError: PurchaseError.cannotMakePayments)
            return
        }
        guard let product = products?.first else {
            delegate?.purchaseManager(didFailWithError: PurchaseError.noProductsAvailable)
            return
        }
        print("Buying \(product.productIdentifier)...")
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
    }
    
    public func canMakePayments() -> Bool {
        return SKPaymentQueue.canMakePayments()
    }
    
    public func restorePurchases() {
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
    public func stopMonitoring() {
        SKPaymentQueue.default().remove(self)
    }
    
    private func checkPurchaseStatus(_ completionHandler: @escaping (ProductType?) -> Void) {
        guard let receiptUrl = Bundle.main.appStoreReceiptURL,
              let receipt = try? Data(contentsOf: receiptUrl, options: .alwaysMapped).base64EncodedString() else {
            print("receipt missing, refresh receipt")
            let request = SKReceiptRefreshRequest()
            request.delegate = self
            request.start()
            return
        }
        sendReceiptToAppStore(receipt: receipt, completionHandler)
    }
    
    private func sendReceiptToAppStore(receipt: String, _ completionHandler: @escaping (ProductType?) -> Void) {
        var request = URLRequest(url: URL(string: "https://sandbox.itunes.apple.com/verifyReceipt")!)
        //        https://buy.itunes.apple.com/verifyReceipt
        let requestData: [String: Any] = ["receipt-data": receipt,
                                          "password": "0e69caf6f9df443f82b61b4abeccbfcb",
                                          "exclude-old-transactions": false]
        let httpBody = try? JSONSerialization.data(withJSONObject: requestData, options: [])
        request.httpMethod = "POST"
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = httpBody
        print(requestData)
        URLSession.shared.dataTask(with: request)  { (data, response, error) in
            if let error = error {
                print(error)
                completionHandler(nil)
                return
            }
            DispatchQueue.main.async {
                if let data = data, let jsonData = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] {
                    let subscriptionResponse = ReceiptResponse(data: jsonData)
                    print(jsonData)
                    completionHandler(subscriptionResponse.productType)
                } else {
                    print("data invalid")
                    completionHandler(nil)
                }
            }
        }.resume()
    }
    
    public func updatePurchaseStatus() {
        checkPurchaseStatus() { [weak self] productType in
            self?.purchasedProduct = productType
        }
    }
}

extension PurchaseManager: SKProductsRequestDelegate {
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        print("Loaded list of products...")
        let products = response.products
        self.products = products
        delegate?.purchaseManager(didFinishProductRequestWith: products, isSuccess: true)
        productsRequest = nil
        
        for p in products {
            print("Found product: \(p.productIdentifier) \(p.localizedTitle) \(p.price.floatValue)")
        }
    }
    
    func request(_ request: SKRequest, didFailWithError error: Error) {
        if request is SKReceiptRefreshRequest {
            purchasedProduct = nil
            print("No receipt.")
            return
        }
        print("Failed to load list of products.")
        print("Error: \(error.localizedDescription)")
        delegate?.purchaseManager(didFinishProductRequestWith: nil, isSuccess: false)
        productsRequest = nil
    }
    
    func requestDidFinish(_ request: SKRequest) {
        if request is SKReceiptRefreshRequest {
            print("Get refreshed receipt.")
            updatePurchaseStatus()
        }
    }
}

extension PurchaseManager: SKPaymentTransactionObserver {
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            guard let productType = ProductType(rawValue: transaction.payment.productIdentifier) else { return }
            
            switch (transaction.transactionState) {
            case .purchased:
                purchase(transaction: transaction, productType: productType)
            case .failed:
                fail(transaction: transaction)
            case .restored:
                restore(transaction: transaction, productType: productType)
            case .purchasing:
                delegate?.purchaseManager(didStart: transaction, productType: productType)
            default:
                break
            }
        }
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, restoreCompletedTransactionsFailedWithError error: Error) {
        delegate?.purchaseManager(didFailWithError: error)
    }
    
    private func purchase(transaction: SKPaymentTransaction, productType: ProductType) {
        print("purchase...")
        
        completeSubscribe(transaction: transaction, productType: productType)
    }
    
    private func restore(transaction: SKPaymentTransaction, productType: ProductType) {
        guard let productIdentifier = transaction.original?.payment.productIdentifier else { return }
        
        print("restore... \(productIdentifier)")
        completeSubscribe(transaction: transaction, productType: productType)
    }
    
    private func fail(transaction: SKPaymentTransaction) {
        print("fail...")
        if let transactionError = transaction.error as NSError?, transactionError.code != SKError.paymentCancelled.rawValue {
            delegate?.purchaseManager(didFailWithError: transactionError)
        } else {
            delegate?.purchaseManager(didFailWithError: PurchaseError.noSubscriptionPurchased)
        }
        
        SKPaymentQueue.default().finishTransaction(transaction)
    }
    
    private func completeSubscribe(transaction: SKPaymentTransaction, productType: ProductType) {
        #if DEBUG
            purchasedProduct = productType
        #else
            updatePurchaseStatus()
        #endif
        delegate?.purchaseManager(didSucceedWith: transaction, productType: productType)
        SKPaymentQueue.default().finishTransaction(transaction)
    }
}
