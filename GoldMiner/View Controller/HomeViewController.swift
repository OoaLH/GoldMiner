//
//  HomeViewController.swift
//  GoldMiner
//
//  Created by 张翌璠 on 2021-05-23.
//

import UIKit
import GameKit
import SnapKit

class HomeViewController: UIViewController {
    var disconnected: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViews()
        configureEvents()
        
        NetworkMonitor.shared.start()
        
        GameCenterHelper.helper.viewController = self
        GameCenterHelper.helper.authenticate()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if disconnected {
            showAlert(title: "Match Ended", message: "Disconnected from the host.")
            disconnected = true
        }
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscape
    }
    
    func configureViews() {
        view.addSubview(backgroundView)
        backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.addArrangedSubview(onlineButton)
        stackView.addArrangedSubview(localButton)
        stackView.addArrangedSubview(leaderBoardButton)
        stackView.addArrangedSubview(instructionButton)
        stackView.addArrangedSubview(aboutButton)
        view.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(40.width)
            make.centerY.equalToSuperview()
            make.width.equalTo(200.width)
        }
        
        view.addSubview(spinView)
        spinView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    func configureEvents() {
        onlineButton.addTarget(self, action: #selector(onlineGaming), for: .touchUpInside)
        localButton.addTarget(self, action: #selector(localGaming), for: .touchUpInside)
        leaderBoardButton.addTarget(self, action: #selector(leaderBoard), for: .touchUpInside)
        instructionButton.addTarget(self, action: #selector(instruction), for: .touchUpInside)
        aboutButton.addTarget(self, action: #selector(about), for: .touchUpInside)
    }
    
    func checkIfUsingCellular(_ completionHandler: (() -> Void)? = nil) {
        if NetworkMonitor.shared.usingCellular {
            let alert = UIAlertController(title: "You are using cellular data", message: nil, preferredStyle: .alert)
            let ok = UIAlertAction(title: "Continue", style: .default) { _ in
                completionHandler?()
            }
            alert.addAction(ok)
            let cancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)
            alert.addAction(cancel)
            alert.preferredAction = ok
            present(alert, animated: true, completion: nil)
        } else if NetworkMonitor.shared.reachable {
            completionHandler?()
        } else {
            showAlert(title: "Can't connect to Internet", message: "Please check your network settings. Your Internet connection will affect online games, uploading scores to Game Center, and access to leaderboard.")
        }
    }
    
    @objc func onlineGaming() {
        checkIfUsingCellular { [unowned self] in
            spinView.startAnimating()
            view.isUserInteractionEnabled = false
            
            GameCenterHelper.helper.authenticate {
                spinView.stopAnimating()
                view.isUserInteractionEnabled = true
                GameCenterHelper.helper.presentMatchmaker()
            }
        }
    }
    
    @objc func localGaming() {
        let vc = GameViewController()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
    
    @objc func leaderBoard() {
        spinView.startAnimating()
        view.isUserInteractionEnabled = false
        
        GameCenterHelper.helper.authenticate { [unowned self] in
            spinView.stopAnimating()
            view.isUserInteractionEnabled = true
            
            GameCenterHelper.helper.presentLeaderBoard()
        }
    }
    
    @objc func instruction() {
        present(InstructionViewController(), animated: true, completion: nil)
    }
    
    @objc func about() {
        UIApplication.shared.open(URL(string: "https://github.com/OoaLH")!, options: [:], completionHandler: nil)
    }
    
    lazy var backgroundView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "home")
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    lazy var onlineButton: UIButton = {
        let view = UIButton()
        view.setTitle("online", for: .normal)
        view.setTitleColor(.white, for: .normal)
        view.titleLabel?.font = UIFont(name: "Chalkduster", size: 20)
        view.backgroundColor = .brown
        view.layer.cornerRadius = 10
        return view
    }()
    
    lazy var localButton: UIButton = {
        let view = UIButton()
        view.setTitle("local", for: .normal)
        view.setTitleColor(.white, for: .normal)
        view.titleLabel?.font = UIFont(name: "Chalkduster", size: 20)
        view.backgroundColor = .brown
        view.layer.cornerRadius = 10
        return view
    }()
    
    lazy var leaderBoardButton: UIButton = {
        let view = UIButton()
        view.setTitle("leaderboard", for: .normal)
        view.setTitleColor(.white, for: .normal)
        view.titleLabel?.font = UIFont(name: "Chalkduster", size: 20)
        view.backgroundColor = .brown
        view.layer.cornerRadius = 10
        return view
    }()
    
    lazy var instructionButton: UIButton = {
        let view = UIButton()
        view.setTitle("instruction", for: .normal)
        view.setTitleColor(.white, for: .normal)
        view.titleLabel?.font = UIFont(name: "Chalkduster", size: 20)
        view.backgroundColor = .brown
        view.layer.cornerRadius = 10
        return view
    }()
    
    lazy var aboutButton: UIButton = {
        let view = UIButton()
        view.setTitle("about", for: .normal)
        view.setTitleColor(.white, for: .normal)
        view.titleLabel?.font = UIFont(name: "Chalkduster", size: 20)
        view.backgroundColor = .brown
        view.layer.cornerRadius = 10
        return view
    }()
    
    lazy var spinView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.color = .brown
        return view
    }()
}
