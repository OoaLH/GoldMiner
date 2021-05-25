//
//  Gold.swift
//  GoldMiner
//
//  Created by 张翌璠 on 2021-05-19.
//

import SpriteKit

class SmallGold: Mineral {
    override var backSpeed: CGFloat {
        return Tuning.fastSpeed
    }
    
    init() {
        let goldTexture = SKTexture(imageNamed: "small_gold")
        let textSize = goldTexture.size()
        let size = CGSize(width: textSize.width.height / 3, height: textSize.height.height / 3)
        super.init(texture: goldTexture, color: .clear, size: size)
        
        self.price = Tuning.smallGoldPrice
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.price = Tuning.smallGoldPrice
    }
}
