//
//  Bucket.swift
//  GoldMiner
//
//  Created by 张翌璠 on 2021-05-22.
//

import SpriteKit

class Bucket: SKSpriteNode {
    var exploding: Bool = false
    
    init() {
        let texture = SKTexture(imageNamed: "bucket")
        let textSize = texture.size()
        let size = CGSize(width: textSize.width.height / 3, height: textSize.height.height / 3)
        super.init(texture: texture, color: .clear, size: size)
        
        configurePhysics()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configurePhysics() {
        if let texture = texture {
            physicsBody = SKPhysicsBody(texture: texture, alphaThreshold: 0.1, size: size)
        }
        physicsBody?.categoryBitMask = PhysicsCategory.mineral.rawValue
        physicsBody?.contactTestBitMask = PhysicsCategory.hook.rawValue
        physicsBody?.collisionBitMask = PhysicsCategory.none.rawValue
    }
    
    func explode() {
        if exploding {
            return
        }
        addChild(wave)
        exploding = true
        if let fireParticles = SKEmitterNode(fileNamed: "FireParticle") {
            fireParticles.position = CGPoint(x: 0, y: 0)
            addChild(fireParticles)
        }
        let action = SKAction.scale(by: 100, duration: 1)
        wave.run(action) {
            self.removeFromParent()
        }
    }
    
    lazy var wave: SKShapeNode = {
        let node = SKShapeNode(circleOfRadius: 1)
        node.position = CGPoint(x: 0, y: 0)
        node.fillColor = .clear
        node.physicsBody = SKPhysicsBody(circleOfRadius: 1)
        node.physicsBody?.categoryBitMask = PhysicsCategory.wave.rawValue
        node.physicsBody?.contactTestBitMask = PhysicsCategory.mineral.rawValue
        node.physicsBody?.collisionBitMask = PhysicsCategory.none.rawValue
        return node
    }()
}
