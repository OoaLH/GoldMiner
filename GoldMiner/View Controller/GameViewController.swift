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
        
        let skView = SKView(frame: view.frame.inset(by: safeAreaInsets))
        skView.ignoresSiblingOrder = true
        view = skView
        // print(safeAreaInsets)
        let scene = GameScene(size: skView.bounds.size)
        scene.scaleMode = .aspectFill
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
