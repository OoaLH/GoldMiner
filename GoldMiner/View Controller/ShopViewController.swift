//
//  ShopViewController.swift
//  GoldMiner
//
//  Created by Yifan Zhang on 2021-07-25.
//

import UIKit

class ShopViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViews()
        configureEvents()
    }
    
    func configureViews() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(shopLabel)
        shopLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(40.width)
        }
        
        view.addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(shopLabel.snp.bottom).offset(10)
        }
        
        view.addSubview(buyButton)
        buyButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-40.width)
            make.width.equalTo(100.width)
            make.centerX.equalToSuperview()
        }
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.bottom.equalTo(buyButton.snp.top).offset(-10)
            make.top.equalTo(descriptionLabel.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(10)
            make.centerX.equalToSuperview()
        }
        
        view.addSubview(closeButton)
        closeButton.snp.makeConstraints { make in
            make.width.height.equalTo(20.height)
            make.left.top.equalToSuperview().offset(20.height)
        }
    }
    
    func configureEvents() {
        closeButton.addTarget(self, action: #selector(close), for: .touchUpInside)
    }
    
    @objc func close() {
        dismiss(animated: true, completion: nil)
    }
    
    lazy var models: [SkinProduct] = [SkinProduct]()
    
    lazy var shopLabel: UILabel = {
        let view = UILabel()
        view.text = "Character's Pack"
        view.font = UIFont(name: "Chalkduster", size: 20)
        return view
    }()
    
    lazy var descriptionLabel: UILabel = {
        let view = UILabel()
        view.text = "Buy Character's Pack to unlock all characters below!"
        view.font = UIFont(name: "Chalkduster", size: 14)
        return view
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = .systemBackground
        view.dataSource = self
        view.delegate = self
        view.register(ProductCell.self, forCellWithReuseIdentifier: "Product")
        return view
    }()
    
    lazy var buyButton: UIButton = {
        let view = UIButton()
        view.setTitle("Buy", for: .normal)
        view.setTitleColor(.white, for: .normal)
        view.titleLabel?.font = UIFont(name: "Chalkduster", size: 20)
        view.backgroundColor = .brown
        view.layer.cornerRadius = 10
        view.contentEdgeInsets = UIEdgeInsets(top: 20, left: 10, bottom: 20, right: 10)
        return view
    }()
    
    lazy var closeButton: UIButton = {
        let view = UIButton()
        view.setImage(UIImage(named: "close"), for: .normal)
        return view
    }()
}

extension ShopViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return models.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Product", for: indexPath) as! ProductCell
        cell.model = models[indexPath.row]
        return cell
    }
}
