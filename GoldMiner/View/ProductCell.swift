//
//  ProductCell.swift
//  GoldMiner
//
//  Created by Yifan Zhang on 2021-07-25.
//

import UIKit

class ProductCell: UICollectionViewCell {
    var model: SkinProduct? {
        didSet {
            imageView.image = model?.image
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var imageView = UIImageView()
}
