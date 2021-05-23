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
        super.init(texture: texture, color: .clear, size: CGSize(width: 100.width, height: 100.width))
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
        fastSpeed = 160.height
        mediumSpeed = 115.height
        slowSpeed = 90.height
    }
    
    // TODO: buy goods
    private func increaseLuck() {
        randomBagMoneyRate = 1
        randomBagBombRate = 2
        randomBagStrengthRate = 2
        randomBagMoneyRange = 200...800
    }
    
    private func increaseRockPrice() {
        smallRockPrice = 60
        mediumRockPrice = 180
    }
    
    private func increaseDiamondPrice() {
        diamondPrice = 900
    }
}
