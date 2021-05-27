//
//  GameMessage.swift
//  GoldMiner
//
//  Created by 张翌璠 on 2021-05-23.
//

import Foundation

enum MessageType: Int {
    case bombed = 0
    case shot
    case bought
    
    case goods
    case goodsReply
    
    case money
    
    case bombs
    
    case smallGold
    case smallGoldReply
    case smallGoldFinish
}

struct Message {
    var type: MessageType
    var x: Float
    var y: Float
}
