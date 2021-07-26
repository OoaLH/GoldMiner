//
//  ProductType.swift
//  GoldMiner
//
//  Created by Yifan Zhang on 2021-07-25.
//

import Foundation

enum ProductType: String {
    case skins = "zhangyifan.GoldMiner.skins"
    
    static var all: [ProductType] {
        return [skins]
    }
}
