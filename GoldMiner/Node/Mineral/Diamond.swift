//
//  Diamond.swift
//  GoldMiner
//
//  Created by 张翌璠 on 2021-05-19.
//

import SpriteKit

class Diamond: Mineral {
    override var backSpeed: CGFloat {
        return Tuning.fastSpeed
    }
    
    init() {
        let diamondTexture = SKTexture(imageNamed: "diamond")
        let textSize = diamondTexture.size()
        let size = CGSize(width: textSize.width.height / 8, height: textSize.height.height / 8)
        super.init(texture: diamondTexture, color: .clear, size: size)
        
        self.price = Tuning.diamondPrice
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.price = Tuning.diamondPrice
    }
}
