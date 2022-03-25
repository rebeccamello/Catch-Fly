//
//  ErrorHandler.swift
//  FlyGame
//
//  Created by Gui Reis on 23/03/22.
//

import struct Foundation.URLError


/**
    Classe responsável pelo tratamento dos erros que podem acontecer na API.
 
    Todos os erros são categorizados e tratados, podendo ter acesso á eles pelo que é mostrado ao usuário
 (`localizedDescription` ) ou para o desenvolvedor (`description`).
*/
enum ErrorHandler: Error, CustomStringConvertible {
    case noAuthenticaded
    case authenticationError
    case scoreNotFound
    case scoreNotSubmited
    case badCommunication

    /// Feedback para o usuário
    var localizedDescription: String {
        switch self {
        case .noAuthenticaded, .authenticationError:
            return "Falha na autenticação com o Game Center."
        case .scoreNotFound, .badCommunication, .scoreNotSubmited:
            return "Houve um erro"
        }
    }

    /// Feedback completo para desenvolver
    var description: String {
        switch self {
        case .noAuthenticaded: return "Game Center off"
        case .authenticationError: return "Erro na hora de autenticar com o Game Center"
        case .scoreNotFound: return "Pontuação não foi encontrado"
        case .scoreNotSubmited: return "Pontuação não foi postada."
        case .badCommunication: return "Houve um erro na hora de se conectar com o Leaderboard"
        }
    }
}
