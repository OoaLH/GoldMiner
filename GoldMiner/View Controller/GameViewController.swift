//
//  GameViewController.swift
//  GoldMiner
//
//  Created by 张翌璠 on 2021-05-19.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GameSession.shared.newSession()
        
        let skView = SKView(frame: view.frame.inset(by: UIConfig.safeAreaInsets))
        skView.isMultipleTouchEnabled = true
        view = skView
        guard let scene = GameScene(fileNamed: "level1") else { return }
        scene.scaleMode = .aspectFit
        skView.presentScene(scene)
        
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscape
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
