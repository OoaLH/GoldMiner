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
    
    lazy var onlineButton: UIButton = {
        let view = UIButton(frame: CGRect(x: 30, y: 100, width: 100, height: 30))
        view.setTitle("online", for: .normal)
        view.setTitleColor(.black, for: .normal)
        view.backgroundColor = .brown
        return view
    }()
    
    lazy var localButton: UIButton = {
        let view = UIButton(frame: CGRect(x: 30, y: 200, width: 100, height: 30))
        view.setTitle("local", for: .normal)
        view.setTitleColor(.black, for: .normal)
        view.backgroundColor = .brown
        return view
    }()

}
