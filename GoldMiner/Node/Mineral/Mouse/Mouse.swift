//
//  Mouse.swift
//  GoldMiner
//
//  Created by 张翌璠 on 2021-05-19.
//

import SpriteKit

class Mouse: Mineral {
    var walkRange: CGFloat
    
    var walkFrames: [SKTexture] = []
    
    override var backSpeed: CGFloat {
        return Tuning.fastSpeed
    }
    
    init() {
        self.walkRange = CGFloat.random(in: 50...100)
        
        //let mouseTexture = SKTexture(imageNamed: "mouse")
        let bearAnimatedAtlas = SKTextureAtlas(named: "BearImages")
        let numImages = bearAnimatedAtlas.textureNames.count
        for i in 1...numImages {
            let bearTextureName = "bear\(i)"
            walkFrames.append(bearAnimatedAtlas.textureNamed(bearTextureName))
        }
        
        super.init(texture: walkFrames[0], color: .clear, size: CGSize(width: 30, height: 20))
        self.price = Tuning.mousePrice
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func walkAround() {
        let duration = TimeInterval(self.walkRange / Tuning.mouseWalkSpeed)
        let mirror = SKAction.run {
            self.xScale = -self.xScale
        }
        let leftAction = SKAction.moveBy(x: -self.walkRange, y: 0, duration: duration)
        let waitAction = SKAction.wait(forDuration: Tuning.mousePauseDuration)
        let rightAction = SKAction.moveBy(x: self.walkRange, y: 0, duration: duration)
        let action = SKAction.sequence([leftAction, mirror, waitAction, rightAction, mirror, waitAction])
        run(SKAction.repeatForever(action))
        
        let frames = SKAction.animate(with: walkFrames,
                                      timePerFrame: 0.1,
                                      resize: false,
                                      restore: true)
        run(SKAction.repeatForever(frames), withKey:"walkingInPlaceBear")
    }
    
    override func back(vector: CGVector, duration: TimeInterval) {
        removeAllActions()
        let action = SKAction.move(by: vector, duration: duration)
        run(action)
    }
}
