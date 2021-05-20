//
//  Diamond.swift
//  GoldMiner
//
//  Created by 张翌璠 on 2021-05-19.
//

import SpriteKit

class Diamond: SKSpriteNode, Mineral {
    var mass: Int = 50
    
    var price: Int = 800
    
    var backSpeed: CGFloat = diamondBackSpeed
    
    init() {
        let diamondTexture = SKTexture(imageNamed: "diamond")
        super.init(texture: diamondTexture, color: .clear, size: diamondTexture.size())
        
        configurePhysiscs()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
