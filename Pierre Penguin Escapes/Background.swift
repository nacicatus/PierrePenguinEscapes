//
//  Background.swift
//  Pierre Penguin Escapes
//
//  Created by Saurabh Sikka on 12/12/15.
//  Copyright © 2015 Saurabh Sikka. All rights reserved.
//

import Foundation
import SpriteKit

class Background: SKSpriteNode {
    // movement multiplier - stores how fast the background should move
    var movementMultiplier = CGFloat(0)
    // jumpAdjustment will store how many points of x position
    var jumpAdjustment = CGFloat(0)
    // a constant for the background node size
    let backgroundSize = CGSize(width: 1000, height: 1000)
    
    func spawn(parentNode:SKNode, imageName:String, zPosition:CGFloat, movementMultiplier:CGFloat) {
        // Position from bottom left
        self.anchorPoint = CGPointZero
        // Start backgrounds at the top of the ground ( y: 30)
        self.position = CGPoint(x: 0, y: 0)
        // control the order of backgrounds with zPosition
        self.zPosition = zPosition
        // store the movement multiplier
        self.movementMultiplier = movementMultiplier
        // add the background
        parentNode.addChild(self)
        
        
    // build 3 child node instances looping from -1 to 1 so they cover both forward and behind the player
        for i in -1...1 {
            let newBGNode = SKSpriteNode(imageNamed: imageName)
            newBGNode.size = backgroundSize
            newBGNode.anchorPoint = CGPointZero
            newBGNode.position = CGPoint(x: i * Int(backgroundSize.width), y: 0)
            self.addChild(newBGNode)
        }
    }
    
    // reposition the background
    func updatePosition(playerProgress: CGFloat) {
        // calculate the position adjustment after the loops and parallax multiplier
        let adjustedPosition = jumpAdjustment + playerProgress * (1 - movementMultiplier)
        // check if we need to jump the background forward
        if playerProgress - adjustedPosition > backgroundSize.width {
            jumpAdjustment += backgroundSize.width
        }
        // adjust the background forward as the world moves back so the background appears slower
        self.position.x = adjustedPosition
    }
    
}