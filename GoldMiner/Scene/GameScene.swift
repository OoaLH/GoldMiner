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
    case wave = 0b100
    case all = 0xffffffff
}

class GameScene: SKScene {
    var money: Int = GameSession.shared.money {
        didSet {
            scoreLabel1.text = "player1: \(player1.score)"
            scoreLabel2.text = "player2: \(player2.score)"
            totalScoreLabel.text = "money: \(money)"
            GameSession.shared.money = money
            GameSession.shared.player1Score = player1.score
            GameSession.shared.player2Score = player2.score
        }
    }
    
    var time: Int = Tuning.gameDuration {
        didSet {
            if time == 0 {
                removeAction(forKey: "timer")
                exit()
            }
            timeLabel.text = "time: \(time)"
        }
    }
    
    var bombs: [Goods] = []
    
    override func sceneDidLoad() {
        configureViews()
        configurePhysics()
    }
    
    func configureViews() {
        initBackground()
        initPlayers()
        initMinerals()
        initHooks()
        initLabels()
        initButtons()
        initTimer()
        initBombs()
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
        addPlayer(player: player1, at: UIConfig.player1Position)
        player1.hook = hook1
        
        addPlayer(player: player2, at: UIConfig.player2Position)
        player2.hook = hook2
    }
    
    func initMinerals() {
        addLargeGold(at: CGPoint(x: 100.width, y: 100.height))
        addLargeGold(at: CGPoint(x: 300.width, y: 100.height))
        addLargeGold(at: CGPoint(x: 200.width, y: 100.height))
        addBucket(at: CGPoint(x: 500.width, y: 200.height))
//        for _ in 1...3 {
//            let x = Int.random(in: 10..<790)
//            let y = Int.random(in: 20..<300)
//            addSmallGold(at: CGPoint(x: x, y: y))
//        }
//
//        for _ in 1...3 {
//            let x = Int.random(in: 10..<790)
//            let y = Int.random(in: 20..<300)
//            addMouse(at: CGPoint(x: x, y: y))
//        }
        
//        for _ in 1...3 {
//            let x = Int.random(in: 10..<790)
//            let y = Int.random(in: 20..<300)
//            addDiamondMouse(at: CGPoint(x: x, y: y))
//        }
        
//        for _ in 1...3 {
//            let x = Int.random(in: 10..<470)
//            let y = Int.random(in: 20..<220)
//            addMediumGold(at: CGPoint(x: x, y: y))
//        }
//
//        for _ in 1...3 {
//            let x = Int.random(in: 10..<470)
//            let y = Int.random(in: 20..<220)
//            addLargeGold(at: CGPoint(x: x, y: y))
//        }
        
//        for _ in 1...3 {
//            let x = Int.random(in: 10..<470)
//            let y = Int.random(in: 20..<220)
//            addDiamond(at: CGPoint(x: x, y: y))
//        }
//
//        for _ in 1...3 {
//            let x = Int.random(in: 10..<470)
//            let y = Int.random(in: 20..<220)
//            addRandomBag(at: CGPoint(x: x, y: y))
//        }
//
//        for _ in 1...3 {
//            let x = Int.random(in: 10..<470)
//            let y = Int.random(in: 20..<220)
//            addSmallRock(at: CGPoint(x: x, y: y))
//        }
//
//        for _ in 1...3 {
//            let x = Int.random(in: 10..<470)
//            let y = Int.random(in: 20..<220)
//            addMediumRock(at: CGPoint(x: x, y: y))
//        }
        
//        for _ in 1...3 {
//            let x = Int.random(in: 10..<470)
//            let y = Int.random(in: 20..<220)
//            addBucket(at: CGPoint(x: x, y: y))
//        }
    }
    
    func initHooks() {
        addHook(hook: hook1)
        addChild(rope1)
        hook1.swing()
        
        addHook(hook: hook2)
        addChild(rope2)
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
        addChild(exitButton)
    }
    
    func initTimer() {
        let second = SKAction.wait(forDuration: 1)
        let countDown = SKAction.run {
            self.time -= 1
        }
        let action = SKAction.sequence([second, countDown])
        run(SKAction.repeatForever(action), withKey: "timer")
    }
    
    func initBombs() {
        var pos = player1.position + CGPoint(x: 20, y: 0)
        for _ in 0..<GameSession.shared.numberOfBomb {
            addBomb(at: pos)
            pos = pos + CGPoint(x: 20, y: 0)
        }
    }
    
    func addPlayer(player: Player, at pos: CGPoint) {
        player.position = pos
        addChild(player)
    }
    
