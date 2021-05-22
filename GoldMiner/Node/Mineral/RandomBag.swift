//
//  RandomBag.swift
//  GoldMiner
//
//  Created by 张翌璠 on 2021-05-19.
//

import SpriteKit

enum RandomBagContent {
    case money(Int)
    case bomb
    case strength
    
    static func choose() -> RandomBagContent {
        let total = randomBagMoneyRate + randomBagBombRate + randomBagStrengthRate
        let num = Int.random(in: 0..<total)
        if num < randomBagMoneyRate {
            let price = Int.random(in: randomBagMoneyRange)
            return .money(price)
        }
        if num < randomBagMoneyRate + randomBagBombRate {
            return .bomb
        }
        return .strength
    }
}

class RandomBag: Mineral {
    var content: RandomBagContent
    
    init() {
        self.content = RandomBagContent.choose()
        
        let diamondTexture = SKTexture(imageNamed: "random_bag")
        super.init(texture: diamondTexture, color: .clear, size: diamondTexture.size())
        
        self.mass = randomBagMasses.randomElement() ?? mediumGoldMass
        self.price = 0
        self.backSpeed = goldBackSpeed[self.mass] ?? mediumSpeed
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func takeEffect() {
        switch content {
        case .money(let num):
            self.price = num
        case .bomb:
            GameSession.shared.numberOfBomb += 1
        case .strength:
            fastSpeed = 170
            mediumSpeed = 115
            slowSpeed = 90
        }
    }
}
