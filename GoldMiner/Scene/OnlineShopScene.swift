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
    
    var role: UInt32
    
    var goods: [Goods?] = []
    
    init(match: GKMatch, size: CGSize, role: UInt32) {
        self.match = match
        self.role = role
        
        super.init(size: size)
        if role == Role.player1 {
            sendMoneyData()
        }
        match.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureViews() {
        backgroundColor = .white
        isUserInteractionEnabled = false
        if role == Role.player1 {
            initGoods()
        }
        initLabels()
    }
    
    override func initGoods() {
        let num = Int.random(in: 1...5)
        let types = GoodsType.choose(num: num)
        var x = 100
        for good in types {
            let pos = CGPoint(x: x, y: 100)
            addGood(type: good, at: pos)
            x += 100
        }
        sendGoodsData(types: types)
    }
    
    override func addGood(type: GoodsType, at pos: CGPoint) {
        let good = Goods(type: type)
        good.anchorPoint = CGPoint(x: 0.5, y: 0)
        good.position = pos
        addChild(good)
        addPriceLabel(good: good)
        goods.append(good)
    }
    
    override func initLabels() {
        super.initLabels()
        addChild(timeLabel)
        addChild(loadingLabel)
    }
    
    override func buy(good: Goods) {
        sendBuyData(good: good)
        let index = Int(good.position.x / 100) - 1
        goods[index] = nil
        super.buy(good: good)
    }
    
    override func goToNextLevel() {
        let reveal = SKTransition.crossFade(withDuration: 1)
        let level = GameSession.shared.level > 10 ? GameSession.shared.level % 7 : GameSession.shared.level
        guard let scene = OnlineGameScene(fileNamed: "level\(level)") else {
            return
        }
        scene.match = match
        scene.size = size
        scene.scaleMode = .aspectFit
        view?.presentScene(scene, transition: reveal)
    }
    
    func sendMoneyData() {
        var message = Message(type: .money, x: Float(GameSession.shared.player1Score), y: Float(GameSession.shared.player2Score))
        let data = NSData(bytes: &message, length: MemoryLayout<Message>.stride)
        sendData(data: data)
    }
    
    func sendGoodsData(types: [GoodsType]) {
        var s = ""
        _ = types.map({ goods in
            s += String(goods.rawValue)
        })
        var message = Message(type: .goods, x: Float(s) ?? 1, y: 0)
        let data = NSData(bytes: &message, length: MemoryLayout<Message>.stride)
        sendData(data: data)
    }
    
    func sendGoodsReply() {
        var message = Message(type: .goodsReply, x: 0, y: 0)
        let data = NSData(bytes: &message, length: MemoryLayout<Message>.stride)
        sendData(data: data)
    }
    
    func sendBuyData(good: Goods) {
        var message = Message(type: .bought, x: Float(good.position.x/100), y: 0)
        let data = NSData(bytes: &message, length: MemoryLayout<Message>.stride)
        sendData(data: data)
    }
    
    func sendData(data: NSData) {
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
        node.position = CGPoint(x: 720, y: 360)
        node.fontSize = 14
        node.fontName = "Chalkduster"
        node.fontColor = .brown
        return node
    }()
    
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

extension OnlineShopScene: GKMatchDelegate {
    func match(_ match: GKMatch, didReceive data: Data, fromRemotePlayer player: GKPlayer) {
        let pointer = UnsafeMutablePointer<Message>.allocate(capacity: MemoryLayout<Message>.stride)
        let nsData = NSData(data: data)
        nsData.getBytes(pointer, length: MemoryLayout<Message>.stride)
        let message = pointer.move()
        switch message.type {
        case .bought:
            receiveBought(x: Int(message.x))
        case .goods:
            receiveGoods(types: String(Int(message.x)))
        case .goodsReply:
            start()
        case .money:
            receiveMoneyData(score1: Int(message.x), score2: Int(message.y))
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
    
    func receiveBought(x: Int) {
        if let good = goods[x - 1] {
            super.buy(good: good)
            goods[x - 1] = nil
        }
    }
    
    func receiveGoods(types: String) {
        var x = 100
        for char in types {
            let pos = CGPoint(x: x, y: 100)
            let type = GoodsType(rawValue: char.wholeNumberValue ?? 1) ?? .bomb
            addGood(type: type, at: pos)
            x += 100
        }
        sendGoodsReply()
        start()
    }
    
    func start() {
        loadingLabel.removeFromParent()
        initTimer()
        isUserInteractionEnabled = true
    }
    
    func receiveMoneyData(score1: Int, score2: Int) {
        if GameSession.shared.player1Score != score1 {
            GameSession.shared.money += (score1 - GameSession.shared.player1Score)
            GameSession.shared.player1Score = score1
        }
        if GameSession.shared.player2Score != score2 {
            GameSession.shared.money += (score2 - GameSession.shared.player2Score)
            GameSession.shared.player2Score = score2
        }
        
        moneyLabel.text = "money: \(GameSession.shared.money)"
    }
}
