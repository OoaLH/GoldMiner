//
//  LevelData.swift
//  GoldMiner
//
//  Created by 张翌璠 on 2021-05-24.
//

import UIKit

struct LevelData {
    var buckets: [[CGPoint]] = [[],
                                [],
                                [],
                                [],
                                [],
                                []]

    var diamonds: [[CGPoint]] = [[],
                                 []]

//    var mice: [[CGPoint]] = [[]]
    var diamondMice: [[CGPoint]] = [[],
                                    [],
                                    []]

    var randomBags: [[CGPoint]] = [[CGPoint(x: 100.width, y: 250.height), CGPoint(x: 700.width, y: 250.height)]]

    var smallRocks: [[CGPoint]] = [[CGPoint(x: 120.width, y: 270.height), CGPoint(x: 720.width, y: 280.height)]]
    var mediumRocks: [[CGPoint]] = [[CGPoint(x: 400.width, y: 100.height), CGPoint(x: 500.width, y: 200.height)]]

//    var smallGolds: [[CGPoint]] = [[]]
    var mediumGolds: [[CGPoint]] = [[]]
    var largeGolds: [[CGPoint]] = [[CGPoint(x: 100.width, y: 100.height), CGPoint(x: 450.width, y: 150.height)]]
    
    subscript(index: Int) -> SingleLevel {
        if index < 10 {
            return SingleLevel(buckets: buckets[index], diamonds: diamonds[index], diamondMice: diamondMice[index], randomBags: randomBags[index], smallRocks: smallRocks[index], mediumRocks: mediumRocks[index], mediumGolds: mediumGolds[index], largeGolds: largeGolds[index])
        }
        let i = index % 7
        return SingleLevel(buckets: buckets[i], diamonds: diamonds[i], diamondMice: diamondMice[i], randomBags: randomBags[i], smallRocks: smallRocks[i], mediumRocks: mediumRocks[i], mediumGolds: mediumGolds[i], largeGolds: largeGolds[i])
    }
}

struct SingleLevel {
    var buckets: [CGPoint]

    var diamonds: [CGPoint]

//    var mice: [CGPoint]
    var diamondMice: [CGPoint]

    var randomBags: [CGPoint]

    var smallRocks: [CGPoint]
    var mediumRocks: [CGPoint]

//    var smallGolds: [CGPoint]
    var mediumGolds: [CGPoint]
    var largeGolds: [CGPoint]
}
