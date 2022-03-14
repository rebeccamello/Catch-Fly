//
//  GameCenterSevice.swift
//  FlyGame
//
//  Created by Mariana Abraão on 14/03/22.
//

import GameKit

class GameCenterService: GKGameCenterViewController {
    
    /* MARK: - Atributos */
    
    static let leaderboardID = "mainLeaderboard"
    
    var controller: UIViewController!
    
    
    
    /* MARK: - Construtor */
    
    /// Chama a controller responsável para mostrar as telas do Game Center
    init(with controller: UIViewController) {
        super.init(nibName: nil, bundle: nil)
        
        self.controller = controller
    }
    
    required init?(coder aDecoder: NSCoder) {fatalError("init(coder:) has not been implemented")}
    
    
    
    /* MARK: - Métodos */
    
    /// Faz a autenticação do usuário
    public func autenticateUser(_ completionHandler: @escaping (Result<Bool, ErrorHandler>) -> Void) -> Void {
        GKLocalPlayer.local.authenticateHandler = {vc, error in
            
            // Se tiver algum erro
            guard let _ = error else {
                completionHandler(.failure(.authenticationError))
                return
            }
            
            if let vc = vc {
                self.controller.present(vc, animated: true, completion: nil)
                completionHandler(.success(true))
                return
            }
        }
    }
    
    
    /// Pega o score salvo no Game Center
    public func getHighScore(_ completionHandler: @escaping (Result<Int, ErrorHandler>) -> Void) -> Void {
        if (GKLocalPlayer.local.isAuthenticated) {
            GKLeaderboard.loadLeaderboards(IDs: [GameCenterService.leaderboardID]) {leaderboards, _ in
                leaderboards?[0].loadEntries(for: [GKLocalPlayer.local], timeScope: .allTime) {
                    player, _, error in
                    
                    // Verifica se tem algum erro
                    if let _ = error {
                        completionHandler(.failure(.badCommunication))
                        return
                    }
                    
                    // Verifica se o player e o score existem
                    guard let score = player?.score else {
                        completionHandler(.failure(.scoreNotFound))
                        return
                    }
                    
                    // Atualiza o user defaults caso necessário
                    if UserDefaults.standard.integer(forKey: "score") < score {
                        UserDefaults.standard.set(player?.score, forKey: "score")
                    }
                    
                    completionHandler(.success(score))
                }
            }
        }
    }
    
    
    /// Define o score no Game Center
    public func submitHighScore(score: Int, _ completionHandler: @escaping (Result<Bool, ErrorHandler>) -> Void ) -> Void{
        if (GKLocalPlayer.local.isAuthenticated) {
            UserDefaults.standard.set(score, forKey: "score")
            
            GKLeaderboard.submitScore(score, context: 0, player: GKLocalPlayer.local, leaderboardIDs: [GameCenterService.leaderboardID]) {error in
                
                if let _ = error {
                    completionHandler(.failure(.scoreNotSubmited))
                }
                completionHandler(.success(true))
            }
        }
    }
    
    
    /// Abre a página do game center
    public func showGameCenterPage(_ state: GKGameCenterViewControllerState = .leaderboards) -> Void {
        if (GKLocalPlayer.local.isAuthenticated) {
            let vc = GKGameCenterViewController(state: state)
            // vc.gameCenterDelegate = self
            self.controller.present(vc, animated: true, completion: nil)
        }
    }
}


