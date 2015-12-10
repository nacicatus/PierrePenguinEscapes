//
//  EncounterManager.swift
//  Pierre Penguin Escapes
//
//  Created by Saurabh Sikka on 10/12/15.
//  Copyright © 2015 Saurabh Sikka. All rights reserved.
//

import Foundation
import SpriteKit

class EncounterManager {
    
    // Store the encounter file names
    let encounterNames:[String] = ["EncounterBats", "EncounterBees", "EncounterGhosts"]
    // Each encounter is an SKNode Array
    var encounters:[SKNode] = []
    
    var currentEncounterIndex: Int?
    var previousEncounterIndex: Int?
    
    init() {
        // loop through each encounter scene
        for encounterFileName in encounterNames {
            let encounter = SKNode() // Create a new node for the encounter
      
            // Load this scene file into an SKScene instance
            if let encounterScene = SKScene(fileNamed: encounterFileName) {
                // Loop thru each placeholder, spawning the game object
                for placeholder in encounterScene.children {
                    if let node = placeholder as? SKNode {
                        switch node.name! {
                        case "Bat":
                            let bat = Bat()
                            bat.spawn(encounter, position: node.position)
                        case "Bee":
                            let bee = Bee()
                            bee.spawn(encounter, position: node.position)
                        case "Blade":
                            let blade = Blade()
                            blade.spawn(encounter, position: node.position)
                        case "Ghost":
                            let ghost = Ghost()
                            ghost.spawn(encounter, position: node.position)
                        case "MadFly":
                            let madFly = MadFly()
                            madFly.spawn(encounter, position: node.position)
                        case "GoldCoin":
                            let coin = Coin()
                            coin.spawn(encounter, position: node.position)
                            coin.turnToGold()
                        case "BronzeCoin":
                            let coin = Coin()
                            coin.spawn(encounter, position: node.position)
                        default:
                            print("Name error: \(node.name)")
                            
                        }
                    }
                }
            }
            // Add the populated encounter node to the array
            encounters.append(encounter)
            // Save initial sprite positions for this encounter
            saveSpritePositions(encounter)
        }
    }
    
    // Call this addEncountersToWorld function from the GameScene to append all of the encounter nodes to the world node from our GameScene
    
    func addEncountersToWorld(world: SKNode) {
        for index in 0 ... encounters.count - 1 {
            // Spawn the encounters behind the action, in increasing height so they do not collide
            encounters[index].position = CGPoint(x: -2000, y: index * 1000)
            world.addChild(encounters[index])
        }
    }
    
    
     // Store initial positions of the children of a node
    func saveSpritePositions(node: SKNode) {
        for sprite in node.children {
            if let spriteNode = sprite as? SKSpriteNode {
                let initialPositionValue = NSValue(CGPoint: sprite.position)
                spriteNode.userData = ["initialPosition":initialPositionValue]
                // Save the positions for children of this node
                saveSpritePositions(spriteNode)
            }
        }
    }
    
    
    // Reset all children nodes to their original position:
    func resetSpritePositions(node: SKNode) {
        for sprite in node.children {
            if let spriteNode = sprite as? SKSpriteNode {
                // remove any linear or angular velocity
                spriteNode.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                spriteNode.physicsBody?.angularVelocity = 0
                // Reset the rotation of the sprite
                spriteNode.zRotation = 0
                if let initialPositionVal = spriteNode.userData?.valueForKey("initialPosition") as? NSValue {
                    // Reset the position of the sprite
                    spriteNode.position = initialPositionVal.CGPointValue()
                }
                // Reset positions on this node's children
                resetSpritePositions(spriteNode)
            }
        }
    }
    
    func placeNextEncounter(currentXPos: CGFloat) {
        // Count the encounters in a arandom ready type
        let encounterCount = UInt32(encounters.count)
        // game requires at least 3 encounters
        if encounterCount < 3 {
            return
        }
        // We need to pick an encounter that is not currently displayed
        var nextEncounterIndex: Int?
        var trulyNew: Bool?
        
        while (trulyNew == false || trulyNew == nil) {
            // Pick a random encounter
            nextEncounterIndex = Int(arc4random_uniform(encounterCount))
            // assert this is a new encounter
            trulyNew = true
            // test if it is instead the current encounter
            if let currentIndex = currentEncounterIndex {
                if nextEncounterIndex == currentIndex {
                    trulyNew = false
                }
            }
            // test if it is the directly previous encounter
            if let previousIndex = previousEncounterIndex {
                if nextEncounterIndex == previousIndex {
                    trulyNew = false
                }
            }
            
        }
        
        // Keep track of the current Encounter
        previousEncounterIndex = currentEncounterIndex
        currentEncounterIndex = nextEncounterIndex
        
        // Reset the new encounter and position it ahead of the player
        let encounter = encounters[currentEncounterIndex!]
        encounter.position = CGPoint(x: currentXPos + 1000, y: 0)
        resetSpritePositions(encounter)
    }
    
    
}