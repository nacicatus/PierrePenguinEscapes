//
//  GameViewController.swift
//  Pierre Penguin Escapes
//
//  Created by Saurabh Sikka on 09/12/15.
//  Copyright (c) 2015 Saurabh Sikka. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        
        // Build the menu scene
        let menuScene = MenuScene()
        let skView = self.view as! SKView
        // Ignore drawing order of child nodes to increase performance
        skView.ignoresSiblingOrder = true
        // size our scene to fit exactly
        menuScene.size = view.bounds.size
        // Show the menu
        skView.presentScene(menuScene)
    }
    
    override func shouldAutorotate() -> Bool {
        return true
    }

    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
            return .Landscape
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}