//
//  Blade.swift
//  Pierre Penguin Escapes
//
//  Created by Saurabh Sikka on 10/12/15.
//  Copyright © 2015 Saurabh Sikka. All rights reserved.
//

import Foundation
import SpriteKit

class Blade: SKSpriteNode, GameSprite {
    var textureAtlas: SKTextureAtlas = SKTextureAtlas(named: "enemies.atlas")
    var spinAnimation = SKAction()
    
    func spawn(parentNode: SKNode, position: CGPoint, size: CGSize=CGSize(width: 185, height: 92)) {
        parentNode.addChild(self)
        createAnimations()
        self.size = size
        self.position = position
        // Create a physics body shaped by the blade texture
        self.physicsBody = SKPhysicsBody(texture: textureAtlas.textureNamed("blade-1.png"), size: size)
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.dynamic = false
        self.runAction(spinAnimation)
        
        self.physicsBody?.categoryBitMask = PhysicsCategory.enemy.rawValue
        self.physicsBody?.collisionBitMask = ~PhysicsCategory.damagedPenguin.rawValue
    }
    
    func createAnimations() {
        let spinFrames: [SKTexture] = [textureAtlas.textureNamed("blade-1.png"), textureAtlas.textureNamed("blade-2.png")]
        let spinAction = SKAction.animateWithTextures(spinFrames, timePerFrame: 0.07)
        spinAnimation = SKAction.repeatActionForever(spinAction)
    }
    
    func onTap() {
        //
    }
}