    func addSmallGold(at pos: CGPoint) {
        let gold = SmallGold()
        gold.position = pos
        addChild(gold)
    }
    
    func addMediumGold(at pos: CGPoint) {
        let gold = MediumGold()
        gold.position = pos
        addChild(gold)
    }
    
    func addLargeGold(at pos: CGPoint) {
        let gold = LargeGold()
        gold.position = pos
        addChild(gold)
    }
    
    func addMouse(at pos: CGPoint) {
        let mouse = Mouse()
        mouse.position = pos
        addChild(mouse)
        mouse.walkAround()
    }
    
    func addDiamondMouse(at pos: CGPoint) {
        let mouse = DiamondMouse()
        mouse.position = pos
        addChild(mouse)
        mouse.walkAround()
    }
    
    func addDiamond(at pos: CGPoint) {
        let diamond = Diamond()
        diamond.position = pos
        addChild(diamond)
    }
    
    func addRandomBag(at pos: CGPoint) {
        let node = RandomBag()
        node.position = pos
        addChild(node)
    }
    
    func addSmallRock(at pos: CGPoint) {
        let node = SmallRock()
        node.position = pos
        addChild(node)
    }
    
    func addMediumRock(at pos: CGPoint) {
        let node = MediumRock()
        node.position = pos
        addChild(node)
    }
    
    func addHook(hook: Hook) {
        let player = hook.player
        let x = player.position.x
        let y = player.position.y
        hook.position = CGPoint(x: x, y: y - Tuning.hookShortestLength)
        addChild(hook)
    }
    
    func addBomb(at pos: CGPoint) {
        let node = Goods(type: .bomb)
        node.size = CGSize(width: 20, height: 20)
        node.position = pos
        addChild(node)
        bombs.append(node)
    }
    
    func addBucket(at pos: CGPoint) {
        let node = Bucket()
        node.position = pos
        addChild(node)
    }
    
    func stretchRope(rope: SKSpriteNode, to pos: CGPoint) {
        let offset = pos - rope.position
        let length = offset.length
        let angle = atan2(offset.y, offset.x)
        rope.scale(to: CGSize(width: length, height: 1))
        rope.zRotation = angle
    }
    
    func exit() {
        if money >= GameSession.shared.goal {
            win()
        }
        else {
            //win()
            lose()
        }
    }
    
    func win() {
        GameSession.shared.nextLevel()
        
        let reveal = SKTransition.moveIn(with: .up, duration: 1)
        let newScene = ShopScene(size: size)
        view?.presentScene(newScene, transition: reveal)
    }
    
    func lose() {
        let reveal = SKTransition.moveIn(with: .down, duration: 1)
        let newScene = LoseScene(size: size)
        view?.presentScene(newScene, transition: reveal)
    }
    
    func canUseBomb(hook: Hook) -> Bool {
        let offset = hook.position - hook.player.position
        let length = offset.length
        return GameSession.shared.numberOfBomb > 0 && length > Tuning.hookShortestLength
    }
    
    func consumeBomb() {
        GameSession.shared.numberOfBomb -= 1
        // TODO: draw bombs
        let node = bombs.last
        node?.removeFromParent()
        bombs.removeLast()
    }
    
