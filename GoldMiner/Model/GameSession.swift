//
//  GameSession.swift
//  GoldMiner
//
//  Created by 张翌璠 on 2021-05-20.
//

import Foundation

class GameSession {
    static let shared = GameSession()
    
    private init() {}
    
    var numberOfBomb: Int = 0
    
    var money: Int = 0
    
    var player1Score: Int = 0
    
    var player2Score: Int = 0
    
    var level: Int = 1
    
    var goal: Int = 650//+545 +815 +1085 + 1355 +1625 +1895 +2165 +2435 +2705
    
    var goalIncrement = 545
    
    func nextLevel() {
        level += 1
        goal += goalIncrement
        if goalIncrement <= 2435 {
            goalIncrement += 270
        }
        
        recoverTuning()
    }
    
    func newSession() {
        numberOfBomb = 0
        money = 0
        player1Score = 0
        player2Score = 0
        level = 1
        goal = 650
        goalIncrement = 650
        
        recoverTuning()
    }
    
    func recoverTuning() {
        fastSpeed = 100.height
        mediumSpeed = 55.height
        slowSpeed = 30.height
        
        smallRockPrice = 20
        mediumRockPrice = 60
        
        diamondPrice = 600
        
        randomBagMoneyRate = 1
        randomBagBombRate = 1
        randomBagStrengthRate = 1
        randomBagMoneyRange = 50...800
    }
}
