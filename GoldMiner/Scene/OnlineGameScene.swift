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
    
    var teamMate: GKPlayer!
    
    var hook: Hook!
    
    var bombButton: SKSpriteNode!
    
    var shootButton: SKSpriteNode!
    
    init(size: CGSize, match: GKMatch) {
        self.match = match
        let id = GKLocalPlayer.local.gamePlayerID
        
        super.init(size: size)
        
        _ = match.players.map({ player in
            if player.gamePlayerID == id {
                return
            }
            teamMate = player
            if player.gamePlayerID > id {
                role = Role.player2
            }
        })
        hook = role == Role.player1 ? hook1 : hook2
        bombButton = role == Role.player1 ? player1BombButton : player2BombButton
        shootButton = role == Role.player1 ? player1HookButton : player2HookButton
        match.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func initButtons() {
        if role == Role.player1 {
            addChild(player1HookButton)
            addChild(player1BombButton)
        }
        else {
            addChild(player2HookButton)
            addChild(player2BombButton)
        }
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
                sendShootData()
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
    
    func sendShootData() {
        
    }
    
    func sendBombData() {
        
    }
    
    func sendCaughtData() {
        
    }
    
    func sendArrivedData() {
        
    }
    
    func sendBucketData() {
        
    }
    
    func sendData(data: Data) {
        do {
            try match.sendData(toAllPlayers: data, with: .reliable)
        }
        catch {
            print("error")
        }
    }
}

extension OnlineGameScene: GKMatchDelegate {
    func match(_ match: GKMatch, didReceive data: Data, fromRemotePlayer player: GKPlayer) {
        
    }
    
    func match(_ match: GKMatch, player: GKPlayer, didChange state: GKPlayerConnectionState) {
        
    }
}
