//
//  OnlineShopScene.swift
//  GoldMiner
//
//  Created by 张翌璠 on 2021-05-23.
//

import SpriteKit
import GameplayKit
import GameKit

class OnlineShopScene: ShopScene {
    var time: Int = 8 {
        didSet {
            if time == 0 {
                removeAction(forKey: "timer")
                goToNextLevel()
            }
            timeLabel.text = "time: \(time)"
        }
    }
    
    var match: GKMatch
    
    init(match: GKMatch, size: CGSize) {
        self.match = match
        
        super.init(size: size)
        match.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureViews() {
        backgroundColor = .white
        initGoods()
        initLabels()
        initTimer()
    }
    
    override func initLabels() {
        super.initLabels()
        addChild(timeLabel)
    }
    
    override func buy(good: Goods) {
        sendBuyData(good: good)
        super.buy(good: good)
    }
    
    override func goToNextLevel() {
        let reveal = SKTransition.crossFade(withDuration: 1)
        let newScene = OnlineGameScene(size: size, match: match)
        view?.presentScene(newScene, transition: reveal)
    }
    
    func sendBuyData(good: Goods) {
        var message = Message(type: .bought, x: Float(good.position.x.realWidth), y: Float(good.position.y.realHeight))
        let data = NSData(bytes: &message, length: MemoryLayout<Message>.stride)
        
        do {
            try match.sendData(toAllPlayers: data as Data, with: .reliable)
        }
        catch {
            print("error")
        }
    }
    
    func initTimer() {
        let second = SKAction.wait(forDuration: 1)
        let countDown = SKAction.run {
            self.time -= 1
        }
        let action = SKAction.sequence([second, countDown])
        run(SKAction.repeatForever(action), withKey: "timer")
    }
    
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
}

extension OnlineShopScene: GKMatchDelegate {
    func match(_ match: GKMatch, didReceive data: Data, fromRemotePlayer player: GKPlayer) {
        let pointer = UnsafeMutablePointer<Message>.allocate(capacity: MemoryLayout<Message>.stride)
        let nsData = NSData(data: data)
        nsData.getBytes(pointer, length: MemoryLayout<Message>.stride)
        let message = pointer.move()
        print(123)
        print(message)
        if message.type == .bought {
            receiveBought(x: CGFloat(message.x), y: CGFloat(message.y))
        }
    }
    
    func match(_ match: GKMatch, player: GKPlayer, didChange state: GKPlayerConnectionState) {
        
    }
    
    func match(_ match: GKMatch, didFailWithError error: Error?) {
        
    }
    
    func receiveBought(x: CGFloat, y: CGFloat) {
        if let node = atPoint(CGPoint(x: x.width, y: y.height)) as? Goods {
            super.buy(good: node)
        }
    }
}
