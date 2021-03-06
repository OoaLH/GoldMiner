//
//  Stone.swift
//  GoldMiner
//
//  Created by 张翌璠 on 2021-05-19.
//

import SpriteKit

class SmallRock: Mineral {
    init() {
        let rockTexture = SKTexture(imageNamed: "small_rock")
        let textSize = rockTexture.size()
        let size = CGSize(width: textSize.width / 4, height: textSize.height / 4)
        super.init(texture: rockTexture, color: .clear, size: size)
        
        price = Tuning.smallRockPrice
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        price = Tuning.smallRockPrice
    }
}
