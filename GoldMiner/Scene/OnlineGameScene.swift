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
    var match: GKMatch
    
    var role: UInt32 = Role.player1
    
    var teamMate: GKPlayer
    
    var hook: Hook!
    
    var bombButton: SKSpriteNode!
    
    var shootButton: SKSpriteNode!
    
    var player: Player!
    
    var otherPlayer: Player!
    
    init(size: CGSize, match: GKMatch) {
        self.match = match
        self.teamMate = match.players.first!
        let name = GKLocalPlayer.local.displayName
        if self.teamMate.displayName < name {
            self.role = Role.player2
        }
        
        super.init(size: size)
        match.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
    
    override func win() {
        GameSession.shared.nextLevel()
        
        let reveal = SKTransition.moveIn(with: .up, duration: 1)
        let newScene = OnlineShopScene(match: match, size: size)
        view?.presentScene(newScene, transition: reveal)
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
    
    override func hookCaughtMineral(hook: Hook, mineral: Mineral) {
        sendCaughtData()
        super.hookCaughtMineral(hook: hook, mineral: mineral)
    }
    
    override func mineralArrived(mineral: Mineral, at player: Player) {
        sendArrivedData()
        super.mineralArrived(mineral: mineral, at: player)
    }
    
    override func hookCaughtTNT(hook: Hook, bucket: Bucket) {
        sendBucketData()
        super.hookCaughtTNT(hook: hook, bucket: bucket)
    }
    
    func sendShootData(hook: Hook) {
        let offset = hook.position
        var message = Message(type: .shot, x: Float(offset.x.realWidth), y: Float(offset.y.realHeight))
        let data = NSData(bytes: &message, length: MemoryLayout<Message>.stride)
        sendData(data: data)
    }
    
    func sendBombData() {
        var message = Message(type: .bombed, x: 0, y: 0)
        let data = NSData(bytes: &message, length: MemoryLayout<Message>.stride)
        sendData(data: data)
    }
    
    func sendCaughtData() {
        
    }
    
    func sendArrivedData() {
        
    }
    
    func sendBucketData() {
        
    }
    
    func sendData(data: NSData) {
        do {
            try match.sendData(toAllPlayers: data as Data, with: .reliable)
        }
        catch {
            print("error")
        }
    }
}

extension OnlineGameScene: GKMatchDelegate {
    func match(_ match: GKMatch, didReceive data: Data, fromRemotePlayer player: GKPlayer) {
        let pointer = UnsafeMutablePointer<Message>.allocate(capacity: MemoryLayout<Message>.stride)
        let nsData = NSData(data: data)
        nsData.getBytes(pointer, length: MemoryLayout<Message>.stride)
        let message = pointer.move()
        print(123)
        print(message)
        switch message.type {
        case .shot:
            receiveShot(x: CGFloat(message.x), y: CGFloat(message.y))
        case .bombed:
            receiveBombed()
        default:
            break
        }
    }
    
    func match(_ match: GKMatch, player: GKPlayer, didChange state: GKPlayerConnectionState) {
        
    }
    
    func match(_ match: GKMatch, didFailWithError error: Error?) {
        
    }
    
    func receiveShot(x: CGFloat, y: CGFloat) {
        print(123)
        print(x)
        print(y)
        otherPlayer.hook?.position = CGPoint(x: x.width, y: y.height)
        otherPlayer.hook?.shoot()
    }
    
    func receiveBombed() {
        consumeBomb()
        otherPlayer.hook?.mineral?.getBombed()
        otherPlayer.hook?.backAfterBomb()
    }
}
