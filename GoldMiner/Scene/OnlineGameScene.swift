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
            player = role == Role.player1 ? player1 : player2
            otherPlayer = role == Role.player1 ? player2 : player1
            hook = role == Role.player1 ? hook1 : hook2
            bombButton = role == Role.player1 ? player1BombButton : player2BombButton
            shootButton = role == Role.player1 ? player1HookButton : player2HookButton
            addChild(bombButton)
            addChild(shootButton)
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
    
    override func initButtons() {}
    
    override func win() {
        guard let match = match else {
            return
        }
        GameSession.shared.nextLevel()
        
        let reveal = SKTransition.moveIn(with: .up, duration: 1)
        let newScene = OnlineShopScene(match: match, size: size, role: role)
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
    
    func sendData(data: NSData) {
        do {
            try match?.sendData(toAllPlayers: data as Data, with: .reliable)
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
        exitToHome()
    }
    
    func match(_ match: GKMatch, didFailWithError error: Error?) {
        exitToHome()
    }
    
    func receiveShot(x: CGFloat, y: CGFloat) {
        otherPlayer.hook?.position = CGPoint(x: x.width, y: y.height)
        otherPlayer.hook?.shoot()
    }
    
    func receiveBombed() {
        consumeBomb()
        otherPlayer.hook?.mineral?.getBombed()
        otherPlayer.hook?.backAfterBomb()
    }
}
