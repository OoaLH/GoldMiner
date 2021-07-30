//
//  Player.swift
//  GoldMiner
//
//  Created by 张翌璠 on 2021-05-19.
//

import SpriteKit

class Player: SKSpriteNode {
    weak var hook: Hook?
    
    var score: Int = 0
    
    var skinType: SkinType
    
    init(skinType: SkinType) {
        self.skinType = skinType
        let texture = SKTexture(imageNamed: skinType.rawValue)
        var size = texture.size()
        if skinType != .pig {
            size = CGSize(width: size.width * 0.75, height: size.height * 0.75)
        }
        super.init(texture: texture, color: .clear, size: size)
        anchorPoint = CGPoint(x: 0.5, y: 0.4)
        configurePhysics()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configurePhysics() {
        if let texture = texture {
            physicsBody = SKPhysicsBody(texture: texture, alphaThreshold: 0.1, size: size)
        }
        physicsBody?.categoryBitMask = PhysicsCategory.player.rawValue
        physicsBody?.contactTestBitMask = PhysicsCategory.hook.rawValue
        physicsBody?.collisionBitMask = PhysicsCategory.none.rawValue
    }
    
    func setSkin(skinType: SkinType) {
        self.skinType = skinType
        
        let texture = SKTexture(imageNamed: skinType.rawValue)
        
        self.texture = texture
        size = texture.size()
        
        if skinType != .pig {
            
        }
        
        dragFrames = SKAction.animate(with: generateFrames(),
                                      timePerFrame: 0.1,
                                      resize: false,
                                      restore: true)
    }
    
    func gainScore(price: Int) {
        score += price
    }
    
    func drag() {
        run(SKAction.repeatForever(dragFrames), withKey: "drag")
    }
    
    func stopDrag() {
        removeAction(forKey: "drag")
    }
    
    func generateFrames() -> [SKTexture] {
        var frames = [SKTexture]()
        let atlas = SKTextureAtlas(named: skinType.rawValue)
        let numImages = atlas.textureNames.count
        for i in 1...numImages {
            let textureName = skinType.rawValue + String(i)
            frames.append(atlas.textureNamed(textureName))
        }
        return frames
    }
    
    lazy var dragFrames: SKAction = {
        let frames = generateFrames()
        return SKAction.animate(with: frames,
                                timePerFrame: 0.1,
                                resize: false,
                                restore: true)
    }()
}
