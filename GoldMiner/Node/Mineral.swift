//
//  Mineral.swift
//  GoldMiner
//
//  Created by 张翌璠 on 2021-05-19.
//

import SpriteKit

protocol Mineral: class {
    var mass: Int { get }
    var price: Int { get }
    var backSpeed: CGFloat { get }
    
    func configurePhysiscs()
    func back(vector: CGVector, duration: TimeInterval)
    func getBombed()
}

extension Mineral {
    func configurePhysiscs() {
        guard let mineral = self as? SKSpriteNode else { return }
        mineral.physicsBody = SKPhysicsBody(rectangleOf: mineral.size)
        mineral.physicsBody?.categoryBitMask = PhysicsCategory.mineral.rawValue
        mineral.physicsBody?.contactTestBitMask = PhysicsCategory.player.rawValue
        mineral.physicsBody?.collisionBitMask = PhysicsCategory.none.rawValue
    }
    
    func back(vector: CGVector, duration: TimeInterval) {
        guard let mineral = self as? SKSpriteNode else { return }
        let action = SKAction.move(by: vector, duration: duration)
        mineral.run(action)
    }
    
    func getBombed() {
        guard let mineral = self as? SKSpriteNode else { return }
        mineral.removeFromParent()
    }
}
