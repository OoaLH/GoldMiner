//
//  BitMask.swift
//  GoldMiner
//
//  Created by 张翌璠 on 2021-05-26.
//

import Foundation

enum PhysicsCategory: UInt32 {
    case none = 0
    case mineral = 0b1
    case hook = 0b10
    case player = 0b101
    case wave = 0b100
    case all = 0xffffffff
}
