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
    
    var canShoot: Bool = true
    
    var canCatch: Bool = false
    
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
    
    func outsideOfScreen() -> Bool {
        return position.x > UIConfig.realWidth || position.x < 0 || position.y > UIConfig.realHeight || position.y < 0
    }
    
    func swing() {
        removeAllActions()
        run(swingAction)
    }
    
    func shoot() {
        canShoot = false
        canCatch = true
        
        removeAllActions()
        
        let offset = position - player.position
        let direction = offset.normalized
        let ropeRange = direction * Tuning.hookLongestLength
        let length = ropeRange.length
        let realDest = ropeRange + position
        let shootAction = SKAction.move(to: realDest, duration: TimeInterval(length / Tuning.hookDefaultSpeed))
        let toggleCatch = SKAction.run {
            self.canCatch = false
        }
        let backAction = SKAction.move(to: position, duration: TimeInterval(length / Tuning.hookDefaultSpeed))
        run(SKAction.sequence([shootAction, toggleCatch, backAction, swingAction]))
    }
    
    func back() {
        backAfterBomb()
    }
    
    func back(for duration: TimeInterval) {
        canCatch = false
        
        removeAllActions()
        
        let backAction = SKAction.move(to: player.position, duration: duration)
        run(backAction)
    }
    
    func backAfterBomb() {
        empty()
        canCatch = false
        
        removeAllActions()
        
        let offset = player.position - position
        let length = offset.length - Tuning.hookShortestLength
        let direction = offset.normalized
        let x = direction.x * length
        let y = direction.y * length
        let backAction = SKAction.move(by: CGVector(dx: x, dy: y), duration: TimeInterval(length / Tuning.hookDefaultSpeed))
        run(SKAction.sequence([backAction, swingAction]))
    }
    
    func fill(with mineral: Mineral) {
        self.mineral = mineral
    }
    
    func empty() {
        mineral = nil
    }
    
    lazy var swingAction: SKAction = {
        let readyForShootBlock = SKAction.run {
            self.canShoot = true
        }
        
        let leftPath = UIBezierPath()
        leftPath.addArc(withCenter: player.position, radius: Tuning.hookShortestLength, startAngle: Tuning.minHookAngle, endAngle: Tuning.maxHookAngle, clockwise: false)
        let leftAction = SKAction.follow(leftPath.cgPath, asOffset: false, orientToPath: true, speed: Tuning.hookSwingSpeed)
        
        let waitAction = SKAction.wait(forDuration: Tuning.movePauseDuration)
        
        let rightPath = UIBezierPath()
        rightPath.addArc(withCenter: player.position, radius: Tuning.hookShortestLength, startAngle: Tuning.maxHookAngle, endAngle: Tuning.minHookAngle, clockwise: true)
        let rightAction = SKAction.follow(rightPath.cgPath, asOffset: false, orientToPath: true, speed: Tuning.hookSwingSpeed)
        
        let swingAction = SKAction.sequence([leftAction, waitAction, rightAction, waitAction])
        return SKAction.sequence([readyForShootBlock, SKAction.repeatForever(swingAction)])
    }()
}
