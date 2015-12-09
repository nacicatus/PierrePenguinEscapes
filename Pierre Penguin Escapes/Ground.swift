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
    // set up for looping the ground
    var jumpWidth = CGFloat()
    var jumpCount = CGFloat(1) // note the instantiation of 1
    
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
        
        // solidifying the ground
        //Note: physics body positions are relative to their nodes.
        // The top left of the node is X: 0, Y: 0, given our anchor point.
        // The top right of the node is X: size.width, Y: 0
        let pointTopRight = CGPoint(x: size.width, y: 0)
        self.physicsBody = SKPhysicsBody(edgeFromPoint: CGPointZero, toPoint: pointTopRight)
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
            // Find the width of one-third of the children nodes
            jumpWidth = tileSize.width * floor(tileCount / 3)
        }
    }
    
    
    // Check if we need to jump the ground forward
    func checkForReposition(playerProgress: CGFloat) {
        let groundJumpPosition = jumpWidth * jumpCount
        if playerProgress >= groundJumpPosition {
            // Move the ground forward:
            self.position.x += jumpWidth
            jumpCount++
        }
    }
    
    func onTap() {
        //
    }
    
}