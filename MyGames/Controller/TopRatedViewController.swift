//
//  TopRatedViewController.swift
//  MyGames
//
//  Created by DDD on 29/09/20.
//  Copyright © 2020 Dandun Adi. All rights reserved.
//

import UIKit

class TopRatedViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var topRatedGames = [Game]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self

        GameNetworking.shared.parseData(for: .topRated) { (games) in
            if let games = games {
                games.results.forEach { (game) in
                    print(game.name)
                }
                self.topRatedGames = games.results
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } else {
                print("nillll")
            }
        }
    }
    
}

extension TopRatedViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return topRatedGames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TopRatedGameCell", for: indexPath)
        let selectedGame = topRatedGames[indexPath.row]
        cell.textLabel?.text = selectedGame.name
        
        return cell
    }
    
}
