//
//  GoodsType.swift
//  GoldMiner
//
//  Created by 张翌璠 on 2021-05-20.
//

import SpriteKit

enum GoodsType: CaseIterable {
    case bomb
    case drink
    case clover
    case book
    case diamondPolish
    
    static func choose(num: Int) -> [GoodsType] {
        return GoodsType.allCases.shuffled().suffix(num)
    }
    
    var texture: SKTexture {
//        switch self {
//        case .bomb:
//            return SKTexture(imageNamed: "projectile")
//        case .drink:
//            return SKTexture(imageNamed: "projectile")
//        case .clover:
//            return SKTexture(imageNamed: "projectile")
//        case .book:
//            return SKTexture(imageNamed: "projectile")
//        case .diamondPolish:
//            return SKTexture(imageNamed: "projectile")
//        }
        switch self {
        case .bomb:
            return SKTexture(imageNamed: "bomb")
        case .drink:
            return SKTexture(imageNamed: "drink")
        case .clover:
            return SKTexture(imageNamed: "clover")
        case .book:
            return SKTexture(imageNamed: "book")
        case .diamondPolish:
            return SKTexture(imageNamed: "diamond_polish")
        }
    }
}
