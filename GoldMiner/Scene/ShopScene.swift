//
//  ShopScene.swift
//  GoldMiner
//
//  Created by 张翌璠 on 2021-05-19.
//

import SpriteKit
import GameplayKit

class ShopScene: SKScene {
    override func sceneDidLoad() {
        configureViews()
    }
    
    func configureViews() {
        initGoods()
        addChild(nextLevelButton)
    }
    
    func initGoods() {
        let num = Int.random(in: 1...5)
        let types = GoodsType.choose(num: num)
        var x = 100
        for good in types {
            let pos = CGPoint(x: x, y: 100)
            addGood(type: good, at: pos)
            x += 50
        }
        print(types)
    }
    
    func addGood(type: GoodsType, at pos: CGPoint) {
        let good = Goods(type: type)
        good.position = pos
        addChild(good)
    }
    
    func goToNextLevel() {
        let reveal = SKTransition.crossFade(withDuration: 1)
        let newScene = GameScene(size: CGSize(width: 480, height: 320))
        view?.presentScene(newScene, transition: reveal)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let touchedNode = atPoint(location)
            
            if let good = touchedNode as? Goods {
                good.takeEffect()
                good.removeFromParent()
                GameSession.shared.money -= good.price
            }
            else if touchedNode == nextLevelButton {
                goToNextLevel()
            }
        }
    }
    
    lazy var nextLevelButton: SKSpriteNode = {
        let node = SKSpriteNode(color: .red, size: CGSize(width: 50, height: 50))
        node.position = CGPoint(x: 430, y: 280)
        return node
    }()
    
    lazy var moneyLabel: SKLabelNode = {
        let node = SKLabelNode()
        node.text = "money: \(GameSession.shared.money)"
        node.position = CGPoint(x: 30, y: 300)
        node.fontSize = 14
        node.fontName = "PingFangTC-Semibold"
        node.fontColor = .brown
        return node
    }()
}
