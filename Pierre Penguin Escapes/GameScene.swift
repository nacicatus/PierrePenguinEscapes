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
       // Create a sprite node or two
        let mySprite = SKSpriteNode(color: UIColor.yellowColor(), size: CGSize(width: 50, height: 50))
        let badSprite = SKSpriteNode(color: UIColor.whiteColor(), size: CGSize(width: 20, height: 20))
        
        // Give it a position relative to the parent node (the scene)
        mySprite.position = CGPoint(x: 300, y: 300)
        badSprite.position = CGPoint(x: 100, y: 100)
        
        // Add the sprite node to the parent node
        self.addChild(mySprite)
        self.addChild(badSprite)
        
        // Create some actions
        let action0 = SKAction.moveTo(CGPoint(x: 200, y: 200), duration: 5)
        let action1 = SKAction.scaleTo(4, duration: 4)
        let action2 = SKAction.rotateByAngle(5, duration: 5)
        let actionGroup = SKAction.group([action0, action2])
        let actionSequence = SKAction.sequence([action1, action2])
        
        // Run the actions as singly, as a group, or in a sequence
        badSprite.runAction(action0)
        mySprite.runAction(actionSequence)
        badSprite.runAction(actionGroup)
    }
    
}
