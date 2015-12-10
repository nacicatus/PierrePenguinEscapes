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
    let encounterNames:[String] = ["EncounterBats"]
    // Each encounter is an SKNode Array
    var encounters:[SKNode] = []
    
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
    
    
    
}