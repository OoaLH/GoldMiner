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
        return self * UIConfig.realHeight / UIConfig.defaultHeight
    }
    
    var width: CGFloat {
        return self * UIConfig.realWidth / UIConfig.defaultWidth
    }
}

extension Double: Dimension {
    var height: CGFloat {
        return CGFloat(self) * UIConfig.realHeight / UIConfig.defaultHeight
    }
    
    var width: CGFloat {
        return CGFloat(self) * UIConfig.realWidth / UIConfig.defaultWidth
    }
}

extension Int: Dimension {
    var height: CGFloat {
        return CGFloat(self) * UIConfig.realHeight / UIConfig.defaultHeight
    }
    
    var width: CGFloat {
        return CGFloat(self) * UIConfig.realWidth / UIConfig.defaultWidth
    }
}
