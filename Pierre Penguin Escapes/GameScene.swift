//
//  GameScene.swift
//  Pierre Penguin Escapes
//
//  Created by Saurabh Sikka on 09/12/15.
//  Copyright (c) 2015 Saurabh Sikka. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    // Create the world as a generice SKNode
    let world = SKNode()
    let ground = Ground()
    
    // create bee sprites
    let bee = SKSpriteNode()
    
    override func didMoveToView(view: SKView) {
        
        let bee2 = Bee()
        let bee3 = Bee()
        let bee4 = Bee()
        
        // spawn the bees
        bee2.spawn(world, position: CGPoint(x: 325, y: 325))
        bee3.spawn(world, position: CGPoint(x: 200, y: 325))
        bee4.spawn(world, position: CGPoint(x: 50, y: 200))
        
        // lay the ground down
        // Position X : negative one screen width
        //Position Y: 100 above the bottom
        let groundPosition = CGPoint(x: -self.size.width, y: 100)
        let groundSize = CGSize(width: self.size.width * 3, height: 0) // width 3x screen width, child nodes provide the height
        // Spawn the ground!
        ground.spawn(world, position: groundPosition, size: groundSize)
        
        self.backgroundColor = UIColor(red: 0.4, green: 0.6, blue: 0.94, alpha: 1)
        // add the world as a node
        self.addChild(world)
        // call the bee flying as a function
        self.addTheFlyingBee()
        
    }
    
    func addTheFlyingBee() {
        // Find the bee atlas
        let beeAtlas = SKTextureAtlas(named: "bee.atlas")
        // create an array from the frames in the atlas
        let beeFrames: [SKTexture] = [beeAtlas.textureNamed("bee.png"), beeAtlas.textureNamed("bee_fly.png")]
        
        // Position our bee
        bee.position = CGPoint(x: 250, y: 250)
        bee.size = CGSize(width: 28, height: 24)
        
        world.addChild(bee)
        
        //Create a new animation action
        let flyAction = SKAction.animateWithTextures(beeFrames, timePerFrame: 0.14)
        let beeAction = SKAction.repeatActionForever(flyAction)
        
        // Bee hover
        bee.runAction(beeAction)
        
        // move the bee left and right
        let pathLeft = SKAction.moveByX(-200, y: -10, duration: 2)
        let pathRight = SKAction.moveByX(200, y: 10, duration: 2)
        
        // flip the bee 
        let flipTextureNegative = SKAction.scaleXTo(-1, duration: 0)
        let flipTexturePositive = SKAction.scaleXTo(1, duration: 0)
        
        // bee flight sequence
        let flightOfTheBee = SKAction.sequence([pathLeft, flipTextureNegative, pathRight, flipTexturePositive])
        let neverEndingFlight = SKAction.repeatActionForever(flightOfTheBee)
        
        // tell the bee
        bee.runAction(neverEndingFlight)
    }
    
    override func didSimulatePhysics() {
        // To find the correct position, subtract half of the
        // scene size from the bee's position, adjusted for any
        // world scaling.
        // Multiply by -1 and you have the adjustment to keep our
        // sprite centered:
        
        let worldXPos = -(bee.position.x * world.xScale - self.size.width / 2)
        let worldYPos = -(bee.position.y * world.yScale - self.size.height / 2)
        
        // Center the bee in the world
        world.position = CGPoint(x: worldXPos, y: worldYPos)
        
        
    }
    
}
