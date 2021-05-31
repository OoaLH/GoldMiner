//
//  SKSceneExtension.swift
//  GoldMiner
//
//  Created by 张翌璠 on 2021-05-22.
//

import SpriteKit

extension SKScene {
    func alertPopup(text: String, at pos: CGPoint = CGPoint(x: UIConfig.defaultWidth / 2, y: UIConfig.defaultHeight / 2)) {
        let node = SKLabelNode()
        node.horizontalAlignmentMode = .center
        node.text = text
        node.position = pos
        node.fontName = "Chalkduster"
        node.fontSize = 20
        node.fontColor = .red
        addChild(node)
        let action = SKAction.moveBy(x: 0, y: 50, duration: 1)
        let fadeAction = SKAction.fadeOut(withDuration: 1)
        node.run(SKAction.sequence([action, fadeAction])) {
            node.removeFromParent()
        }
    }
    
    func exitToHomeWithDisconnection() {
        DispatchQueue.main.async {
            if let vc = self.view?.window?.rootViewController as? HomeViewController {
                vc.disconnected = true
                vc.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    func exitToHome() {
        DispatchQueue.main.async {
            self.view?.window?.rootViewController?.dismiss(animated: true, completion: nil)
        }
    }
}
