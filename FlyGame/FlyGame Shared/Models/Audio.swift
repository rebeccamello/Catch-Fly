//
//  Audio.swift
//  FlyGame
//
//  Created by Gui Reis on 21/03/22.
//

/// Tipos de áudios
enum AudiosList: CustomStringConvertible {
    case backgroundMusic
    case button
    case swipe
    case colision
    case coin
    var description: String {
        switch self {
        case .backgroundMusic: return "Musica-Fundo.mp3"
        case .button: return "Som-Botao.mp3"
        case .swipe: return "Som-Swipe.mp3"
        case .colision: return "Som-Colisao.mp3"
        case .coin: return "Som-Moeda.mp3"
        }
    }
}

/// Acões de um áudio
enum AudiosAction {
    case play
    case pause
}

/// Quantidade de reproduções
enum AudioReproduction: Int {
    case oneTime = 0
    case loop = -1
}

/// Tipos de áudio
enum AudioType: CustomStringConvertible {
    case sound
    case music
    
    /// Chave do UserDefaults
    var description: String {
        switch self {
        case .sound: return "sound"
        case .music: return "music"
        }
    }
}
