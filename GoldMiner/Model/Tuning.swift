//
//  Tuning.swift
//  GoldMiner
//
//  Created by 张翌璠 on 2021-05-19.
//

import UIKit

let movePauseDuration: Double = 0.2
let gameDuration: Int = 120

let hookDefaultSpeed: CGFloat = 220.0
let hookSwingSpeed: CGFloat = 60.0
let hookShortestLength: CGFloat = 30.0
let maxHookAngle: CGFloat = -.pi * 7 / 8
let minHookAngle: CGFloat = -.pi / 8

var fastSpeed: CGFloat = 100
var mediumSpeed: CGFloat = 45
var slowSpeed: CGFloat = 20

let goldBackSpeed: [Int: CGFloat] = [smallGoldMass: fastSpeed, mediumGoldMass: mediumSpeed, largeGoldMass: slowSpeed]
let smallGoldMass: Int = 50
let mediumGoldMass: Int = 250
let largeGoldMass: Int = 500

let diamondMass: Int = smallGoldMass
let diamondBackSpeed: CGFloat = fastSpeed
var diamondPrice: Int = 600

let mouseMass = smallGoldMass
let mouseBackSpeed: CGFloat = fastSpeed
let mouseWalkSpeed: CGFloat = 20
let mousePauseDuration: Double = 0.5
let mousePrice: Int = 2

let smallRockMass: Int = mediumGoldMass
let mediumRockMass: Int = largeGoldMass
var rockPrice: [Int: Int] = [smallRockMass: 20, mediumRockMass: 60]

var randomBagMoneyRate: Int = 1
var randomBagBombRate: Int = 1
var randomBagStrengthRate: Int = 1
var randomBagMoneyRange: ClosedRange = 50...800
let randomBagMasses: Set = [smallGoldMass, mediumGoldMass, largeGoldMass]
