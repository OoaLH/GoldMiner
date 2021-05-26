//
//  Goods.swift
//  GoldMiner
//
//  Created by 张翌璠 on 2021-05-20.
//

import SpriteKit

class Goods: SKSpriteNode {
    var type: GoodsType
    
    var price: Int
    
    var priceLabel: SKLabelNode?
    
    init(type: GoodsType) {
        self.price = Int.random(in: 10...500)
        self.type = type
        let texture = type.texture
        super.init(texture: texture, color: .clear, size: CGSize(width: 100, height: 100))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func takeEffect() {
        switch type {
        case .bomb:
            increaseBomb()
        case .drink:
            increasePower()
        case .clover:
            increaseLuck()
        case .book:
            increaseRockPrice()
        case .diamondPolish:
            increaseDiamondPrice()
        }
    }
    
    private func increaseBomb() {
        GameSession.shared.numberOfBomb += 1
    }
    
    private func increasePower() {
        Tuning.fastSpeed = 160
        Tuning.mediumSpeed = 115
        Tuning.slowSpeed = 90
    }
    
    private func increaseLuck() {
        Tuning.randomBagMoneyRate = 1
        Tuning.randomBagBombRate = 2
        Tuning.randomBagStrengthRate = 2
        Tuning.randomBagMoneyRange = 200...800
    }
    
    private func increaseRockPrice() {
        Tuning.smallRockPrice = 60
        Tuning.mediumRockPrice = 180
    }
    
    private func increaseDiamondPrice() {
        Tuning.diamondPrice = 900
    }
}
