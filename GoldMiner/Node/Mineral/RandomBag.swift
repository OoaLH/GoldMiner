//
//  RandomBag.swift
//  GoldMiner
//
//  Created by 张翌璠 on 2021-05-19.
//

import SpriteKit

enum RandomBagContent: Equatable {
    case money(Int)
    case bomb
    case strength
    
    static func choose() -> RandomBagContent {
        let total = Tuning.randomBagMoneyRate + Tuning.randomBagBombRate + Tuning.randomBagStrengthRate
        let num = Int.random(in: 0..<total)
        if num < Tuning.randomBagMoneyRate {
            let price = Int.random(in: Tuning.randomBagMoneyRange)
            return .money(price)
        }
        if num < Tuning.randomBagMoneyRate + Tuning.randomBagBombRate {
            return .bomb
        }
        return .strength
    }
}

class RandomBag: Mineral {
    var content: RandomBagContent
    
    override var backSpeed: CGFloat {
        let speeds: Set = [Tuning.fastSpeed, Tuning.mediumSpeed, Tuning.slowSpeed]
        return speeds.randomElement() ?? Tuning.mediumSpeed
    }
    
    init() {
        self.content = RandomBagContent.choose()
        
        let bagTexture = SKTexture(imageNamed: "random_bag")
        let textSize = bagTexture.size()
        let size = CGSize(width: textSize.width.height / 6, height: textSize.height.height / 6)
        super.init(texture: bagTexture, color: .clear, size: size)
        
        self.price = 0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func takeEffect() {
        switch content {
        case .money(let num):
            getMoney(num: num)
        case .bomb:
            getBomb()
        case .strength:
            getStrength()
        }
    }
    
    func getMoney(num: Int) {
        price = num
    }
    
    func getBomb() {
        GameSession.shared.numberOfBomb += 1
        
        if let scene = scene as? GameScene {
            let pos = scene.bombs.last?.position ?? scene.player1.position + CGPoint(x: 20, y: 0)
            scene.addBomb(at: pos)
        }
    }
    
    func getStrength() {
        Tuning.fastSpeed = Tuning.hookDefaultSpeed
        Tuning.mediumSpeed = Tuning.hookDefaultSpeed
        Tuning.slowSpeed = Tuning.hookDefaultSpeed
        scene?.alertPopup(text: "strength up")
    }
}
