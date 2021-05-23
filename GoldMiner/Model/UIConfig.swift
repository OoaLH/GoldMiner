//
//  UIConfig.swift
//  GoldMiner
//
//  Created by 张翌璠 on 2021-05-20.
//

import UIKit

let joyButtonColor: UIColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2)

let player1Position: CGPoint = CGPoint(x: 300.width, y: 360.height)
let player2Position: CGPoint = CGPoint(x: 500.width, y: 360.height)

let defaultWidth: CGFloat = 800
let defaultHeight: CGFloat = 393

var safeAreaInsets: UIEdgeInsets = {
    if #available(iOS 11.0, *) {
        return UIApplication.shared.windows.first?.safeAreaInsets ?? .zero
    } else {
        return .zero
    }
}()

var realHeight: CGFloat = {
    return UIScreen.main.bounds.height - safeAreaInsets.top - safeAreaInsets.bottom
}()

var realWidth: CGFloat = {
    return UIScreen.main.bounds.width - safeAreaInsets.left - safeAreaInsets.right
}()
