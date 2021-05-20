//
//  Stone.swift
//  GoldMiner
//
//  Created by 张翌璠 on 2021-05-19.
//

import SpriteKit

class Rock: Mineral {
    init(mass: Int) {
        let diamondTexture = SKTexture(imageNamed: "random_bag")
        super.init(texture: diamondTexture, color: .clear, size: diamondTexture.size())
        
        self.mass = mass
        self.price = rockPrice[mass] ?? smallGoldMass
        self.backSpeed = goldBackSpeed[mass] ?? 80.0
        
        configurePhysiscs()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
