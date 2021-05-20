//
//  Player.swift
//  GoldMiner
//
//  Created by 张翌璠 on 2021-05-19.
//

import SpriteKit

class Player: SKSpriteNode {
    weak var hook: Hook?
    
    var score: Int = 0
    
    init() {
        let texture = SKTexture(imageNamed: "player")
        super.init(texture: texture, color: .clear, size: texture.size())
        
        configurePhysics()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configurePhysics() {
        physicsBody = SKPhysicsBody(rectangleOf: size)
        physicsBody?.categoryBitMask = PhysicsCategory.player.rawValue
        physicsBody?.contactTestBitMask = PhysicsCategory.mineral.rawValue
        physicsBody?.collisionBitMask = PhysicsCategory.none.rawValue
    }
    
    func gainScore(price: Int) {
        score += price
    }
}