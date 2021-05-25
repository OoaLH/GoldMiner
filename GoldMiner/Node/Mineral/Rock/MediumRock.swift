//
//  MediumRock.swift
//  GoldMiner
//
//  Created by 张翌璠 on 2021-05-22.
//

import SpriteKit

class MediumRock: Mineral {
    override var backSpeed: CGFloat {
        return Tuning.slowSpeed
    }
    
    init() {
        let rockTexture = SKTexture(imageNamed: "medium_rock")
        let textSize = rockTexture.size()
        let size = CGSize(width: textSize.width.height / 4, height: textSize.height.height / 4)
        super.init(texture: rockTexture, color: .clear, size: size)
        
        self.price = Tuning.mediumRockPrice
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.price = Tuning.mediumRockPrice
    }
}
