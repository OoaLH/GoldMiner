//
//  GameMessage.swift
//  GoldMiner
//
//  Created by 张翌璠 on 2021-05-23.
//

import Foundation

enum MessageType {
    case randomNumber(UInt32)
    case bombed
    case caught
    case shot
    case bucket
}

struct Message {
    var type: MessageType
}
