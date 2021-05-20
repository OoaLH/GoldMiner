//
//  Hook.swift
//  GoldMiner
//
//  Created by 张翌璠 on 2021-05-19.
//

import SpriteKit

class Hook: SKSpriteNode {
    var player: Player
    
    weak var mineral: Mineral?
    
    init(player: Player) {
        self.player = player
        
        let texture = SKTexture(imageNamed: "projectile")
        super.init(texture: texture, color: .clear, size: texture.size())
        
        configurePhysics()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configurePhysics() {
        physicsBody = SKPhysicsBody(circleOfRadius: size.width / 2)
        physicsBody?.categoryBitMask = PhysicsCategory.hook.rawValue
        physicsBody?.contactTestBitMask = PhysicsCategory.mineral.rawValue
        physicsBody?.collisionBitMask = PhysicsCategory.none.rawValue
        physicsBody?.usesPreciseCollisionDetection = true
    }
    
    func swing() {
        removeAllActions()
        run(swingAction)
    }
    
    func shoot() {
        removeAllActions()
        let offset = position - player.position
        let direction = offset.normalized
        let ropeRange = direction * 300
        let length = ropeRange.length
        let realDest = ropeRange + position
        let shootAction = SKAction.move(to: realDest, duration: TimeInterval(length / hookDefaultSpeed))
        let backAction = SKAction.move(to: position, duration: TimeInterval(length / hookDefaultSpeed))
        run(SKAction.sequence([shootAction, backAction, swingAction]))
    }
    
    func back(for duration: TimeInterval) {
        removeAllActions()
        let backAction = SKAction.move(to: player.position, duration: duration)
        run(backAction)
    }
    
    func backAfterBomb() {
        removeAllActions()
        let offset = player.position - position
        let length = offset.length - hookShortestLength
        let direction = offset.normalized
        let x = direction.x * length
        let y = direction.y * length
        let backAction = SKAction.move(by: CGVector(dx: x, dy: y), duration: TimeInterval(length / hookDefaultSpeed))
        run(SKAction.sequence([backAction, swingAction]))
    }
    
    func fill(with mineral: Mineral) {
        self.mineral = mineral
    }
    
    func empty() {
        self.mineral = nil
        swing()
    }
    
    lazy var swingAction: SKAction = {
        let leftPath = UIBezierPath()
        leftPath.addArc(withCenter: player.position, radius: hookShortestLength, startAngle: 0, endAngle: .pi, clockwise: false)
        let leftAction = SKAction.follow(leftPath.cgPath, asOffset: false, orientToPath: true, speed: hookSwingSpeed)
        
        let rightPath = UIBezierPath()
        rightPath.addArc(withCenter: player.position, radius: hookShortestLength, startAngle: .pi, endAngle: 0, clockwise: true)
        let rightAction = SKAction.follow(rightPath.cgPath, asOffset: false, orientToPath: true, speed: hookSwingSpeed)
        
        let swingAction = SKAction.sequence([leftAction, rightAction])
        return SKAction.repeatForever(swingAction)
    }()
}
