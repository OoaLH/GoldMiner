//
//  Tuning.swift
//  GoldMiner
//
//  Created by 张翌璠 on 2021-05-19.
//

import UIKit

struct Tuning {
    static let movePauseDuration: Double = 0.2
    static let gameDuration: Int = 60

    static let hookDefaultSpeed: CGFloat = 300.0.height
    static let hookSwingSpeed: CGFloat = 60.0
    static let hookShortestLength: CGFloat = 30.0.height
    static let hookLongestLength: CGFloat = 500.height
    static let maxHookAngle: CGFloat = -.pi * 7 / 8
    static let minHookAngle: CGFloat = -.pi / 8

    static var fastSpeed: CGFloat = 100.height
    static var mediumSpeed: CGFloat = 55.height
    static var slowSpeed: CGFloat = 30.height

    static let smallGoldPrice: Int = 50
    static let mediumGoldPrice: Int = 250
    static let largeGoldPrice: Int = 500

    static var diamondPrice: Int = 600

    static let mouseWalkSpeed: CGFloat = 20.width
    static let mousePauseDuration: Double = 0.5
    static let mousePrice: Int = 2

    static var smallRockPrice: Int = 20
    static var mediumRockPrice: Int = 60

    static var randomBagMoneyRate: Int = 1
    static var randomBagBombRate: Int = 1
    static var randomBagStrengthRate: Int = 1
    static var randomBagMoneyRange: ClosedRange = 50...800
}
