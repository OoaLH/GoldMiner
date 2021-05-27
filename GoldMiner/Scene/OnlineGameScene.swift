//
//  OnlineGameScene.swift
//  GoldMiner
//
//  Created by 张翌璠 on 2021-05-23.
//

import SpriteKit
import GameplayKit
import GameKit

class OnlineGameScene: GameScene {
    var match: GKMatch? {
        didSet {
            guard let match = match else {
                return
            }
            teamMate = match.players.first
            match.delegate = self
        }
    }
    
    var role: UInt32 = Role.player1 {
        didSet {
            initButtons()
            initMinerals()
        }
    }
    
    var teamMate: GKPlayer? {
        didSet {
            guard let teamMate = teamMate else {
                exitToHome()
                return
            }
            let name = GKLocalPlayer.local.displayName
            if teamMate.displayName < name {
                role = Role.player2
            }
            else {
                role = Role.player1
            }
        }
    }
    
    var hook: Hook!
    
    var bombButton: SKSpriteNode!
    
    var shootButton: SKSpriteNode!
    
    var player: Player!
    
    var otherPlayer: Player!
    
    override func configureViews() {
        initBackground()
        isUserInteractionEnabled = false
        initPlayers()
        initHooks()
        initLabels()
        initBombs()
    }
    
    override func initLabels() {
        super.initLabels()
        addChild(loadingLabel)
    }
    
    override func initButtons() {
        player = role == Role.player1 ? player1 : player2
        otherPlayer = role == Role.player1 ? player2 : player1
        hook = role == Role.player1 ? hook1 : hook2
        bombButton = role == Role.player1 ? player1BombButton : player2BombButton
        shootButton = role == Role.player1 ? player1HookButton : player2HookButton
        addChild(bombButton)
        addChild(shootButton)
    }
    
    override func initMinerals() {
        if role == Role.player2 {
            return
        }
        let rand = Int.random(in: 3...7)
        for _ in 0..<rand {
            let x = CGFloat.random(in: 40...760)
            let y = CGFloat.random(in: 40...280)
            addSmallGold(at: CGPoint(x: x, y: y))
            sendSmallGoldData(x: x, y: y)
        }
        sendGoldFinishData()
    }
    
    override func win() {
        guard let match = match else {
            return
        }
        GameSession.shared.nextLevel()
        
        let reveal = SKTransition.moveIn(with: .up, duration: 1)
        let newScene = OnlineShopScene(match: match, size: size, role: role)
        newScene.scaleMode = .aspectFit
        view?.presentScene(newScene, transition: reveal)
    }
    
    override func hookCaughtMineral(hook: Hook, mineral: Mineral) {
        if let mineral = mineral as? RandomBag {
            mineral.getOnlineModeContent()
        }
        super.hookCaughtMineral(hook: hook, mineral: mineral)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let touchedNode = atPoint(location)
            
            if touchedNode == shootButton && hook.canShoot {
                sendShootData(hook: hook)
                hook.shoot()
            }
            else if touchedNode == bombButton && canUseBomb(hook: hook) {
                if let mineral = hook.mineral {
                    sendBombData()
                    consumeBomb()
                    mineral.getBombed()
                    hook.backAfterBomb()
                }
            }
        }
    }
    
    func sendSmallGoldData(x: CGFloat, y: CGFloat) {
        var message = Message(type: .smallGold, x: Float(x), y: Float(y))
        let data = NSData(bytes: &message, length: MemoryLayout<Message>.stride)
        sendData(data: data)
    }
    
    func sendGoldFinishData() {
        var message = Message(type: .smallGoldFinish, x: 0, y: 0)
        let data = NSData(bytes: &message, length: MemoryLayout<Message>.stride)
        sendData(data: data)
    }
    
    func sendSmallGoldReply() {
        var message = Message(type: .smallGoldReply, x: 0, y: 0)
        let data = NSData(bytes: &message, length: MemoryLayout<Message>.stride)
        sendData(data: data)
    }
    
    func sendShootData(hook: Hook) {
        let offset = hook.position
        var message = Message(type: .shot, x: Float(offset.x), y: Float(offset.y))
        let data = NSData(bytes: &message, length: MemoryLayout<Message>.stride)
        sendData(data: data)
    }
    
    func sendBombData() {
        var message = Message(type: .bombed, x: 0, y: 0)
        let data = NSData(bytes: &message, length: MemoryLayout<Message>.stride)
        sendData(data: data)
    }
    
    func sendData(data: NSData) {
        do {
            try match?.sendData(toAllPlayers: data as Data, with: .reliable)
        }
        catch {
            print("error")
        }
    }
    
    func start() {
        loadingLabel.removeFromParent()
        NotificationCenter.default.post(name: .startWalk, object: nil)
        isUserInteractionEnabled = true
        initTimer()
    }
    
    lazy var loadingLabel: SKLabelNode = {
        let node = SKLabelNode()
        node.horizontalAlignmentMode = .center
        node.text = "Loading..."
        node.fontSize = 20
        node.fontName = "Chalkduster"
        node.fontColor = .red
        node.position = CGPoint(x: 400, y: 186)
        return node
    }()
}

extension OnlineGameScene: GKMatchDelegate {
    func match(_ match: GKMatch, didReceive data: Data, fromRemotePlayer player: GKPlayer) {
        let pointer = UnsafeMutablePointer<Message>.allocate(capacity: MemoryLayout<Message>.stride)
        let nsData = NSData(data: data)
        nsData.getBytes(pointer, length: MemoryLayout<Message>.stride)
        let message = pointer.move()
        switch message.type {
        case .shot:
            receiveShot(x: CGFloat(message.x), y: CGFloat(message.y))
        case .bombed:
            receiveBombed()
        case .smallGold:
            receiveSmallGold(x: CGFloat(message.x), y: CGFloat(message.y))
        case .smallGoldReply:
            start()
        case .smallGoldFinish:
            receiveSmallGoldFinish()
        default:
            break
        }
    }
    
    func match(_ match: GKMatch, player: GKPlayer, didChange state: GKPlayerConnectionState) {
        exitToHome()
    }
    
    func match(_ match: GKMatch, didFailWithError error: Error?) {
        exitToHome()
    }
    
    func receiveSmallGold(x: CGFloat, y: CGFloat) {
        addSmallGold(at: CGPoint(x: x, y: y))
    }
    
    func receiveSmallGoldFinish() {
        sendSmallGoldReply()
        start()
    }
    
    func receiveShot(x: CGFloat, y: CGFloat) {
        otherPlayer.hook?.position = CGPoint(x: x, y: y)
        otherPlayer.hook?.shoot()
    }
    
    func receiveBombed() {
        consumeBomb()
        otherPlayer.hook?.mineral?.getBombed()
        otherPlayer.hook?.backAfterBomb()
    }
}
