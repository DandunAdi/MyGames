//
//  GameDetails.swift
//  MyGames
//
//  Created by DDD on 01/10/20.
//  Copyright © 2020 Dandun Adi. All rights reserved.
//

import Foundation

struct GameDetails: Codable {
    let id: Int
    let name: String
    let released: String?
    let backgroundImage: String?
    let rating: Double
    let descriptionRaw: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case released
        case backgroundImage = "background_image"
        case rating
        case descriptionRaw = "description_raw"
    }
}
