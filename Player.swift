//
//  Player.swift
//  Pierre Penguin Escapes
//
//  Created by Saurabh Sikka on 09/12/15.
//  Copyright © 2015 Saurabh Sikka. All rights reserved.
//

import Foundation
import SpriteKit

class Player: SKSpriteNode, GameSprite {
    
// ------- Here is a set of constants we will use later ------
    
    var textureAtlas: SKTextureAtlas = SKTextureAtlas(named: "pierre.atlas")
    // Pierre's animations
    var flyAnimation = SKAction()
    var soarAnimation = SKAction()
    
    // Store whether we are flapping our wings or in freefall:
    var flapping = false
    // Set a maximum upward force:
    let maxFlappingForce: CGFloat = 57000
    // Pierre should slow down when he flies too high
    let maxHeight: CGFloat = 1000
    
    // The player will take 3 hits before game over:
    var health:Int = 3
    // keep track of when player invulnerable
    var invulnerable = false
    // keep track when player newly damaged
    var damaged = false
    
    // We will create animations to run when player takes damage
    var damageAnimation = SKAction()
    var dieAnimation = SKAction()
    // stop forward velocity if player dies
    var forwardVelocity:CGFloat = 200
    
// -------- Here are the methods -----------
    
    func spawn(parentNode: SKNode, position: CGPoint, size: CGSize = CGSize(width: 64, height: 64)) {
        parentNode.addChild(self)
        createAnimations()
        self.size = size
        self.position = position
        self.runAction(soarAnimation, withKey: "soarAnimation")
        
        // Create a physics body based on one frame of Pierre's animation when his wings are tucked in
        let bodyTexture = textureAtlas.textureNamed("pierre-flying-3.png")
        self.physicsBody = SKPhysicsBody(texture: bodyTexture, size: size)
        // Pierre will lose momentum quickly with a high linear damping:
        self.physicsBody?.linearDamping = 0.9
        // Adult penguins weigh 30 kg
        self.physicsBody?.mass = 30
        // Prevent pierre from rotating
        self.physicsBody?.allowsRotation = false
        
        // Set up the physics category bit masks
        self.physicsBody?.categoryBitMask = PhysicsCategory.penguin.rawValue
        self.physicsBody?.contactTestBitMask = PhysicsCategory.enemy.rawValue | PhysicsCategory.ground.rawValue | PhysicsCategory.powerup.rawValue | PhysicsCategory.coin.rawValue
    }
    
