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
  
    // Create player
    let player = Player()
    
    override func didMoveToView(view: SKView) {
        
        // Blue sky
        self.backgroundColor = UIColor(red: 0.4, green: 0.6, blue: 0.94, alpha: 1)
        // add the world as a node
        self.addChild(world)
        
        // Spawn the bees
        let bee2 = Bee()
        let bee3 = Bee()
        let bee4 = Bee()
        
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
        
        // spawn the player
        player.spawn(world, position: CGPoint(x: 150, y: 250))
        
        
        // bee crash test
        bee2.physicsBody?.applyImpulse(CGVector(dx: -3, dy: 0))
    }
    
    
    override func didSimulatePhysics() {
        
        let worldXPos = -(player.position.x * world.xScale - self.size.width / 2)
        let worldYPos = -(player.position.y * world.yScale - self.size.height / 2)
        
        // Center the bee in the world
        world.position = CGPoint(x: worldXPos, y: worldYPos)
        
        
    }
    
}
