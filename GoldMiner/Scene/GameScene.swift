//
//  GameScene.swift
//  GoldMiner
//
//  Created by 张翌璠 on 2021-05-19.
//

import SpriteKit
import GameplayKit

enum PhysicsCategory: UInt32 {
    case none = 0
    case mineral = 0b1
    case hook = 0b10
    case player = 0b11
    case all = 0xffffffff
}

class GameScene: SKScene {
    
    override func sceneDidLoad() {
        configureViews()
        configurePhysics()
        print(size)
    }
    
    func configureViews() {
        backgroundColor = .white
        
        initPlayers()
        initGolds()
        initHooks()
        initLabels()
        initButtons()
    }
    
    func configurePhysics() {
        physicsWorld.gravity = .zero
        physicsWorld.contactDelegate = self
    }
    
    func initPlayers() {
        addPlayer(player: player1, at: CGPoint(x: 200, y: 300))
        player1.hook = hook1
        
        addPlayer(player: player2, at: CGPoint(x: 300, y: 300))
        player2.hook = hook2
    }
    
    func initGolds() {
        for _ in 1...3 {
            let x = Int.random(in: 50..<430)
            let y = Int.random(in: 50..<250)
            addGold(mass: smallGoldMass, at: CGPoint(x: x, y: y))
        }
        
        for _ in 1...3 {
            let x = Int.random(in: 50..<430)
            let y = Int.random(in: 50..<250)
            addGold(mass: mediumGoldMass, at: CGPoint(x: x, y: y))
        }
        
        for _ in 1...3 {
            let x = Int.random(in: 50..<430)
            let y = Int.random(in: 50..<250)
            addGold(mass: largeGoldMass, at: CGPoint(x: x, y: y))
        }
    }
    
    func initHooks() {
        addHook(hook: hook1)
        hook1.swing()
        
        addHook(hook: hook2)
        hook2.swing()
    }
    
    func initLabels() {
        addChild(scoreLabel1)
        addChild(scoreLabel2)
        addChild(totalScoreLabel)
    }
    
    func initButtons() {
        addChild(player1HookButton)
        addChild(player2HookButton)
        addChild(player1BombButton)
        addChild(player2BombButton)
    }
    
    func addPlayer(player: Player, at pos: CGPoint) {
        player.position = pos
        addChild(player)
    }
    
    func addGold(mass: Int, at pos: CGPoint) {
        let gold = Gold(mass: mass)
        gold.position = pos
        addChild(gold)
    }
    
    func addHook(hook: Hook) {
        let player = hook.player
        let x = player.position.x
        let y = player.position.y
        hook.position = CGPoint(x: x, y: y - hookShortestLength)
        addChild(hook)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let touchedNode = atPoint(location)
            
            if touchedNode == player1HookButton {
                hook1.shoot()
            }
            else if touchedNode == player2HookButton {
                hook2.shoot()
            }
            else if touchedNode == player1BombButton {
                if let mineral = hook1.mineral {
                    mineral.getBombed()
                    hook1.backAfterBomb()
                }
            }
            else if touchedNode == player2BombButton {
                if let mineral = hook2.mineral {
                    mineral.getBombed()
                    hook2.backAfterBomb()
                }
            }
        }
    }
    
    lazy var hook1 = Hook(player: player1)
    
    lazy var hook2 = Hook(player: player2)
    
    lazy var player1 = Player()
    
    lazy var player2 = Player()
    
    lazy var player1HookButton: SKSpriteNode = {
        let node = SKSpriteNode(color: .brown, size: CGSize(width: 50, height: 50))
        node.position = CGPoint(x: 50, y: 50)
        return node
    }()
    
    lazy var player2HookButton: SKSpriteNode = {
        let node = SKSpriteNode(color: .brown, size: CGSize(width: 50, height: 50))
        node.position = CGPoint(x: 430, y: 50)
        return node
    }()
    
    lazy var player1BombButton: SKSpriteNode = {
        let node = SKSpriteNode(color: .brown, size: CGSize(width: 50, height: 50))
        node.position = CGPoint(x: 50, y: 110)
        return node
    }()
    
    lazy var player2BombButton: SKSpriteNode = {
        let node = SKSpriteNode(color: .brown, size: CGSize(width: 50, height: 50))
        node.position = CGPoint(x: 430, y: 110)
        return node
    }()
    
    lazy var scoreLabel1: SKLabelNode = {
        let node = SKLabelNode()
        node.text = "player 1: "
        node.position = player1.position - CGPoint(x: 50, y: 0)
        node.fontColor = .brown
        return node
    }()
    
    lazy var scoreLabel2: SKLabelNode = {
        let node = SKLabelNode()
        node.text = "player 2: "
        node.position = player2.position + CGPoint(x: 50, y: 0)
        node.fontColor = .brown
        return node
    }()
    
    lazy var totalScoreLabel: SKLabelNode = {
        let node = SKLabelNode()
        node.text = "money: "
        node.position = CGPoint(x: 50, y: 270)
        node.fontColor = .brown
        return node
    }()
    
    lazy var requiredScoreLabel: SKLabelNode = {
        let node = SKLabelNode()
        node.text = "goal: "
        node.fontColor = .brown
        return node
    }()
    
    lazy var timeLabel: SKLabelNode = {
        let node = SKLabelNode()
        node.text = "time: "
        node.fontColor = .brown
        return node
    }()
    
    lazy var levelLabel: SKLabelNode = {
        let node = SKLabelNode()
        node.text = "level: "
        node.fontColor = .brown
        return node
    }()
}

extension GameScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        if firstBody.categoryBitMask.isGold && secondBody.categoryBitMask.isHook {
            if let gold = firstBody.node as? Gold, let hook = secondBody.node as? Hook, gold.hook == nil {
                hookHitGold(hook: hook, gold: gold)
            }
        }
        else if firstBody.categoryBitMask.isGold && secondBody.categoryBitMask.isPlayer {
            if let gold = firstBody.node as? Gold, let player = secondBody.node as? Player, gold.hook == player.hook {
                goldHitPlayer(gold: gold, player: player)
            }
        }
    }
    
    func hookHitGold(hook: Hook, gold: Gold) {
        print("hit")
        let offset = hook.player.position - hook.position
        let direction = offset.normalized * 300
        let length = direction.length
        let duration = TimeInterval(length / gold.backSpeed)
        hook.fill(with: gold)
        hook.back(for: duration)
        
        let vector = CGVector(dx: offset.x, dy: offset.y)
        gold.hook = hook
        gold.back(vector: vector, duration: duration)
    }
    
    func goldHitPlayer(gold: Gold, player: Player) {
        print("arrive")
        player.gainScore(price: gold.price)
        player.hook?.empty()
        gold.removeFromParent()
    }
}
