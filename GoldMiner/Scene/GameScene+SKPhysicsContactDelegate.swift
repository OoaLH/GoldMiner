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
        else if firstBody.categoryBitMask.isHook && secondBody.categoryBitMask.isPlayer {
            if let hook = firstBody.node as? Hook, let player = secondBody.node as? Player, let mineral = hook.mineral, hook == player.hook {
                hookArrived(mineral: mineral, at: player)
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
        return mineral.hook == nil && hook.mineral == nil && hook.isShooting
    }
    
    @objc func hookCaughtMineral(hook: Hook, mineral: Mineral) {
        let offset = hook.player.position - hook.position
        let length = offset.length
        let duration = TimeInterval(length / mineral.backSpeed)
        hook.fill(with: mineral)
        hook.back(for: duration)
        
        let vector = CGVector(dx: offset.x, dy: offset.y)
        mineral.delegate = self
        mineral.hook = hook
        mineral.back(vector: vector, duration: duration)
        
        hook.player.drag()
    }
    
    func hookCaughtTNT(hook: Hook, bucket: Bucket) {
        hook.back()
        bucket.explode()
    }
    
    @objc func hookArrived(mineral: Mineral, at player: Player) {
        player.hook?.empty()
        player.hook?.swing()
        player.stopDrag()
        mineralArrived(mineral: mineral, at: player)
    }
    
    func mineralArrived(mineral: Mineral, at player: Player) {
        if let bag = mineral as? RandomBag {
            bag.takeEffect()
        }
        player.gainScore(price: mineral.price)
        money += mineral.price
        if mineral.price != 0 {
            alertPopup(text: "+$\(mineral.price)", at: player.position - CGPoint(x: 40, y: 40))
        }
        if mineral.hook?.isShooting ?? false {
            player.stopDrag()
        }
        mineral.removeFromParent()
    }
}

extension GameScene: MineralDelegate {
    func arrived(mineral: Mineral, at player: Player) {
        mineralArrived(mineral: mineral, at: player)
    }
}
