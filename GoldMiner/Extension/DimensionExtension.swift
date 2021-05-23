//
//  DimensionExtension.swift
//  GoldMiner
//
//  Created by 张翌璠 on 2021-05-22.
//

import UIKit

protocol Dimension {
    var height: CGFloat { get }
    var width: CGFloat { get }
}

extension CGFloat: Dimension {
    var height: CGFloat {
        return self * realHeight / defaultHeight
    }
    
    var width: CGFloat {
        return self * realWidth / defaultWidth
    }
}

extension Double: Dimension {
    var height: CGFloat {
        return CGFloat(self) * realHeight / defaultHeight
    }
    
    var width: CGFloat {
        return CGFloat(self) * realWidth / defaultWidth
    }
}

extension Int: Dimension {
    var height: CGFloat {
        return CGFloat(self) * realHeight / defaultHeight
    }
    
    var width: CGFloat {
        return CGFloat(self) * realWidth / defaultWidth
    }
}
