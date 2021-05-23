//
//  Tuning.swift
//  GoldMiner
//
//  Created by 张翌璠 on 2021-05-19.
//

import UIKit

let movePauseDuration: Double = 0.2
let gameDuration: Int = 60

let hookDefaultSpeed: CGFloat = 300.0.height
let hookSwingSpeed: CGFloat = 60.0
let hookShortestLength: CGFloat = 30.0.height
let hookLongestLength: CGFloat = 500.height
let maxHookAngle: CGFloat = -.pi * 7 / 8
let minHookAngle: CGFloat = -.pi / 8

var fastSpeed: CGFloat = 100.height
var mediumSpeed: CGFloat = 55.height
var slowSpeed: CGFloat = 30.height

let smallGoldPrice: Int = 50
let mediumGoldPrice: Int = 250
let largeGoldPrice: Int = 500

var diamondPrice: Int = 600

let mouseWalkSpeed: CGFloat = 20.width
let mousePauseDuration: Double = 0.5
let mousePrice: Int = 2

var smallRockPrice: Int = 20
var mediumRockPrice: Int = 60

var randomBagMoneyRate: Int = 1
var randomBagBombRate: Int = 1
var randomBagStrengthRate: Int = 1
var randomBagMoneyRange: ClosedRange = 50...800
