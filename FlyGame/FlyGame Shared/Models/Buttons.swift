//
//  Buttons.swift
//  FlyGame
//
//  Created by Gui Reis on 21/03/22.
//

/// Todos os tipos de botões do jogo
enum Buttons: CustomStringConvertible {
    case resume
    case play
    case menu
    case pause
    case restart
    case musicOn
    case musicOff
    case soundOn
    case soundOff
    case tutorial
    case gameCenter
    case revive
    case giveUp
    var description: String {
        switch self {
        case .resume: return "continuarBotao"
        case .play: return "jogarBotao"
        case .menu: return "menuBotao"
        case .pause: return "pauseBotao"
        case .restart: return "recomecarBotao"
        case .musicOn: return "musicaBotao"
        case .musicOff: return "musicaDesligadoBotao"
        case .soundOn: return "somBotao"
        case .soundOff: return "somDesligadoBotao"
        case .tutorial: return "tutorialBotao"
        case .gameCenter: return "gameCenterBotao"
        case .revive: return "reviverBotao"
        case .giveUp: return "giveUpBotao"
        }
    }
}
