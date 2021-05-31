//
//  Tuning.swift
//  GoldMiner
//
//  Created by 张翌璠 on 2021-05-19.
//

import UIKit

struct Tuning {
    static let movePauseDuration: Double = 0.1
    static let gameDuration: Int = 40
    static let timeOutDuration: Double = 30

    static let hookDefaultSpeed: CGFloat = 300.0
    static let hookSwingSpeed: CGFloat = 60.0
    static let hookShortestLength: CGFloat = 40.0
    static let hookLongestLength: CGFloat = 500
    static let maxHookAngle: CGFloat = -.pi * 7 / 8
    static let minHookAngle: CGFloat = -.pi / 8

    static var fastSpeed: CGFloat = 100
    static var mediumSpeed: CGFloat = 55
    static var slowSpeed: CGFloat = 30

    static let smallGoldPrice: Int = 50
    static let mediumGoldPrice: Int = 100
    static let largeGoldPrice: Int = 250

    static var diamondPrice: Int = 600

    static let mouseWalkSpeed: CGFloat = 50
    static let mousePauseDuration: Double = 0.5
    static let mousePrice: Int = 2

    static var smallRockPrice: Int = 20
    static var mediumRockPrice: Int = 60

    static var randomBagMoneyRate: Int = 3
    static var randomBagBombRate: Int = 1
    static var randomBagStrengthRate: Int = 1
    static var randomBagMoneyRange: ClosedRange = 50...800
}
