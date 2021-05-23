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
        let size = CGSize(width: textSize.width.height / 3, height: textSize.height.height / 3)
        super.init(texture: goldTexture, color: .clear, size: size)
        
        self.price = Tuning.mediumGoldPrice
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
