//
//  GameScene.swift
//  Pierre Penguin Escapes
//
//  Created by Saurabh Sikka on 09/12/15.
//  Copyright (c) 2015 Saurabh Sikka. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    override func didMoveToView(view: SKView) {
       // Create a blue sky
        self.backgroundColor = UIColor(red: 0.4, green: 0.6, blue: 0.95, alpha: 1)
        
        // create a bee sprite
        let bee = SKSpriteNode()
        bee.position = CGPoint(x: 250, y: 250)
        bee.size = CGSize(width: 28, height: 24)
        self.addChild(bee)
        
        // Find the bee atlas
        let beeAtlas = SKTextureAtlas(named: "bee.atlas")
        // create an array from the frames in the atlas
        let beeFrames: [SKTexture] = [beeAtlas.textureNamed("bee.png"), beeAtlas.textureNamed("bee_fly.png")]
        //Create a new animation action
        let flyAction = SKAction.animateWithTextures(beeFrames, timePerFrame: 0.05)
        let beeAction = SKAction.repeatActionForever(flyAction)
        
        bee.runAction(beeAction)
    }
    
}
