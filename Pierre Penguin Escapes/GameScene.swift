//
//  GameScene.swift
//  Pierre Penguin Escapes
//
//  Created by Saurabh Sikka on 09/12/15.
//  Copyright (c) 2015 Saurabh Sikka. All rights reserved.
//

import SpriteKit


class GameScene: SKScene, SKPhysicsContactDelegate {
    // Create the world as a generice SKNode
    let world = SKNode()
    let ground = Ground()
    // store the center point of screen
    var screenCenterY = CGFloat()
  
    // Create player
    let player = Player()
    let initialPlayerPosition = CGPoint(x: 150, y: 250)
    var playerProgress = CGFloat()
    
    // New instance of EncounterManager class
    let encounterManager = EncounterManager()
    
    // track encounters
    var nextEncounterSpawnPosition = CGFloat(150)
    
    // power up stars
    let powerUpStar = Star()
    
    //scores
    var coinsCollected = 0
    
    override func didMoveToView(view: SKView) {
        // Screen center
        screenCenterY = self.size.height / 2
        
        // Blue sky
        self.backgroundColor = UIColor(red: 0.4, green: 0.6, blue: 0.94, alpha: 1)
        
        // add the world as a node
        self.addChild(world)
        
        // spawn the ground
        let groundPosition = CGPoint(x: -self.size.width, y: 30)
        let groundSize = CGSize(width: self.size.width * 3, height: 0) // width 3x screen width, child nodes provide the height
        ground.spawn(world, position: groundPosition, size: groundSize)
        
        // spawn the player
        player.spawn(world, position: initialPlayerPosition)
        
        // Set the gravity
        self.physicsWorld.gravity = CGVector(dx: 0, dy: -5)
        
        // Encounters
        encounterManager.addEncountersToWorld(self.world)
        encounterManager.encounters[0].position = CGPoint(x: 300, y: 0)
        
        // spawn star out of way
        powerUpStar.spawn(world, position: CGPoint(x: -2000, y: -2000))
        
        // tell SpriteKit to inform GameScene of contact events
        self.physicsWorld.contactDelegate = self
        
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
        
        // Check if player moves past the position and we need to set a new encounter
        if player.position.x > nextEncounterSpawnPosition {
            encounterManager.placeNextEncounter(nextEncounterSpawnPosition)
            nextEncounterSpawnPosition += 1400
            
            // Each encounter has a 10% chance to spawn a star
            let starRoll = Int(arc4random_uniform(20))
            if starRoll == 0 {
                if abs(player.position.x - powerUpStar.position.x) > 1200 {
                    // only move the star if it is off screen
                    let randomYPos = CGFloat(arc4random_uniform(400))
                    powerUpStar.position = CGPoint(x: nextEncounterSpawnPosition, y: randomYPos)
                    powerUpStar.physicsBody?.angularVelocity = 0
                    powerUpStar.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                }
            }
        }
        
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        // Each contact has 2 bodies, we will find the penguin body and use the other to determine the type of contact
        let otherBody: SKPhysicsBody
        // Combine the two penguin physics categories into one bitmask using the bitwise OR operator
        let penguinMask = PhysicsCategory.penguin.rawValue | PhysicsCategory.damagedPenguin.rawValue
        // Use the bitwise AND operator to find the penguin
        // This returns a positive number if body A's category
        // is the same as either the penguin or damagedPenguin:
        if (contact.bodyA.categoryBitMask * penguinMask) > 0 {
            // bodyA is the penguin, we will test bodyB
            otherBody = contact.bodyB
        } else {
            // bodyA is the penguin, we will test bodyB
            otherBody = contact.bodyA
        }
        // Find the type of contact
        switch otherBody.categoryBitMask {
        case PhysicsCategory.ground.rawValue:
            print("hit the ground")
            player.takeDamage()
        case PhysicsCategory.enemy.rawValue:
            print("take damage")
            player.takeDamage()
        case PhysicsCategory.coin.rawValue:
            // try to cast the otherBody's node as a coin
            if let coin = otherBody.node as? Coin {
                coin.collect()
                self.coinsCollected += coin.value
                print(self.coinsCollected)
            }
        case PhysicsCategory.powerup.rawValue:
            player.starPower()
        default:
            print("contact with no game logic")
        }
        
        
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

enum PhysicsCategory:UInt32 {
    case penguin = 1
    case damagedPenguin = 2
    case ground = 4
    case enemy = 8
    case coin = 16
    case powerup = 32
}



