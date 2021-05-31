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
    
//    private override init() {
//        super.init()
//
//        GKLocalPlayer.local.register(self)
//    }
    
    private override init() {}
    
    weak var viewController: UIViewController?
    
    var currentMatch: GKMatch?
    
    func authenticate() {
        if !GKLocalPlayer.local.isAuthenticated {
            GKLocalPlayer.local.authenticateHandler = { [unowned self] viewController, error in
                if let viewController = viewController {
                    self.viewController?.present(viewController, animated: true, completion: nil)
                    return
                }
                if let error = error {
                    self.viewController?.showAlert(title: "Error Occured", message: error.localizedDescription)
                    return
                }
            }
        }
    }
    
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
        request.recipientResponseHandler = { player, response in
            print(3)
        }
        
        let vc = GKMatchmakerViewController(matchRequest: request)!
        vc.isHosted = false
        vc.matchmakerDelegate = self
        vc.modalPresentationStyle = .fullScreen
        viewController?.present(vc, animated: true)
    }
    
    func presentLeaderBoard() {
        guard GKLocalPlayer.local.isAuthenticated else {
            return
        }
        
        let vc = GKGameCenterViewController(
            leaderboardID: "BestScore",
            playerScope: .global,
            timeScope: .allTime)
        vc.gameCenterDelegate = self
        viewController?.present(vc, animated: true, completion: nil)
    }
    
    func submitScore(score: Int) {
        guard GKLocalPlayer.local.isAuthenticated else {
            return
        }
        
        GKLeaderboard.submitScore(score, context: 0, player: GKLocalPlayer.local,
                                  leaderboardIDs: ["BestScore"]) { error in
            print(error.debugDescription)
        }
    }
}

extension GameCenterHelper: GKMatchmakerViewControllerDelegate {
    func matchmakerViewControllerWasCancelled(_ viewController: GKMatchmakerViewController) {
        viewController.dismiss(animated: true)
    }
    
    func matchmakerViewController(_ viewController: GKMatchmakerViewController, didFailWithError error: Error) {
        viewController.dismiss(animated: true)
        self.viewController?.showAlert(title: "Match Maker Failed", message: error.localizedDescription)
    }
    
    func matchmakerViewController(_ viewController: GKMatchmakerViewController, didFind match: GKMatch) {
        currentMatch = match
        viewController.dismiss(animated: true, completion: nil)
        let vc = OnlineGameViewController(match: match)
        self.viewController?.present(vc, animated: true, completion: nil)
    }
}

extension GameCenterHelper: GKGameCenterControllerDelegate {
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true, completion: nil)
    }
}

//extension GameCenterHelper: GKLocalPlayerListener {
//    func player(_ player: GKPlayer, didRequestMatchWithOtherPlayers playersToInvite: [GKPlayer]) {
//        print(1)
//    }
//
//    func player(_ player: GKPlayer, didAccept invite: GKInvite) {
//        print(2)
//    }
//}
