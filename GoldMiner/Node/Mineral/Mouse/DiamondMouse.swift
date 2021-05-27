//
//  DiamondMouse.swift
//  GoldMiner
//
//  Created by 张翌璠 on 2021-05-20.
//

import SpriteKit

class DiamondMouse: Mineral {
    var walkRange: CGFloat = 150
    
    var walkFrames: [SKTexture] = []
    
    override var backSpeed: CGFloat {
        return Tuning.fastSpeed
    }
    
    init() {
        walkRange = CGFloat.random(in: 50...100)
        
        let atlas = SKTextureAtlas(named: "diamond_mouse")
        let numImages = atlas.textureNames.count
        for i in 1...numImages {
            let textureName = "diamond_mouse\(i)"
            walkFrames.append(atlas.textureNamed(textureName))
        }
        
        super.init(texture: walkFrames[0], color: .clear, size: CGSize(width: 31.4, height: 16.8))
        price = Tuning.mousePrice
        walkAround()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        price = Tuning.mousePrice + Tuning.diamondPrice
        walkRange = CGFloat(self.userData?["range"] as? Float ?? 150)
        
        NotificationCenter.default.addObserver(self, selector: #selector(startWalk(_:)), name: .startWalk, object: nil)
    }
    
    @objc func startWalk(_ notification: Notification) {
        moveAround()
    }
    
    func walkAround() {
        moveAround()
        
        let frames = SKAction.animate(with: walkFrames,
                                      timePerFrame: 0.1,
                                      resize: false,
                                      restore: true)
        run(SKAction.repeatForever(frames), withKey:"walking")
    }
    
    func moveAround() {
        let duration = TimeInterval(self.walkRange / Tuning.mouseWalkSpeed)
        let mirror = SKAction.run {
            self.xScale = -self.xScale
        }
        let leftAction = SKAction.moveBy(x: -self.walkRange, y: 0, duration: duration)
        let waitAction = SKAction.wait(forDuration: Tuning.mousePauseDuration)
        let rightAction = SKAction.moveBy(x: self.walkRange, y: 0, duration: duration)
        let action = SKAction.sequence([leftAction, mirror, waitAction, rightAction, mirror, waitAction])
        run(SKAction.repeatForever(action))
    }
    
    override func back(vector: CGVector, duration: TimeInterval) {
        removeAllActions()
        let action = SKAction.move(by: vector, duration: duration)
        run(action)
    }
}
