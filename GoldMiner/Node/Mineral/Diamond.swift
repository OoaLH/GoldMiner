//
//  Diamond.swift
//  GoldMiner
//
//  Created by 张翌璠 on 2021-05-19.
//

import SpriteKit

class Diamond: Mineral {
    init() {
        let diamondTexture = SKTexture(imageNamed: "diamond")
        super.init(texture: diamondTexture, color: .clear, size: diamondTexture.size())
        
        self.mass = diamondMass
        self.price = diamondPrice
        self.backSpeed = diamondBackSpeed
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
