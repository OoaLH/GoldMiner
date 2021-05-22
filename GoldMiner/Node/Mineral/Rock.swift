//
//  Stone.swift
//  GoldMiner
//
//  Created by 张翌璠 on 2021-05-19.
//

import SpriteKit

class Rock: Mineral {
    init(mass: Int) {
        let rockTexture = SKTexture(imageNamed: "rock")
        super.init(texture: rockTexture, color: .clear, size: rockTexture.size())
        
        self.mass = mass
        self.price = rockPrice[mass] ?? smallGoldMass
        self.backSpeed = goldBackSpeed[mass] ?? mediumSpeed
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
