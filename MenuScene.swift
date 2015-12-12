//
//  MenuScene.swift
//  Pierre Penguin Escapes
//
//  Created by Saurabh Sikka on 12/12/15.
//  Copyright © 2015 Saurabh Sikka. All rights reserved.
//

import Foundation
import SpriteKit

class MenuScene: SKScene {
    // grab the HUD atlas
    let textureAtlas:SKTextureAtlas = SKTextureAtlas(named: "hud.atlas")
    // instantiate a sprite node for the start button
    let startButton = SKSpriteNode()
    
    override func didMoveToView(view: SKView) {
        // Position nodes from teh center of the scene
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        // blue sky
        self.backgroundColor = UIColor(red: 0.4, green: 0.6, blue: 0.95, alpha: 1)
        // add the menu background image
        let backgroundImage = SKSpriteNode(imageNamed: "Background-menu")
        backgroundImage.size = CGSize(width: 1024, height: 768)
        self.addChild(backgroundImage)
        
        // Draw the name of the game
        let logoText = SKLabelNode(fontNamed: "AvenirNext-Heavy")
        logoText.text = "Pierre Penguin"
        logoText.position = CGPoint(x: 0, y: 100)
        logoText.fontSize = 60
        self.addChild(logoText)
        // another line
        let logoTextBottom = SKLabelNode(fontNamed: "AvenirNext-Heavy")
        logoTextBottom.text = "Escapes the Antarctic"
        logoTextBottom.position = CGPoint(x: 0, y: 50)
        logoTextBottom.fontSize = 40
        self.addChild(logoTextBottom)
        
        // Add a Start Button
        startButton.texture = textureAtlas.textureNamed("button.png")
        startButton.size = CGSize(width: 295, height: 76)
        // name the start node for touch detection
        startButton.name = "StartBtn"
        startButton.position = CGPoint(x: 0, y: -20)
        self.addChild(startButton)
        // add text to the start button
        let startText = SKLabelNode(fontNamed: "AvenirNext-HeavyItalic")
        startText.text = "START GAME"
        startText.verticalAlignmentMode = .Center
        startText.position = CGPoint(x: 0, y: 2)
        startText.fontSize = 40
        // name the text node for touch detection
        startText.name = "StartBtn"
        startButton.addChild(startText)
        
        // pulse
        let pulseAction = SKAction.sequence([SKAction.fadeAlphaTo(0.7, duration: 0.9), SKAction.fadeAlphaTo(1, duration: 0.9)])
        startButton.runAction(SKAction.repeatActionForever(pulseAction))
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            let location = touch.locationInNode(self)
            let nodeTouched = nodeAtPoint(location)
            
            if nodeTouched.name == "StartBtn" {
                self.view?.presentScene(GameScene(size: self.size))
            }
        }
    }
}