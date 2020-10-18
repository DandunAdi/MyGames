//
//  GameManager.swift
//  MyGames
//
//  Created by DDD on 17/10/20.
//  Copyright © 2020 Dandun Adi. All rights reserved.
//

import Foundation

class GameManager {
    static var shared = GameManager()
    static var favoriteGameProvider = FavoriteGameProvider()
    private var favoriteGamesId = [Int]()
    
    func getFavoriteGames(completion: @escaping(GameDetails) -> Void){
        for gameId in favoriteGamesId {
            GameNetworking.shared.getGameDetails(id: gameId) { (gameDetails) in
                if let gameDetails = gameDetails {
                    completion(gameDetails)
                }
            }
        }
    }
    
    func isFavorited(_ id: Int) -> Bool {
        if favoriteGamesId.contains(id) {
            return true
        }
        return false
    }
    
    func loadFavoritedGames() {
        GameManager.favoriteGameProvider.getAllFavoritedGames { (gamesId) in
            self.favoriteGamesId = gamesId
        }
    }
}
