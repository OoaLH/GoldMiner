//
//  RandomBag.swift
//  GoldMiner
//
//  Created by 张翌璠 on 2021-05-19.
//

import SpriteKit

class RandomBag: Mineral {
    init() {
        let diamondTexture = SKTexture(imageNamed: "random_bag")
        super.init(texture: diamondTexture, color: .clear, size: diamondTexture.size())
        
        //FIXME: random
        self.mass = mouseMass
        self.price = mousePrice
        self.backSpeed = mouseBackSpeed
        
        configurePhysiscs()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
