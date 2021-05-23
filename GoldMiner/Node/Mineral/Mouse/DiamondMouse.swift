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
        //self.texture = SKTexture(imageNamed: "diamond_mouse")
        self.price = Tuning.mousePrice + Tuning.diamondPrice
        
        addChild(diamond)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var diamond: Diamond = {
        let node = Diamond()
        node.position = CGPoint(x: 10, y: 10)
        return node
    }()
}
