//
//  LoseScene.swift
//  GoldMiner
//
//  Created by 张翌璠 on 2021-05-20.
//

import SpriteKit
import GameplayKit
import GameKit

class LoseScene: SKScene {
    override func sceneDidLoad() {
        backgroundColor = .white
        addChild(loseLabel)
        addChild(scoreLabel)
        addChild(returnButton)
        
        if GKLocalPlayer.local.isAuthenticated {
            GameCenterHelper.helper.submitScore(score: GameSession.shared.player1Score + GameSession.shared.player2Score)
            alertPopup(text: "score submitted", at: CGPoint(x: 400, y: 100))
        }
        else {
            alertPopup(text: "login to game center to submit your score", at: CGPoint(x: 400, y: 100))
        }
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
        node.fontName = "Chalkduster"
        node.fontSize = 40
        node.fontColor = .red
        node.position = CGPoint(x: 400, y: 250)
        return node
    }()
    
    lazy var scoreLabel: SKLabelNode = {
        let node = SKLabelNode()
        node.text = "score: \(GameSession.shared.money)"
        node.fontName = "Chalkduster"
        node.fontSize = 40
        node.fontColor = .red
        node.position = CGPoint(x: 400, y: 200)
        return node
    }()
    
    lazy var returnButton: SKSpriteNode = {
        let texture = SKTexture(imageNamed: "exit")
        let node = SKSpriteNode(texture: texture, color: .clear, size: CGSize(width: 40, height: 40))
        node.position = CGPoint(x: 680, y: 360)
        return node
    }()
}
