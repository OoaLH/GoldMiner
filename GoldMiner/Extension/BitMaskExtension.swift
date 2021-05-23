//
//  BitMaskExtension.swift
//  GoldMiner
//
//  Created by 张翌璠 on 2021-05-19.
//

import Foundation

extension UInt32 {
    var isMineral: Bool {
        return self == 0b1
    }
    
    var isHook: Bool {
        return self == 0b10
    }
    
    var isPlayer: Bool {
        return self == 0b11
    }
    
    var isWave: Bool {
        return self == 0b100
    }
}
