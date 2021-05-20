//
//  Goods.swift
//  GoldMiner
//
//  Created by 张翌璠 on 2021-05-20.
//

import Foundation

enum GoodsType: CaseIterable {
    case bomb
    case drink
    case clover
    case book
    case diamondPolish
    
    static func choose(num: Int) -> [GoodsType] {
        return GoodsType.allCases.shuffled().suffix(num)
    }
    
    func takeEffect() {
        
    }
}
