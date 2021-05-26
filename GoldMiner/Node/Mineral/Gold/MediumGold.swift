//
//  MediumGold.swift
//  GoldMiner
//
//  Created by 张翌璠 on 2021-05-22.
//

import SpriteKit

class MediumGold: Mineral {
    init() {
        let goldTexture = SKTexture(imageNamed: "medium_gold")
        let textSize = goldTexture.size()
        let size = CGSize(width: textSize.width / 3, height: textSize.height / 3)
        super.init(texture: goldTexture, color: .clear, size: size)
        
        price = Tuning.mediumGoldPrice
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        price = Tuning.mediumGoldPrice
    }
}
