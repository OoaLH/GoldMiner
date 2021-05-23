//
//  GameScene+SKPhysicsContactDelegate.swift
//  GoldMiner
//
//  Created by 张翌璠 on 2021-05-23.
//

import SpriteKit
import GameplayKit

extension GameScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        if firstBody.categoryBitMask.isMineral && secondBody.categoryBitMask.isHook {
            if let mineral = firstBody.node as? Mineral, let hook = secondBody.node as? Hook, canCatch(hook: hook, mineral: mineral) {
                hookCaughtMineral(hook: hook, mineral: mineral)
            }
            else if let bucket = firstBody.node as? Bucket, let hook = secondBody.node as? Hook {
                hookCaughtTNT(hook: hook, bucket: bucket)
            }
        }
        else if firstBody.categoryBitMask.isMineral && secondBody.categoryBitMask.isPlayer {
            if let mineral = firstBody.node as? Mineral, let player = secondBody.node as? Player, mineral.hook == player.hook {
                mineralArrived(mineral: mineral, at: player)
            }
        }
        else if firstBody.categoryBitMask.isMineral && secondBody.categoryBitMask.isWave {
            if let mineral = firstBody.node as? Mineral, mineral.hook == nil {
                mineral.getBombed()
            }
            else if let bucket = firstBody.node as? Bucket, bucket.wave != secondBody.node {
                bucket.explode()
            }
        }
    }
    
    func canCatch(hook: Hook, mineral: Mineral) -> Bool {
        return mineral.hook == nil && hook.mineral == nil && hook.canCatch
    }
    
    @objc func hookCaughtMineral(hook: Hook, mineral: Mineral) {
        let offset = hook.player.position - hook.position
        let length = offset.length
        let duration = TimeInterval(length / mineral.backSpeed)
        hook.fill(with: mineral)
        hook.back(for: duration)
        
        let vector = CGVector(dx: offset.x, dy: offset.y)
        mineral.hook = hook
        mineral.back(vector: vector, duration: duration)
    }
    
    @objc func hookCaughtTNT(hook: Hook, bucket: Bucket) {
        hook.back()
        bucket.explode()
    }
    
    @objc func mineralArrived(mineral: Mineral, at player: Player) {
        if let bag = mineral as? RandomBag {
            bag.takeEffect()
        }
        player.gainScore(price: mineral.price)
        money += mineral.price
        player.hook?.empty()
        player.hook?.swing()
        mineral.removeFromParent()
    }
}
