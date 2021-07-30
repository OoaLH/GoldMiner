//
//  GameSession.swift
//  GoldMiner
//
//  Created by 张翌璠 on 2021-05-20.
//

import Foundation

enum GameMode {
    case local
    case online
}

class GameSession {
    static let shared = GameSession()
    
    private init() {}
    
    var mode: GameMode = .local
    
    var numberOfBomb: Int = 0
    
    var money: Int = 0
    
    var player1Score: Int = 0
    
    var player2Score: Int = 0
    
    var otherSkin: SkinType?
    
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
    
    func newSession(mode: GameMode = .local) {
        self.mode = mode
        numberOfBomb = 0
        money = 0
        player1Score = 0
        player2Score = 0
        otherSkin = nil
        level = 1
        goal = 650
        goalIncrement = 650
        
        recoverTuning()
    }
    
    func recoverTuning() {
        Tuning.fastSpeed = 100.height
        Tuning.mediumSpeed = 55.height
        Tuning.slowSpeed = 30.height
        
        Tuning.smallRockPrice = 20
        Tuning.mediumRockPrice = 60
        
        Tuning.diamondPrice = 600
        
        Tuning.randomBagMoneyRate = 3
        Tuning.randomBagBombRate = 1
        Tuning.randomBagStrengthRate = 1
        Tuning.randomBagMoneyRange = 50...800
    }
}
