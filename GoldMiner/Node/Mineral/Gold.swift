//
//  Gold.swift
//  GoldMiner
//
//  Created by 张翌璠 on 2021-05-19.
//

import SpriteKit

class Gold: Mineral {
    init(mass: Int) {
        let goldTexture = SKTexture(imageNamed: "monster")
        let size = goldTexture.size()
        let width = size.width
        let height = size.height
        let ratio = CGFloat(1)//CGFloat(mass / smallGoldMass)
        //print(size)
        let goldSize = CGSize(width: width * ratio, height: height * ratio)
        super.init(texture: goldTexture, color: .clear, size: goldSize)
        
        self.mass = mass
        self.price = mass
        self.backSpeed = goldBackSpeed[mass] ?? 80.0
        
        configurePhysiscs()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
