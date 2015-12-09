//
//  Ground.swift
//  Pierre Penguin Escapes
//
//  Created by Saurabh Sikka on 09/12/15.
//  Copyright © 2015 Saurabh Sikka. All rights reserved.
//

import Foundation
import SpriteKit

class Ground: SKSpriteNode, GameSprite {
    var textureAtlas: SKTextureAtlas = SKTextureAtlas(named: "ground.atlas")
    // Create an Optional property named groundTexture to store the current ground texture
    var groundTexture: SKTexture?
    
    func spawn(parentNode: SKNode, position: CGPoint, size: CGSize) {
        parentNode.addChild(self)
        self.size = size
        self.position = position
        // create a non-default anchor point just above the bottom of the screen
        self.anchorPoint = CGPointMake(0, 1)
        
        // Default to the ice texture
        if groundTexture == nil {
            groundTexture = textureAtlas.textureNamed("ice-tile.png")
        }
        
        // repeat the tiles
        createChildren()
    }
    
    // Build child nodes to repeat the ground texture
    func createChildren() {
        // First make sure we have a groundTexure value:
        if let texture = groundTexture {
            var tileCount:CGFloat = 0
            let textureSize = texture.size()
            // set the tile size at half their texture for sharp retina goodness!
            let tileSize = CGSize(width: textureSize.width / 2, height: textureSize.height / 2)
            // Build nodes to cover the entire ground
            while tileCount * tileSize.width < self.size.width {
                let tileNode = SKSpriteNode(texture: texture)
                tileNode.size = tileSize
                tileNode.position.x = tileCount * tileSize.width
                // Position child nodes by their upper left corner
                tileNode.anchorPoint = CGPoint(x: 0, y: 1)
                // Add them to the ground
                self.addChild(tileNode)
                
                tileCount++
            }
        }
    }
    
    func onTap() {
        //
    }
    
}