    func createAnimations() {
        
        // rotate
        let rotateUpAction = SKAction.rotateToAngle(0, duration: 0.475)
        rotateUpAction.timingMode = .EaseOut
        let rotateDownAction = SKAction.rotateToAngle(-1, duration: 0.8)
        rotateDownAction.timingMode = .EaseIn
        
        // flying
        let flyFrames:[SKTexture] = [textureAtlas.textureNamed("pierre-flying-1.png"), textureAtlas.textureNamed("pierre-flying-2.png"), textureAtlas.textureNamed("pierre-flying-3"), textureAtlas.textureNamed("pierre-flying-4"), textureAtlas.textureNamed("pierre-flying-3"), textureAtlas.textureNamed("pierre-flying-2.png")]
        let flyAction = SKAction.animateWithTextures(flyFrames, timePerFrame: 0.03)
        flyAnimation = SKAction.group([SKAction.repeatActionForever(flyAction), rotateUpAction])
        
        // soaring
        let soarFrames:[SKTexture] = [textureAtlas.textureNamed("pierre-flying-1")]
        let soarAction = SKAction.animateWithTextures(soarFrames, timePerFrame: 1)
        soarAnimation = SKAction.group([SKAction.repeatActionForever(soarAction), rotateDownAction])
        
        // ------- Create the take damage animation--------
        let damageStart = SKAction.runBlock {
            // Allow the penguin to pass through enemies:
            self.physicsBody?.categoryBitMask = PhysicsCategory.damagedPenguin.rawValue
            // Use the bitwise NOT operator ~ to remove enemies from the collision test:
            self.physicsBody?.collisionBitMask = ~PhysicsCategory.enemy.rawValue
        }
        // Create an opacity pulse, slow at first then fast at end
        let slowFade = SKAction.sequence([SKAction.fadeAlphaTo(0.3, duration: 0.35), SKAction.fadeAlphaTo(0.7, duration: 0.35)])
        let fastFade = SKAction.sequence([SKAction.fadeAlphaTo(0.3, duration: 0.2), SKAction.fadeAlphaTo(0.7, duration: 0.2)])
        let fadeOutAndIn = SKAction.sequence([SKAction.repeatAction(slowFade, count: 2), SKAction.repeatAction(fastFade, count: 5)])
        // Return the penguin to normal
        let damageEnd = SKAction.runBlock {
            self.physicsBody?.categoryBitMask = PhysicsCategory.penguin.rawValue
            // Collide with everything again
            self.physicsBody?.collisionBitMask = 0xFFFFFFFF
            // Turn off the newly damaged flag
            self.damaged = false
        }
        // Store the whole sequence in the damageAnimation property:
        self.damageAnimation = SKAction.sequence([damageStart, fadeOutAndIn, damageEnd])
        
        /* --- Create the death animation --- */
        let startDie = SKAction.runBlock {
            // Switch to the death texture with X eyes:
            self.texture = self.textureAtlas.textureNamed("pierre-dead.png")
            // Suspend the penguin in space:
            self.physicsBody?.affectedByGravity = false
            // Stop any movement:
            self.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            // Make the penguin pass through everything except the ground:
            self.physicsBody?.collisionBitMask = PhysicsCategory.ground.rawValue
        }
        
        let endDie = SKAction.runBlock {
            // Turn gravity back on:
            self.physicsBody?.affectedByGravity = true
        }
        
        self.dieAnimation = SKAction.sequence([startDie, SKAction.scaleTo(1.3, duration: 0.5), SKAction.waitForDuration(0.5), SKAction.rotateToAngle(3, duration: 1.5), endDie])
    }
    
    
    func onTap() {
        //
    }
    
    func update() {
        
        // Set a constant velocity to the right
        self.physicsBody?.velocity.dx = 200
        
        // If flapping, apply a new force to push Pierre higher
        if self.flapping {
            var forceToApply = maxFlappingForce
            // Apply less force if too high
            if position.y > 600 {
                let percentageOfMaximumHeight = position.y / maxHeight
                let flappingForceSubtraction = percentageOfMaximumHeight * maxFlappingForce
                forceToApply -= flappingForceSubtraction
            }
            // Apply the final force:
            self.physicsBody?.applyForce(CGVector(dx: 0, dy: forceToApply))
        }
        
        // Limit Pierre's top speed as he climbs the y axis
        if self.physicsBody?.velocity.dy > 300 {
            self.physicsBody?.velocity.dy = 300
        }
        
        // Set a constant velocity to the right
        self.physicsBody?.velocity.dx = self.forwardVelocity
        
    }
    
    // Begin the flap animation
    func startFlapping() {
        
        // if player is dead, stop him flying
        if self.health <= 0 { return }
        
        // start flapping if alive
        self.removeActionForKey("soarAnimation")
        self.runAction(flyAnimation, withKey: "flapAnimation")
        self.flapping = true
    }
    
    
    // Stop flapping
    func stopFlapping() {
        // if player is dead, stop him flying
        if self.health <= 0 { return }
        
        self.removeActionForKey("flapAnimation")
        self.runAction(soarAnimation, withKey: "soarAnimation")
        self.flapping = false
    }
    
    func die() {
        self.alpha = 1
        self.removeAllActions()
        self.runAction(self.dieAnimation)
        self.flapping = false
        self.forwardVelocity = 0
    }
    
    func takeDamage() {
        if self.invulnerable || self.damaged { return }
        // Set the damaged state to true after being hit, and decrease the health
        self.damaged = true
        self.health--
        
        if self.health == 0 {
            die()
        } else {
            self.runAction(self.damageAnimation)
        }
    }
}
