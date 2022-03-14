//
//  GameCenterSevice.swift
//  FlyGame
//
//  Created by Mariana Abraão on 14/03/22.
//

import GameKit

class GameCenterService: GKGameCenterViewController{
    var controller: UIViewController!
    
    init(controller: UIViewController){
        super.init(nibName: nil, bundle: nil)
        self.controller = controller
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func autenticateUser() {
        GKLocalPlayer.local.authenticateHandler = { vc, error in
            if (vc == nil && error == nil) {
                // self.getHighScoreFromLeadboard(label:label)
                return
            }
            guard error == nil else { return }
            
            self.controller.present(vc!, animated: true, completion: nil)
        }
    }
    
    func getHighScore() {
        if (GKLocalPlayer.local.isAuthenticated) {
            GKLeaderboard.loadLeaderboards(IDs: ["lbHighScore"]) { leaderboards, _ in
                leaderboards?[0].loadEntries(for: [GKLocalPlayer.local], timeScope: .allTime) {
                    player, _, _ in
                    
                    //if (player?.score == nil) {return}
                        
                    if (player?.score != nil && UserDefaults.standard.integer(forKey: "score") < (player?.score)!) {
                        UserDefaults.standard.set(player?.score, forKey: "score")
                    }
                    
                    // label.text = "Best".localized() + " " +  String(UserDefaults.standard.integer(forKey: "score"))
                }
            }
        }
    }
    
    func setHighScore(score: Int) {
        if (GKLocalPlayer.local.isAuthenticated) {
            UserDefaults.standard.set(score, forKey: "score")
            
            
            GKLeaderboard.submitScore(score, context: 0, player: GKLocalPlayer.local, leaderboardIDs: ["lbHighScore"]) {_ in}
        }
    }
    
    func showGameCenterPage(_ state: GKGameCenterViewControllerState = .leaderboards) {
        if (GKLocalPlayer.local.isAuthenticated) {
            let vc = GKGameCenterViewController(state: state)
            // vc.gameCenterDelegate = self
            self.controller.present(vc, animated: true, completion: nil)
        }
    }
}


