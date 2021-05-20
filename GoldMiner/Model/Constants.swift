//
//  Constants.swift
//  GoldMiner
//
//  Created by 张翌璠 on 2021-05-19.
//

import UIKit

let hookDefaultSpeed: CGFloat = 220.0
let hookSwingSpeed: CGFloat = 60.0
let hookShortestLength: CGFloat = 30.0
let maxHookAngle: CGFloat = -.pi * 7 / 8
let minHookAngle: CGFloat = -.pi / 8

let fastSpeed: CGFloat = 100
let mediumSpeed: CGFloat = 45
let slowSpeed: CGFloat = 20

let goldBackSpeed: [Int: CGFloat] = [smallGoldMass: fastSpeed, mediumGoldMass: mediumSpeed, largeGoldMass: slowSpeed]
let smallGoldMass: Int = 50
let mediumGoldMass: Int = 250
let largeGoldMass: Int = 500

let diamondMass: Int = smallGoldMass
let diamondBackSpeed: CGFloat = fastSpeed
let diamondPrice: Int = 800

let mouseMass = smallGoldMass
let mouseBackSpeed: CGFloat = fastSpeed
let mousePrice: Int = 2

let smallRockMass: Int = mediumGoldMass
let mediumRockMass: Int = largeGoldMass
let rockPrice: [Int: Int] = [smallRockMass: 20, mediumRockMass: 60]

let joyButtonColor: UIColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2)