    override func update(_ currentTime: TimeInterval) {
        stretchRope(rope: rope1, to: hook1.position)
        stretchRope(rope: rope2, to: hook2.position)
        if hook1.outsideOfScreen() && hook1.canCatch {
            hook1.back()
        }
        if hook2.outsideOfScreen() && hook2.canCatch {
            hook2.back()
        }
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
            else if touchedNode == player1BombButton && canUseBomb(hook: hook1) {
                if let mineral = hook1.mineral {
                    consumeBomb()
                    mineral.getBombed()
                    hook1.backAfterBomb()
                }
            }
            else if touchedNode == player2BombButton && canUseBomb(hook: hook2) {
                if let mineral = hook2.mineral {
                    consumeBomb()
                    mineral.getBombed()
                    hook2.backAfterBomb()
                }
            }
            else if touchedNode == exitButton {
                removeAction(forKey: "timer")
                exit()
            }
        }
    }
    
    // MARK: lazy var
    lazy var hook1 = Hook(player: player1)
    
    lazy var hook2 = Hook(player: player2)
    
    lazy var player1: Player = {
        let node = Player()
        node.score = GameSession.shared.player1Score
        return node
    }()
    
    lazy var player2: Player = {
        let node = Player()
        node.score = GameSession.shared.player2Score
        return node
    }()
    
    lazy var rope1: SKSpriteNode = {
        let node = SKSpriteNode(color: .black, size: CGSize(width: 1, height: 1))
        node.anchorPoint = CGPoint(x: 0, y: 0)
        node.position = UIConfig.player1Position
        return node
    }()
    
    lazy var rope2: SKSpriteNode = {
        let node = SKSpriteNode(color: .black, size: CGSize(width: 1, height: 1))
        node.anchorPoint = CGPoint(x: 0, y: 0)
        node.position = UIConfig.player2Position
        return node
    }()
    
    // MARK: Button
    lazy var player1HookButton: SKSpriteNode = {
        let node = SKSpriteNode(color: UIConfig.joyButtonColor, size: CGSize(width: 50.width, height: 50.height))
        node.position = CGPoint(x: 60.width, y: 50.height)
        return node
    }()
    
    lazy var player2HookButton: SKSpriteNode = {
        let node = SKSpriteNode(color: UIConfig.joyButtonColor, size: CGSize(width: 50.width, height: 50.height))
        node.position = CGPoint(x: 740.width, y: 50.height)
        return node
    }()
    
    lazy var player1BombButton: SKSpriteNode = {
        let node = SKSpriteNode(color: UIConfig.joyButtonColor, size: CGSize(width: 50.width, height: 50.height))
        node.position = CGPoint(x: 60.width, y: 110.height)
        return node
    }()
    
    lazy var player2BombButton: SKSpriteNode = {
        let node = SKSpriteNode(color: UIConfig.joyButtonColor, size: CGSize(width: 50.width, height: 50.height))
        node.position = CGPoint(x: 740.width, y: 110.height)
        return node
    }()
    
    lazy var exitButton: SKSpriteNode = {
        let texture = SKTexture(image: UIImage(systemName: "arrow.right.to.line")!)
        let node = SKSpriteNode(texture: texture, color: .clear, size: CGSize(width: 20.width, height: 20.height))
        node.position = CGPoint(x: 680.width, y: 350.height)
        return node
    }()
    
    // MARK: label
    lazy var scoreLabel1: SKLabelNode = {
        let node = SKLabelNode()
        node.horizontalAlignmentMode = .right
        node.text = "player1: \(player1.score)"
        node.position = player1.position - CGPoint(x: 20, y: 0)
        node.fontSize = 12
        node.fontName = "PingFangTC-Semibold"
        node.fontColor = .brown
        return node
    }()
    
    lazy var scoreLabel2: SKLabelNode = {
        let node = SKLabelNode()
        node.horizontalAlignmentMode = .left
        node.text = "player2: \(player2.score)"
        node.position = player2.position + CGPoint(x: 20, y: 0)
        node.fontSize = 12
        node.fontName = "PingFangTC-Semibold"
        node.fontColor = .brown
        return node
    }()
    
    lazy var totalScoreLabel: SKLabelNode = {
        let node = SKLabelNode()
        node.horizontalAlignmentMode = .left
        node.text = "money: \(money)"
        node.position = CGPoint(x: 30.width, y: 360.height)
        node.fontSize = 14
        node.fontName = "PingFangTC-Semibold"
        node.fontColor = .brown
        return node
    }()
    
    lazy var requiredScoreLabel: SKLabelNode = {
        let node = SKLabelNode()
        node.horizontalAlignmentMode = .left
        node.text = "goal: \(GameSession.shared.goal)"
        node.position = totalScoreLabel.position - CGPoint(x: 0, y: 20)
        node.fontSize = 14
        node.fontName = "PingFangTC-Semibold"
        node.fontColor = .brown
        return node
    }()
    
    lazy var timeLabel: SKLabelNode = {
        let node = SKLabelNode()
        node.horizontalAlignmentMode = .left
        node.text = "time: \(time)"
        node.position = CGPoint(x: 720.width, y: 360.height)
        node.fontSize = 14
        node.fontName = "PingFangTC-Semibold"
        node.fontColor = .brown
        return node
    }()
    
    lazy var levelLabel: SKLabelNode = {
        let node = SKLabelNode()
        node.horizontalAlignmentMode = .left
        node.text = "level: \(GameSession.shared.level)"
        node.position = timeLabel.position - CGPoint(x: 0, y: 20)
        node.fontSize = 14
        node.fontName = "PingFangTC-Semibold"
        node.fontColor = .brown
        return node
    }()
    
    //MARK: background
    lazy var landNode: SKShapeNode = {
        let node = SKShapeNode(rect: CGRect(x: 0, y: 320.height, width: UIConfig.defaultWidth.width, height: 2))
        node.fillColor = .brown
        return node
    }()
}
