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
    
    var isShooting: Bool = false
    
    init(player: Player) {
        self.player = player
        
        let texture = SKTexture(imageNamed: "hook")
        super.init(texture: texture, color: .clear, size: CGSize(width: 19.8, height: 18.8))
        zPosition = 1
        configurePhysics()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configurePhysics() {
        if let texture = texture {
            physicsBody = SKPhysicsBody(texture: texture, alphaThreshold: 0.1, size: size)
        }
        physicsBody?.categoryBitMask = PhysicsCategory.hook.rawValue
        physicsBody?.contactTestBitMask = PhysicsCategory.mineral.rawValue
        physicsBody?.collisionBitMask = PhysicsCategory.none.rawValue
        physicsBody?.usesPreciseCollisionDetection = true
    }
    
    func outsideOfScreen() -> Bool {
        return position.x > UIConfig.defaultWidth || position.x < 0 || position.y > UIConfig.defaultHeight || position.y < 0
    }
    
    func swing() {
        removeAllActions()
        run(swingAction)
    }
    
    func shoot() {
        canShoot = false
        isShooting = true
        
        removeAllActions()
        
        empty()
        
        let offset = position - player.position
        let direction = offset.normalized
        let ropeRange = direction * Tuning.hookLongestLength
        let length = ropeRange.length
        let realDest = ropeRange + position
        let shootAction = SKAction.move(to: realDest, duration: TimeInterval(length / Tuning.hookDefaultSpeed))
        let toggleCatch = SKAction.run {
            self.isShooting = false
        }
        let backAction = SKAction.move(to: position, duration: TimeInterval(length / Tuning.hookDefaultSpeed))
        run(SKAction.sequence([shootAction, toggleCatch, backAction, swingAction]))
    }
    
    func back() {
        backAfterBomb()
    }
    
    func back(for duration: TimeInterval) {
        isShooting = false
        
        removeAllActions()
        
        let backAction = SKAction.move(to: player.position, duration: duration)
        run(backAction)
    }
    
    func backAfterBomb() {
        player.stopDrag()
        empty()
        isShooting = false
        
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
        let leftAction = SKAction.follow(leftPath.cgPath, asOffset: false, orientToPath: false, speed: Tuning.hookSwingSpeed)
        
        let waitAction = SKAction.wait(forDuration: Tuning.movePauseDuration)
        
        let rightPath = UIBezierPath()
        rightPath.addArc(withCenter: player.position, radius: Tuning.hookShortestLength, startAngle: Tuning.maxHookAngle, endAngle: Tuning.minHookAngle, clockwise: true)
        let rightAction = SKAction.follow(rightPath.cgPath, asOffset: false, orientToPath: false, speed: Tuning.hookSwingSpeed)
        
        let swingAction = SKAction.sequence([leftAction, waitAction, rightAction, waitAction])
        return SKAction.sequence([readyForShootBlock, SKAction.repeatForever(swingAction)])
    }()
}
