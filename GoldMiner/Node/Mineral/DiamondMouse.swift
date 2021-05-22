//
//  DiamondMouse.swift
//  GoldMiner
//
//  Created by 张翌璠 on 2021-05-20.
//

import SpriteKit

class DiamondMouse: Mouse {
    override init() {
        super.init()
        
        self.price = mousePrice + diamondPrice
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
