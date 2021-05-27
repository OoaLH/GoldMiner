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
        var num: Int
        var price: Int
        switch GameSession.shared.mode {
        case .local:
            num = Int.random(in: 0..<total)
            price = Int.random(in: Tuning.randomBagMoneyRange)
        case .online:
            num = (GameSession.shared.level + GameSession.shared.money) % total
            let range = Int((Tuning.randomBagMoneyRange.upperBound - Tuning.randomBagMoneyRange.lowerBound) / 2)
            price = Tuning.randomBagMoneyRange.lowerBound + GameSession.shared.player1Score % range + GameSession.shared.player2Score % range
        }
        if num < Tuning.randomBagMoneyRate {
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
        let speeds = [Tuning.fastSpeed, Tuning.mediumSpeed, Tuning.slowSpeed]
        switch GameSession.shared.mode {
        case .local:
            return speeds.randomElement() ?? Tuning.mediumSpeed
        case .online:
            let index = (GameSession.shared.level + GameSession.shared.money) % 3
            return speeds[index]
        }
    }
    
    init() {
        content = RandomBagContent.choose()
        
        let bagTexture = SKTexture(imageNamed: "random_bag")
        let textSize = bagTexture.size()
        let size = CGSize(width: textSize.width / 6, height: textSize.height / 6)
        super.init(texture: bagTexture, color: .clear, size: size)
        
        price = 0
    }
    
    required init?(coder aDecoder: NSCoder) {
        content = RandomBagContent.choose()
        super.init(coder: aDecoder)
        price = 0
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
            let pos = (scene.bombs.last?.position ?? (scene.player1.position + CGPoint(x: 20, y: 0))) + CGPoint(x: 20, y: 0)
            scene.addBomb(at: pos)
            
        }
    }
    
    func getStrength() {
        Tuning.fastSpeed = Tuning.hookDefaultSpeed
        Tuning.mediumSpeed = Tuning.hookDefaultSpeed
        Tuning.slowSpeed = Tuning.hookDefaultSpeed
        scene?.alertPopup(text: "strength up")
    }
    
    func getOnlineModeContent() {
        content = RandomBagContent.choose()
    }
}
