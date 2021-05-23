//
//  SKSceneExtension.swift
//  GoldMiner
//
//  Created by 张翌璠 on 2021-05-22.
//

import SpriteKit

extension SKScene {
    func alertPopup(text: String) {
        let node = SKLabelNode()
        node.horizontalAlignmentMode = .center
        node.text = text
        node.position = CGPoint(x: 400.width, y: 186.height)
        node.fontName = "PingFangTC-Semibold"
        node.fontSize = 20
        node.fontColor = .red
        addChild(node)
        let action = SKAction.moveBy(x: 0, y: 50, duration: 1)
        let fadeAction = SKAction.fadeOut(withDuration: 1)
        node.run(SKAction.sequence([action, fadeAction])) {
            node.removeFromParent()
        }
    }
}
