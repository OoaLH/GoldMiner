//
//  OnlineGameViewController.swift
//  GoldMiner
//
//  Created by 张翌璠 on 2021-05-23.
//

import UIKit
import SpriteKit
import GameplayKit
import GameKit

class OnlineGameViewController: UIViewController {
    var match: GKMatch
    
    init(match: GKMatch) {
        self.match = match
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GameSession.shared.newSession()
        
        let skView = SKView(frame: view.frame.inset(by: UIConfig.safeAreaInsets))
        skView.ignoresSiblingOrder = true
        view = skView
        let scene = OnlineGameScene(size: skView.bounds.size, match: match)
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
