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
        let size = CGSize(width: textSize.width / 3, height: textSize.height / 3)
        super.init(texture: goldTexture, color: .clear, size: size)
        
        price = Tuning.largeGoldPrice
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        price = Tuning.largeGoldPrice
    }
}
