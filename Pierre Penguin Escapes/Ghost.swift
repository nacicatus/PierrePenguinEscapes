//
//  Ghost.swift
//  Pierre Penguin Escapes
//
//  Created by Saurabh Sikka on 10/12/15.
//  Copyright © 2015 Saurabh Sikka. All rights reserved.
//

import Foundation
import SpriteKit

class Ghost: SKSpriteNode, GameSprite {
    var textureAtlas: SKTextureAtlas = SKTextureAtlas(named: "enemies.atlas")
    var fadeAnimation = SKAction()
    
    func spawn(parentNode: SKNode, position: CGPoint, size: CGSize=CGSize(width: 30, height: 44)) {
        parentNode.addChild(self)
        createAnimations()
        self.size = size
        self.position = position
        self.physicsBody = SKPhysicsBody(circleOfRadius: size.width / 2)
        self.physicsBody?.affectedByGravity = false
        self.texture = textureAtlas.textureNamed("ghost-frown.png")
        self.runAction(fadeAnimation)
        self.alpha = 0.8
        
        self.physicsBody?.categoryBitMask = PhysicsCategory.enemy.rawValue
        self.physicsBody?.collisionBitMask = ~PhysicsCategory.damagedPenguin.rawValue
    }
    
    func createAnimations() {
        // Create a fadeout action group
        let fadeOutGroup = SKAction.group([SKAction.fadeAlphaTo(0.3, duration: 2), SKAction.scaleTo(0.8, duration: 2)])
        let fadeInGroup = SKAction.group([SKAction.fadeAlphaTo(0.8, duration: 2), SKAction.scaleTo(1, duration: 2)])
        // creae a sequence
        let fadeSequence = SKAction.sequence([fadeOutGroup, fadeInGroup])
        fadeAnimation = SKAction.repeatActionForever(fadeSequence)
    }
    
    func onTap() {
        //
    }
}