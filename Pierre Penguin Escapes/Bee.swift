//
//  Bee.swift
//  Pierre Penguin Escapes
//
//  Created by Saurabh Sikka on 09/12/15.
//  Copyright © 2015 Saurabh Sikka. All rights reserved.
//

import Foundation
import SpriteKit

// Create a new class Bee, inheriting from SKSpriteNode and adopting the GameSprite protocol

class Bee: SKSpriteNode, GameSprite {
    // We will store our texture atlas and bee animations as class-wide properties
    var textureAtlas: SKTextureAtlas = SKTextureAtlas(named: "bee.atlas")
    var flyAnimation = SKAction()
    
    // The spawn function will place the bee in the world
    func spawn(parentNode: SKNode, position: CGPoint, size: CGSize = CGSize(width: 28, height: 24)) {
        parentNode.addChild(self)
        createAnimations()
        self.size = size
        self.position = position
        self.runAction(flyAnimation)
    }
    
    // Our bee only implements one texture based animation but other classes may be more complicated
    // break out this animation into this function
    func createAnimations() {
        let flyFrames:[SKTexture] = [textureAtlas.textureNamed("bee.png"), textureAtlas.textureNamed("bee_fly.png")]
        let flyAction = SKAction.animateWithTextures(flyFrames, timePerFrame: 0.14)
        flyAnimation = SKAction.repeatActionForever(flyAction)
    }
        
    func onTap() { }
        
    }
