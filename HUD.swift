//
//  HUD.swift
//  Pierre Penguin Escapes
//
//  Created by Saurabh Sikka on 12/12/15.
//  Copyright © 2015 Saurabh Sikka. All rights reserved.
//

import Foundation
import SpriteKit

class HUD: SKNode {
    var textureAtlas: SKTextureAtlas = SKTextureAtlas(named: "hud.atlas")
    
    // an array to keep track of the hearts
    var heartNodes:[SKSpriteNode] = []
    
    // An SKLabelNode to print the coin score
    let coinCountText = SKLabelNode(text: "000000")
    
    // Restart and Menu buttons
    let restartButton = SKSpriteNode()
    let menuButton = SKSpriteNode()
    
    
    func createHudNodes(screenSize:CGSize) {
        // --- Create the coin counter ---
        // First, create and position a bronze coin icon:
        let coinTextureAtlas:SKTextureAtlas = SKTextureAtlas(named:"goods.atlas")
        let coinIcon = SKSpriteNode(texture: coinTextureAtlas.textureNamed("coin-bronze.png"))
        // Size and position the coin icon:
        let coinYPos = screenSize.height - 23
        coinIcon.size = CGSize(width: 26, height: 26)
        coinIcon.position = CGPoint(x: 23, y: coinYPos)
        // Configure the coin text label:
        coinCountText.fontName = "AvenirNext-HeavyItalic"
        coinCountText.position = CGPoint(x: 41, y: coinYPos)
        // These two properties allow you to align the text
        // relative to the SKLabelNode's position:
        coinCountText.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
        coinCountText.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        // Add the text label and coin icon to the HUD:
        self.addChild(coinCountText)
        self.addChild(coinIcon)
        // Create three heart nodes for the life meter:
        for var index = 0; index < 3; ++index {
        let newHeartNode = SKSpriteNode(texture:
        textureAtlas.textureNamed("heart-full.png"))
        newHeartNode.size = CGSize(width: 46, height: 40)
        // Position the hearts below the coin counter:
        let xPos = CGFloat(index * 60 + 33)
        let yPos = screenSize.height - 66
        newHeartNode.position = CGPoint(x: xPos, y: yPos)
        // Keep track of nodes in an array property:
        heartNodes.append(newHeartNode)
        // Add the heart nodes to the HUD:
        self.addChild(newHeartNode)
        }
        
        // restart and menu buttons
        restartButton.texture = textureAtlas.textureNamed("button-restart.png")
        menuButton.texture = textureAtlas.textureNamed("button-menu.png")
        // Assign node names to the buttons
        restartButton.name = "restartGame"
        menuButton.name = "returnToMenu"
        // Position the button node
        let centerOfHud = CGPoint(x: screenSize.width / 2, y: screenSize.height / 2)
        restartButton.position = centerOfHud
        menuButton.position = CGPoint(x: centerOfHud.x - 140, y: centerOfHud.y)
        // size the button nodes
        restartButton.size = CGSize(width: 140, height: 140)
        menuButton.size = CGSize(width: 70, height: 70)
    }
    
    func setCoinCountDisplay(newCoinCount: Int) {
        let formatter = NSNumberFormatter()
            formatter.minimumIntegerDigits = 6
            if let coinStr = formatter.stringFromNumber(newCoinCount) {
                coinCountText.text = coinStr
            }
    }
    
    func showButtons() {
            // set the button alpha to 0
            restartButton.alpha = 0
            menuButton.alpha = 0
            // add the buttons
            self.addChild(restartButton)
            self.addChild(menuButton)
            // fade them in
            let fadeAnimation = SKAction.fadeAlphaTo(1, duration: 0.4)
            restartButton.runAction(fadeAnimation)
            menuButton.runAction(fadeAnimation)
    }
    
    func setHealthDisplay(newHealth: Int) {
            // Create a fade action for the lost hearts
            let fadeAction = SKAction.fadeAlphaTo(0.2, duration: 0.3)
            // loop through each heart and update its status
            for var index = 0; index < heartNodes.count; ++index {
                if index < newHealth {
                    heartNodes[index].alpha = 1 // this heart is full read
                    } else {
                        heartNodes[index].runAction(fadeAction) // this heart is faded
                }
            }
    }
    
    
}