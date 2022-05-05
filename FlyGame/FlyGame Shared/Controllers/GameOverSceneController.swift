//
//  GameOverController.swift
//  FlyGame
//
//  Created by Nathalia do Valle Papst on 07/03/22.
//

import SpriteKit

class GameOverSceneController {
    
    /* MARK: - Atributos */
    
    weak var gameOverDelegate: GameOverLogicDelegate?
    
    /* MARK: - Métodos */
    
    /// Lida com a pontuação para o Game Center
    func scoreHandler(with score: Int) {
        // Atualiza o placar
        if score > UserDefaults.getIntValue(with: .highScore) {
            GameCenterService.shared.submitHighScore(score: score) {error in
                if error != nil {
                    UserDefaults.updateValue(in: .highScore, with: score)
                }
            }
        }
    }
    
    /// Cria o reconhecimento do toque nos controles
    func getTvControlTapRecognizer() -> UITapGestureRecognizer {
        let tap = UITapGestureRecognizer()
        tap.addTarget(self, action: #selector(clicked))
        return tap
    }
    
    /// Ações dos botões quando clicados pelo controle da TV
    @objc func clicked() {
        if gameOverDelegate?.getButtons()[0].isFocused == true {
            gameOverDelegate?.goToMenu()
        } else if gameOverDelegate?.getButtons()[1].isFocused == true {
           gameOverDelegate?.restartGame()
        }
    }
}
