//
//  InstructionViewController.swift
//  GoldMiner
//
//  Created by 张翌璠 on 2021-05-29.
//

import UIKit
import SnapKit

class InstructionViewController: UIViewController {
    override func viewDidLoad() {
        view.backgroundColor = .white
        
        view.addSubview(instructionView)
        instructionView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.left.equalToSuperview().offset(50.width)
            make.top.equalToSuperview().offset(50.width)
        }
        
        view.addSubview(closeButton)
        closeButton.snp.makeConstraints { make in
            make.width.height.equalTo(20.height)
            make.left.top.equalToSuperview().offset(10.height)
        }
        
        closeButton.addTarget(self, action: #selector(close), for: .touchUpInside)
    }
    
    @objc func close() {
        dismiss(animated: true, completion: nil)
    }
    
    lazy var instructionView: UITextView = {
        let view = UITextView()
        view.isEditable = false
        view.text = "1. Login to Game Center to play online or submit your score.\n\n2. Or just play locally with your friend.\n\n3. Press lower button to draw the claw and press upper button to use dynamite.\n\n4. Enjoy"
        view.font = UIFont(name: "Chalkduster", size: 24)
        return view
    }()
    
    lazy var closeButton: UIButton = {
        let view = UIButton()
        view.setImage(UIImage(named: "close"), for: .normal)
        return view
    }()
}
