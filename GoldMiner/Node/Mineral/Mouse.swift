//
//  Mouse.swift
//  GoldMiner
//
//  Created by 张翌璠 on 2021-05-19.
//

import SpriteKit

class Mouse: Mineral {    
    init() {
        let diamondTexture = SKTexture(imageNamed: "mouse")
        super.init(texture: diamondTexture, color: .clear, size: diamondTexture.size())
        
        self.mass = mouseMass
        self.price = mousePrice
        self.backSpeed = mouseBackSpeed
        
        configurePhysiscs()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func walkAround() {
        
    }
    
    override func back(vector: CGVector, duration: TimeInterval) {
        removeAllActions()
        let action = SKAction.move(by: vector, duration: duration)
        run(action)
    }
}
