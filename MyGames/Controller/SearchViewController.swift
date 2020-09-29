//
//  SearchViewController.swift
//  MyGames
//
//  Created by DDD on 29/09/20.
//  Copyright © 2020 Dandun Adi. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    
    var searchedGames = [Game]()
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        searchBar.delegate = self
        tableView.dataSource = self
    }
    
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        if let searchText = searchBar.text, searchBar.text?.count != 0 {
            GameNetworking.shared.searchValue = searchText
        } else {
            print("Text empty")
            return
        }
        
        GameNetworking.shared.parseData(for: .search) { (games) in
            if let games = games {
                games.results.forEach { (game) in
                    print(game.name)
                }
                self.searchedGames = games.results
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
            } else {
                print("nillll")
            }
        }
    }
}

extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchedGames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchedGameCell", for: indexPath)
        let selectedGame = searchedGames[indexPath.row]
        cell.textLabel?.text = selectedGame.name
        
        return cell
    }
}
