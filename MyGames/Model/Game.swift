//
//  Game.swift
//  MyGames
//
//  Created by DDD on 28/09/20.
//  Copyright © 2020 Dandun Adi. All rights reserved.
//

import Foundation

struct Games: Codable {
    let results: [Game]
}

struct Game: Codable {
    let id: Int
    let name: String
    let backgroundImage: String?
    let rating: Double
    let released: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case backgroundImage = "background_image"
        case rating
        case released
    }
}

enum GameCategory {
    case topRated, mostRecent, search
}
