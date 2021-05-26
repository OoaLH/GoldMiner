//
//  LoseScene.swift
//  GoldMiner
//
//  Created by 张翌璠 on 2021-05-20.
//

import SpriteKit
import GameplayKit

class LoseScene: SKScene {
    override func sceneDidLoad() {
        addChild(loseLabel)
        addChild(returnButton)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let touchedNode = atPoint(location)
            
            if touchedNode == returnButton {
                exitToHome()
            }
        }
    }
    
    lazy var loseLabel: SKLabelNode = {
        let node = SKLabelNode()
        node.text = "you lose"
        node.position = CGPoint(x: 400, y: 100)
        return node
    }()
    
    lazy var returnButton: SKSpriteNode = {
        let node = SKSpriteNode(color: .red, size: CGSize(width: 50, height: 50))
        node.position = CGPoint(x: 680, y: 350)
        return node
    }()
}
