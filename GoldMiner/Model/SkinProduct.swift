//
//  SkinProduct.swift
//  GoldMiner
//
//  Created by Yifan Zhang on 2021-07-25.
//

import UIKit

struct SkinProduct {
    var image: UIImage
    var name: String
    
    init(name: String) {
        self.name = name
        self.image = UIImage(named: name)!
    }
}
