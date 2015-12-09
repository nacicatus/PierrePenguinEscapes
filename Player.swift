//
//  Player.swift
//  Pierre Penguin Escapes
//
//  Created by Saurabh Sikka on 09/12/15.
//  Copyright © 2015 Saurabh Sikka. All rights reserved.
//

import Foundation
import SpriteKit

class Player: SKSpriteNode, GameSprite {
    var textureAtlas: SKTextureAtlas = SKTextureAtlas(named: "pierre.atlas")
    // Pierre's animations
    var flyAnimation = SKAction()
    var soarAnimation = SKAction()
    
    func spawn(parentNode: SKNode, position: CGPoint, size: CGSize = CGSize(width: 64, height: 64)) {
        parentNode.addChild(self)
        createAnimations()
        self.size = size
        self.position = position
        self.runAction(flyAnimation, withKey: "flapAnimation")
    }
    
    func createAnimations() {
        
        // rotate
        let rotateUpAction = SKAction.rotateToAngle(0, duration: 0.475)
        rotateUpAction.timingMode = .EaseOut
        let rotateDownAction = SKAction.rotateToAngle(-1, duration: 0.8)
        rotateDownAction.timingMode = .EaseIn
        
        // flying
        let flyFrames:[SKTexture] = [textureAtlas.textureNamed("pierre-flying-1.png"), textureAtlas.textureNamed("pierre-flying-2.png"), textureAtlas.textureNamed("pierre-flying-3"), textureAtlas.textureNamed("pierre-flying-4"), textureAtlas.textureNamed("pierre-flying-3"), textureAtlas.textureNamed("pierre-flying-2.png")]
        let flyAction = SKAction.animateWithTextures(flyFrames, timePerFrame: 0.03)
        flyAnimation = SKAction.group([SKAction.repeatActionForever(flyAction), rotateUpAction])
        
        // soaring
        let soarFrames:[SKTexture] = [textureAtlas.textureNamed("pierre-flying-1")]
        let soarAction = SKAction.animateWithTextures(soarFrames, timePerFrame: 1)
        soarAnimation = SKAction.group([SKAction.repeatActionForever(soarAction), rotateDownAction])
        
    }
    
    func onTap() {
        //
    }
}
