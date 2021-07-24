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
        view.backgroundColor = .white
        
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
    
    @objc func onlineGaming() {
        spinView.startAnimating()
        view.isUserInteractionEnabled = false
        
        GameCenterHelper.helper.authenticate { [unowned self] in
            spinView.stopAnimating()
            view.isUserInteractionEnabled = true
            GameCenterHelper.helper.presentMatchmaker()
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
