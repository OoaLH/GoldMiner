//
//  LargeGold.swift
//  GoldMiner
//
//  Created by 张翌璠 on 2021-05-22.
//

import SpriteKit

class LargeGold: Mineral {
    override var backSpeed: CGFloat {
        return Tuning.slowSpeed
    }
    
    init() {
        let goldTexture = SKTexture(imageNamed: "large_gold")
        let textSize = goldTexture.size()
        let size = CGSize(width: textSize.width.height / 3, height: textSize.height.height / 3)
        super.init(texture: goldTexture, color: .clear, size: size)
        
        self.price = Tuning.largeGoldPrice
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.price = Tuning.largeGoldPrice
    }
}
