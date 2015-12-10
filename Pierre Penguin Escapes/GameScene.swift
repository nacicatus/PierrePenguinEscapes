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
    // store the center point of screen
    var screenCenterY = CGFloat()
  
    // Create player
    let player = Player()
    let initialPlayerPosition = CGPoint(x: 150, y: 250)
    var playerProgress = CGFloat()
    
    
    override func didMoveToView(view: SKView) {
        // Screen center
        screenCenterY = self.size.height / 2
        
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
        
        // Spawn a bat:
        let bat = Bat()
        bat.spawn(world, position: CGPoint(x: 400, y: 200))
        // A blade:
        let blade = Blade()
        blade.spawn(world, position: CGPoint(x: 300, y: 76))
        // A mad fly:
        let madFly = MadFly()
        madFly.spawn(world, position: CGPoint(x: 50, y: 50))
        // A bronze coin:
        let bronzeCoin = Coin()
        bronzeCoin.spawn(world, position: CGPoint(x: 490, y: 250))
        // A gold coin:
        let goldCoin = Coin()
        goldCoin.spawn(world, position: CGPoint(x: 460, y: 250))
        goldCoin.turnToGold()
        // A ghost!
        let ghost = Ghost()
        ghost.spawn(world, position: CGPoint(x: 50, y: 300))
        // The powerup star:
        let star = Star()
        star.spawn(world, position: CGPoint(x: 250, y: 250))
        
        
        // lay the ground down
        // Position X : negative one screen width
        //Position Y: 100 above the bottom
        let groundPosition = CGPoint(x: -self.size.width, y: 30)
        let groundSize = CGSize(width: self.size.width * 3, height: 0) // width 3x screen width, child nodes provide the height
        
        // Spawn the ground!
        ground.spawn(world, position: groundPosition, size: groundSize)
        
        // spawn the player
        player.spawn(world, position: initialPlayerPosition)
        
        // Set the gravity
        self.physicsWorld.gravity = CGVector(dx: 0, dy: -5)
        
    }
    
    override func didSimulatePhysics() {
        var worldYPos: CGFloat = 0
        
        // zoom the world as penguin flies higher
        if player.position.y > screenCenterY {
            let percentOfMaxHeight = (player.position.y - screenCenterY) / (player.maxHeight - screenCenterY)
            let scaleSubtraction = (percentOfMaxHeight > 1 ? 1 : percentOfMaxHeight) * 0.6
            let newScale = 1 - scaleSubtraction
            
            // The player is above half the screen size
            // so adjust the world on the y-axis to follow:
            world.yScale = newScale
            world.xScale = newScale
            
            worldYPos = -(player.position.y * world.yScale - (self.size.height / 2))
        }
        let worldXPos = -(player.position.x * world.xScale - (self.size.width / 3))
        
        // Move the world
        world.position = CGPoint(x: worldXPos, y: worldYPos)
        
        // track the player's progress
        playerProgress = player.position.x - initialPlayerPosition.x // We'll also use this to calculate high scores
        
        // should the ground jump forward?
        ground.checkForReposition(playerProgress)
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            // find location of the touch
            let location = touch.locationInNode(self)
            // locate the node at this location
            let nodeTouched = nodeAtPoint(location)
            // Attempt to downcast the node to the GameSprite protocol
            if let gameSprite = nodeTouched as? GameSprite {
                gameSprite.onTap()
            }
        }
        player.startFlapping()
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        player.stopFlapping()
    }
    
    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        player.stopFlapping()
    }
    
    override func update(currentTime: NSTimeInterval) {
        player.update()

    }
    
}
