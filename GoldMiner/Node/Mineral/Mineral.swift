//
//  Mineral.swift
//  GoldMiner
//
//  Created by 张翌璠 on 2021-05-19.
//

import SpriteKit

class Mineral: SKSpriteNode {
    var mass: Int
    
    var price: Int
    
    var backSpeed: CGFloat
    
    weak var hook: Hook?
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        self.mass = smallGoldMass
        self.price = smallGoldMass
        self.backSpeed = mediumSpeed
        
        super.init(texture: texture, color: color, size: size)
        
        configurePhysiscs()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configurePhysiscs() {
        physicsBody = SKPhysicsBody(rectangleOf: size)
        physicsBody?.categoryBitMask = PhysicsCategory.mineral.rawValue
        physicsBody?.contactTestBitMask = PhysicsCategory.player.rawValue
        physicsBody?.collisionBitMask = PhysicsCategory.none.rawValue
    }
    
    func back(vector: CGVector, duration: TimeInterval) {
        let action = SKAction.move(by: vector, duration: duration)
        run(action)
    }
    
    func getBombed() {
        removeFromParent()
    }
}
