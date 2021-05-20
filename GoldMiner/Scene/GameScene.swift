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
    var money: Int = 0
    
    var player1Score: Int = 0
    
    var player2Score: Int = 0
    
    override func sceneDidLoad() {
        configureViews()
        configurePhysics()
        print(size)
    }
    
    func configureViews() {
        initBackground()
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
    
    func initBackground() {
        backgroundColor = .white
        addChild(landNode)
    }
    
    func initPlayers() {
        addPlayer(player: player1, at: CGPoint(x: 200, y: 300))
        player1.hook = hook1
        
        addPlayer(player: player2, at: CGPoint(x: 300, y: 300))
        player2.hook = hook2
    }
    
    func initGolds() {
        for _ in 1...3 {
            let x = Int.random(in: 10..<470)
            let y = Int.random(in: 20..<220)
            addGold(mass: smallGoldMass, at: CGPoint(x: x, y: y))
        }
        
        for _ in 1...3 {
            let x = Int.random(in: 10..<470)
            let y = Int.random(in: 20..<220)
            addGold(mass: mediumGoldMass, at: CGPoint(x: x, y: y))
        }
        
        for _ in 1...3 {
            let x = Int.random(in: 10..<470)
            let y = Int.random(in: 20..<220)
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
        addChild(requiredScoreLabel)
        addChild(timeLabel)
        addChild(levelLabel)
    }
    
    func initButtons() {
        addChild(player1HookButton)
        addChild(player2HookButton)
        addChild(player1BombButton)
        addChild(player2BombButton)
        //addChild(exitButton)
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
            
            if touchedNode == player1HookButton && hook1.canShoot {
                hook1.shoot()
            }
            else if touchedNode == player2HookButton && hook2.canShoot {
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
            else if touchedNode == exitButton {
                let reveal = SKTransition.reveal(with: .down, duration: 1)
                let newScene = ShopScene(size: CGSize(width: 1024, height: 768))
                view?.presentScene(newScene, transition: reveal)
            }
        }
    }
    
    // MARK: lazy var
    lazy var hook1 = Hook(player: player1)
    
    lazy var hook2 = Hook(player: player2)
    
    lazy var player1 = Player()
    
    lazy var player2 = Player()
    
    // MARK: Button
    lazy var player1HookButton: SKSpriteNode = {
        let node = SKSpriteNode(color: joyButtonColor, size: CGSize(width: 50, height: 50))
        node.position = CGPoint(x: 50, y: 50)
        return node
    }()
    
    lazy var player2HookButton: SKSpriteNode = {
        let node = SKSpriteNode(color: joyButtonColor, size: CGSize(width: 50, height: 50))
        node.position = CGPoint(x: 430, y: 50)
        return node
    }()
    
    lazy var player1BombButton: SKSpriteNode = {
        let node = SKSpriteNode(color: joyButtonColor, size: CGSize(width: 50, height: 50))
        node.position = CGPoint(x: 50, y: 110)
        return node
    }()
    
    lazy var player2BombButton: SKSpriteNode = {
        let node = SKSpriteNode(color: joyButtonColor, size: CGSize(width: 50, height: 50))
        node.position = CGPoint(x: 430, y: 110)
        return node
    }()
    
    lazy var exitButton: SKSpriteNode = {
        let node = SKSpriteNode(color: .red, size: CGSize(width: 50, height: 50))
        node.position = CGPoint(x: 430, y: 280)
        return node
    }()
    
    // MARK: label
    lazy var scoreLabel1: SKLabelNode = {
        let node = SKLabelNode()
        node.text = "player 1: "
        node.position = player1.position - CGPoint(x: 50, y: 0)
        node.fontSize = 12
        node.fontName = "PingFangTC-Semibold"
        node.fontColor = .brown
        return node
    }()
    
    lazy var scoreLabel2: SKLabelNode = {
        let node = SKLabelNode()
        node.text = "player 2: "
        node.position = player2.position + CGPoint(x: 50, y: 0)
        node.fontSize = 12
        node.fontName = "PingFangTC-Semibold"
        node.fontColor = .brown
        return node
    }()
    
    lazy var totalScoreLabel: SKLabelNode = {
        let node = SKLabelNode()
        node.text = "money: 0"
        node.position = CGPoint(x: 30, y: 300)
        node.fontSize = 14
        node.fontName = "PingFangTC-Semibold"
        node.fontColor = .brown
        return node
    }()
    
    lazy var requiredScoreLabel: SKLabelNode = {
        let node = SKLabelNode()
        node.text = "goal: "
        node.position = CGPoint(x: 30, y: 280)
        node.fontSize = 14
        node.fontName = "PingFangTC-Semibold"
        node.fontColor = .brown
        return node
    }()
    
    lazy var timeLabel: SKLabelNode = {
        let node = SKLabelNode()
        node.text = "time: "
        node.position = CGPoint(x: 450, y: 300)
        node.fontSize = 14
        node.fontName = "PingFangTC-Semibold"
        node.fontColor = .brown
        return node
    }()
    
    lazy var levelLabel: SKLabelNode = {
        let node = SKLabelNode()
        node.text = "level: 1"
        node.position = CGPoint(x: 450, y: 280)
        node.fontSize = 14
        node.fontName = "PingFangTC-Semibold"
        node.fontColor = .brown
        return node
    }()
    
    //MARK: background
    lazy var landNode: SKShapeNode = {
        let node = SKShapeNode(rect: CGRect(x: 0, y: 280, width: 480, height: 2))
        node.fillColor = .brown
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
        
        if firstBody.categoryBitMask.isMineral && secondBody.categoryBitMask.isHook {
            if let mineral = firstBody.node as? Mineral, let hook = secondBody.node as? Hook, mineral.hook == nil, hook.mineral == nil {
                hookCaughtMineral(hook: hook, mineral: mineral)
            }
        }
        else if firstBody.categoryBitMask.isMineral && secondBody.categoryBitMask.isPlayer {
            if let mineral = firstBody.node as? Mineral, let player = secondBody.node as? Player, mineral.hook == player.hook {
                mineralArrived(mineral: mineral, at: player)
            }
        }
    }
    
    func hookCaughtMineral(hook: Hook, mineral: Mineral) {
        //print("hit")
        let offset = hook.player.position - hook.position
        let length = offset.length
        let duration = TimeInterval(length / mineral.backSpeed)
        hook.fill(with: mineral)
        hook.back(for: duration)
        
        let vector = CGVector(dx: offset.x, dy: offset.y)
        mineral.hook = hook
        mineral.back(vector: vector, duration: duration)
    }
    
    func mineralArrived(mineral: Mineral, at player: Player) {
        //print("arrive")
        player.gainScore(price: mineral.price)
        player.hook?.empty()
        mineral.removeFromParent()
    }
}
