//
//  GameCenterHelper.swift
//  GoldMiner
//
//  Created by 张翌璠 on 2021-05-23.
//

import GameKit

struct Role {
    static let player1: UInt32 = 0xFFFF0000
    static let player2: UInt32 = 0x0000FFFF
    static let either: UInt32 = 0xFFFFFFFF
}

final class GameCenterHelper: NSObject {
    static let helper = GameCenterHelper()
    
    private override init() {}
    
    weak var viewController: UIViewController?
    
    var currentMatch: GKMatch?
    
    var role: UInt32 = Role.player2
    
    func presentMatchmaker() {
        guard GKLocalPlayer.local.isAuthenticated else {
            return
        }
        
        let request = GKMatchRequest()
        request.minPlayers = 2
        request.maxPlayers = 2
        request.defaultNumberOfPlayers = 2
        request.playerAttributes = Role.either
        request.inviteMessage = "Would you like to play Gold Miner together?"
        
        let vc = GKMatchmakerViewController(matchRequest: request)!
        vc.matchmakerDelegate = self
        
        viewController?.present(vc, animated: true)
    }
}

extension GameCenterHelper: GKMatchmakerViewControllerDelegate {
    func matchmakerViewControllerWasCancelled(_ viewController: GKMatchmakerViewController) {
        viewController.dismiss(animated: true)
    }
    
    func matchmakerViewController(_ viewController: GKMatchmakerViewController, didFailWithError error: Error) {
        print("Matchmaker vc did fail with error: \(error.localizedDescription).")
    }
    
    func matchmakerViewController(_ viewController: GKMatchmakerViewController, didFind match: GKMatch) {
        currentMatch = match
        viewController.dismiss(animated: true, completion: nil)
        let vc = OnlineGameViewController(match: match)
        self.viewController?.present(vc, animated: true, completion: nil)
    }
}

