//
//  GameNetworking.swift
//  MyGames
//
//  Created by DDD on 28/09/20.
//  Copyright © 2020 Dandun Adi. All rights reserved.
//

import Foundation

class GameNetworking {
    
    // Shared singleton
    static var shared = GameNetworking()
    
    private let pageSize = "20"
    var searchValue = ""
    private var components = URLComponents(string: "https://api.rawg.io/api/games")!
    
    func parseData(for category: GameCategory) {
        print("parse data executed")
        components.queryItems = [ URLQueryItem(name: "page_size", value: pageSize) ]
        
        switch category {
        case .topRated:
            components.queryItems?.append(URLQueryItem(name: "ordering", value: "-rating"))
        case .mostRecent:
            components.queryItems?.append(URLQueryItem(name: "ordering", value: "added"))
        case .search:
            components.queryItems?.append(URLQueryItem(name: "search", value: searchValue))
        }
        
        let request = URLRequest(url: components.url!)
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let response = response as? HTTPURLResponse, let data = data else {return}
            
            if response.statusCode == 200 {
                print(self.components.url!)
                self.decodeJSON(data: data)
                
            } else {
                fatalError("Bad response \(response.statusCode)")
            }
        }.resume()
    }
    
    private func decodeJSON(data: Data) {
        let decoder = JSONDecoder()
        do {
            let games = try decoder.decode(Games.self, from: data)
            print(games)
        } catch let error {
            print("Error decoding data \(error)")
        }
    }
    
    
        
}
