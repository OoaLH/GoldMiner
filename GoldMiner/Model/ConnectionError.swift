//
//  ConnectionError.swift
//  GoldMiner
//
//  Created by Yifan Zhang on 2021-07-24.
//

import Foundation

enum ConnectionError: Error {
    case timeout
    case teammateDisconnected
    case teammateNotFound
    case selfExited
    
    var localizedDescription: String {
        switch self {
        case .timeout:
            return NSLocalizedString("Connection timeout.", comment: "ConnectionError")
        case .teammateDisconnected:
            return NSLocalizedString("Your teammate is disconnected.", comment: "ConnectionError")
        case .teammateNotFound:
            return NSLocalizedString("Your teammate is not found.", comment: "ConnectionError")
        case .selfExited:
            return NSLocalizedString("You have exited the game.", comment: "ConnectionError")
        }
    }
}
