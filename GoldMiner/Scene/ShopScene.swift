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
        backgroundColor = .white
        initGoods()
        initLabels()
        initButtons()
    }
    
    func initGoods() {
        let num = Int.random(in: 1...5)
        let types = GoodsType.choose(num: num)
        var x = 100.width
        for good in types {
            let pos = CGPoint(x: x, y: 100.height)
            addGood(type: good, at: pos)
            x += 100.width
        }
    }
    
    func initLabels() {
        addChild(moneyLabel)
    }
    
    func initButtons() {
        addChild(nextLevelButton)
    }
    
    func addGood(type: GoodsType, at pos: CGPoint) {
        let good = Goods(type: type)
        good.anchorPoint = CGPoint(x: 0.5, y: 0)
        good.position = pos
        addChild(good)
        addPriceLabel(good: good)
    }
    
    func addPriceLabel(good: Goods) {
        let node = SKLabelNode()
        node.horizontalAlignmentMode = .center
        node.position = good.position - CGPoint(x: 0, y: 20)
        node.text = "$\(good.price)"
        node.fontColor = .systemGreen
        node.fontName = "PingFangTC-Semibold"
        node.fontSize = 12
        addChild(node)
        good.priceLabel = node
    }
    
    func buy(good: Goods) {
        good.takeEffect()
        good.removeFromParent()
        good.priceLabel?.removeFromParent()
        GameSession.shared.money -= good.price
        moneyLabel.text = "money: \(GameSession.shared.money)"
    }
    
    func goToNextLevel() {
        let reveal = SKTransition.crossFade(withDuration: 1)
        let newScene = GameScene(size: size)
        view?.presentScene(newScene, transition: reveal)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let touchedNode = atPoint(location)
            
            if let good = touchedNode as? Goods {
                if good.price <= GameSession.shared.money {
                    buy(good: good)
                }
                else {
                    alertPopup(text: "not enough money")
                }
            }
            else if touchedNode == nextLevelButton {
                goToNextLevel()
            }
        }
    }
    
    lazy var nextLevelButton: SKSpriteNode = {
        let node = SKSpriteNode(color: .red, size: CGSize(width: 50, height: 50))
        node.position = CGPoint(x: 680.width, y: 350.height)
        return node
    }()
    
    lazy var moneyLabel: SKLabelNode = {
        let node = SKLabelNode()
        node.horizontalAlignmentMode = .left
        node.text = "money: \(GameSession.shared.money)"
        node.position = CGPoint(x: 30.width, y: 360.height)
        node.fontSize = 14
        node.fontName = "PingFangTC-Semibold"
        node.fontColor = .brown
        return node
    }()
}
