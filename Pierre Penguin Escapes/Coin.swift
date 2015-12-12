//
//  Coin.swift
//  Pierre Penguin Escapes
//
//  Created by Saurabh Sikka on 10/12/15.
//  Copyright © 2015 Saurabh Sikka. All rights reserved.
//

import Foundation
import SpriteKit

class Coin: SKSpriteNode, GameSprite {
    var textureAtlas:SKTextureAtlas = SKTextureAtlas(named: "goods.atlas")
    var value = 1 // default for the bronze coin
    
    func spawn(parentNode: SKNode, position: CGPoint, size: CGSize=CGSize(width: 26, height: 26)) {
        parentNode.addChild(self)
        self.size = size
        self.position = position
        self.physicsBody = SKPhysicsBody(circleOfRadius: size.width / 2)
        self.physicsBody?.affectedByGravity = false
        self.texture = textureAtlas.textureNamed("coin-bronze.png")
        
        self.physicsBody?.categoryBitMask = PhysicsCategory.coin.rawValue
        self.physicsBody?.collisionBitMask = 0
    }
    
    func turnToGold() {
        self.texture = textureAtlas.textureNamed("coin-gold.png")
        self.value = 5
    }
    
    func onTap() {
        //
    }
    
    func collect() {
        // prevent further contact
        self.physicsBody?.categoryBitMask = 0
        // Fade out. move up and scaleup the coin
        let collectAnimation = SKAction.group([SKAction.fadeAlphaTo(0, duration: 0.2), SKAction.scaleTo(1.5, duration: 0.2), SKAction.moveBy(CGVector(dx: 0, dy: 25), duration: 0.2)])
        // after fade out move coin out of way and reset it to initial values
        let resetAfterCollected = SKAction.runBlock {
            self.position.y  = 5000
            self.alpha = 1
            self.xScale = 1
            self.yScale = 1
            self.physicsBody?.categoryBitMask = PhysicsCategory.coin.rawValue
        }
        // combine all actions into a sequence
        let collectSequence = SKAction.sequence([collectAnimation, resetAfterCollected])
        // Run animation
        self.runAction(collectSequence)
    }
}