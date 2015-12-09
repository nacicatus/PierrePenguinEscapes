//
//  GameScene.swift
//  Pierre Penguin Escapes
//
//  Created by Saurabh Sikka on 09/12/15.
//  Copyright (c) 2015 Saurabh Sikka. All rights reserved.
//

import SpriteKit
import CoreMotion

class GameScene: SKScene {
    // Create the world as a generice SKNode
    let world = SKNode()
    let ground = Ground()
    
    let motionManager = CMMotionManager()
  
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
        let groundPosition = CGPoint(x: -self.size.width, y: 30)
        let groundSize = CGSize(width: self.size.width * 3, height: 0) // width 3x screen width, child nodes provide the height
        // Spawn the ground!
        ground.spawn(world, position: groundPosition, size: groundSize)
        
        // spawn the player
        player.spawn(world, position: CGPoint(x: 150, y: 250))
        
        self.motionManager.startAccelerometerUpdates()
        
    }
    
    
    override func didSimulatePhysics() {
        
        let worldXPos = -(player.position.x * world.xScale - self.size.width / 2)
        let worldYPos = -(player.position.y * world.yScale - self.size.height / 2)
        
        // Center the bee in the world
        world.position = CGPoint(x: worldXPos, y: worldYPos)
        
        
    }
    
    override func update(currentTime: NSTimeInterval) {
        player.update()
        // Unwrap the accelerometer data optional:
        if let accelData = self.motionManager.accelerometerData {
            var forceAmount: CGFloat
            var movement = CGVector()
            // Based on the device orientation, the tilt number
            // can indicate opposite user desires. The
            // UIApplication class exposes an enum that allows
            // us to pull the current orientation.
            // We will use this opportunity to explore Swift's
            // switch syntax and assign the correct force for the
            // current orientation:
            switch UIApplication.sharedApplication().statusBarOrientation {
            case .LandscapeLeft:
                forceAmount = 20000
            default:
                forceAmount = 0
            }
            
            // If the device is tilted more than 15% towards complete
            // vertical, then we want to move the Penguin:
            if accelData.acceleration.y > 0.15 {
                movement.dx = forceAmount
            }
                // Core Motion values are relative to portrait view.
                // Since we are in landscape, use y-values for x-axis.
                else if accelData.acceleration.y < -0.15 {
                movement.dx = -forceAmount
            }
            // Apply the force we created to the player:
            player.physicsBody?.applyForce(movement)
            
            
        }
    }
    
}
