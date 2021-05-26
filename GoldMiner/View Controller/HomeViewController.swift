//
//  HomeViewController.swift
//  GoldMiner
//
//  Created by 张翌璠 on 2021-05-23.
//

import UIKit
import GameKit

class HomeViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        view.addSubview(onlineButton)
        onlineButton.addTarget(self, action: #selector(onlineGaming), for: .touchUpInside)
        
        view.addSubview(localButton)
        localButton.addTarget(self, action: #selector(localGaming), for: .touchUpInside)
        
        view.addSubview(instructionButton)
        instructionButton.addTarget(self, action: #selector(instruction), for: .touchUpInside)
    }
    
    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscape
    }
    
    @objc func onlineGaming() {
        if GKLocalPlayer.local.isAuthenticated {
            GameCenterHelper.helper.viewController = self
            GameCenterHelper.helper.presentMatchmaker()
        }
        else {
            GKLocalPlayer.local.authenticateHandler = { [unowned self] viewController, error in
                if let viewController = viewController {
                    self.present(viewController, animated: true, completion: nil)
                    return
                }
                if error != nil {
                    return
                }
                GameCenterHelper.helper.viewController = self
                GameCenterHelper.helper.presentMatchmaker()
            }
        }
    }
    
    @objc func localGaming() {
        present(GameViewController(), animated: true, completion: nil)
    }
    
    @objc func instruction() {
        
    }
    
    lazy var onlineButton: UIButton = {
        let view = UIButton(frame: CGRect(x: 50, y: 100, width: 150, height: 50))
        view.setTitle("online", for: .normal)
        view.setTitleColor(.white, for: .normal)
        view.titleLabel?.font = UIFont(name: "Chalkduster", size: 20)
        view.backgroundColor = .brown
        view.layer.cornerRadius = 10
        return view
    }()
    
    lazy var localButton: UIButton = {
        let view = UIButton(frame: CGRect(x: 50, y: 180, width: 150, height: 50))
        view.setTitle("local", for: .normal)
        view.setTitleColor(.white, for: .normal)
        view.titleLabel?.font = UIFont(name: "Chalkduster", size: 20)
        view.backgroundColor = .brown
        view.layer.cornerRadius = 10
        return view
    }()
    
    lazy var instructionButton: UIButton = {
        let view = UIButton(frame: CGRect(x: 50, y: 260, width: 150, height: 50))
        view.setTitle("instruction", for: .normal)
        view.setTitleColor(.white, for: .normal)
        view.titleLabel?.font = UIFont(name: "Chalkduster", size: 20)
        view.backgroundColor = .brown
        view.layer.cornerRadius = 10
        return view
    }()
}
