//
//  Mouse.swift
//  GoldMiner
//
//  Created by 张翌璠 on 2021-05-19.
//

import SpriteKit

class Mouse: Mineral {
    var walkRange: CGFloat
    
    init() {
        self.walkRange = CGFloat.random(in: 50...100)
        
        let mouseTexture = SKTexture(imageNamed: "player")
        super.init(texture: mouseTexture, color: .clear, size: mouseTexture.size())
        
        self.mass = mouseMass
        self.price = mousePrice
        self.backSpeed = mouseBackSpeed
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func walkAround() {
        let duration = TimeInterval(self.walkRange / mouseWalkSpeed)
        let leftAction = SKAction.moveBy(x: -self.walkRange, y: 0, duration: duration)
        let waitAction = SKAction.wait(forDuration: mousePauseDuration)
        let rightAction = SKAction.moveBy(x: self.walkRange, y: 0, duration: duration)
        let action = SKAction.sequence([leftAction, waitAction, rightAction, waitAction])
        run(SKAction.repeatForever(action))
    }
    
    override func back(vector: CGVector, duration: TimeInterval) {
        removeAllActions()
        let action = SKAction.move(by: vector, duration: duration)
        run(action)
    }
}
