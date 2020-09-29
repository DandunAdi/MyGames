//
//  GameManager.swift
//  MyGames
//
//  Created by DDD on 28/09/20.
//  Copyright © 2020 Dandun Adi. All rights reserved.
//

import Foundation

class GameManager {
    
    func getTopRated() -> Games? {
        return GameNetworking.shared.parseData(for: .topRated)
    }
    
    func getMostRecent() -> Games? {
        return GameNetworking.shared.parseData(for: .mostRecent)
    }
    
    func getSearch() {
        
    }
    
    
}
