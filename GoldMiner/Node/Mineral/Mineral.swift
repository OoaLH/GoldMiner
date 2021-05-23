//
//  Mineral.swift
//  GoldMiner
//
//  Created by 张翌璠 on 2021-05-19.
//

import SpriteKit

class Mineral: SKSpriteNode {
    var price: Int
    
    var backSpeed: CGFloat {
        return mediumSpeed
    }
    
    var exploding: Bool = false
    
    weak var hook: Hook?
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        self.price = smallGoldPrice
        
        super.init(texture: texture, color: color, size: size)
        
        configurePhysiscs()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configurePhysiscs() {
        if let texture = texture {
            physicsBody = SKPhysicsBody(texture: texture, alphaThreshold: 0.1, size: size)
        }
        physicsBody?.categoryBitMask = PhysicsCategory.mineral.rawValue
        physicsBody?.contactTestBitMask = PhysicsCategory.player.rawValue
        physicsBody?.collisionBitMask = PhysicsCategory.none.rawValue
    }
    
    func back(vector: CGVector, duration: TimeInterval) {
        let action = SKAction.move(by: vector, duration: duration)
        run(action)
    }
    
    func getBombed() {
        if exploding {
            return
        }
        exploding = true
        if let fireParticles = SKEmitterNode(fileNamed: "FireParticle") {
            fireParticles.position = CGPoint(x: 0, y: 0)
            print(fireParticles.position)
            print(position)
            addChild(fireParticles)
        }
        let burn = SKAction.wait(forDuration: 0.5)
        run(burn) {
            self.removeFromParent()
        }
    }
}
