//
//  Constants.swift
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
let diamondPrice: Int = 800

let mouseMass = smallGoldMass
let mouseBackSpeed: CGFloat = fastSpeed
let mouseWalkSpeed: CGFloat = 20
let mousePauseDuration: Double = 0.5
let mousePrice: Int = 2

let smallRockMass: Int = mediumGoldMass
let mediumRockMass: Int = largeGoldMass
let rockPrice: [Int: Int] = [smallRockMass: 20, mediumRockMass: 60]

let joyButtonColor: UIColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2)
