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
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "GameTableViewCell", bundle: nil), forCellReuseIdentifier: "SearchedGameCell")
        activityIndicator.isHidden = true
        
        self.hideKeyboardWhenTappedAround()
    }
    
}


//MARK: - Search Bar Delegate

extension SearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchText = searchBar.text, searchBar.text?.count != 0 {
            DispatchQueue.main.async {
                self.searchedGames = []
                self.tableView.reloadData()
                self.activityIndicator.startAnimating()
                self.activityIndicator.isHidden = false
                searchBar.resignFirstResponder()
            }
            
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
                    self.activityIndicator.stopAnimating()
                    self.tableView.reloadData()
                }
            } else {
                print("nillll")
            }
        }
    }
    
    // Hides keyboard when user tap outside
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
}


//MARK: - Table View Data Source & Delegate

extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchedGames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "SearchedGameCell", for: indexPath) as? GameTableViewCell {

            let selectedGame = searchedGames[indexPath.row]
            cell.setDisplay(selectedGame, position: indexPath.row + 1)
            
            return cell
        } else {
            return UITableViewCell()
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("tapped")
        let destinationVC = DetailViewController(nibName: "DetailViewController", bundle: nil)
        destinationVC.gameId = searchedGames[indexPath.row].id
        destinationVC.hidesBottomBarWhenPushed = true
        
        self.tableView.deselectRow(at: indexPath, animated: true)
        self.navigationController?.pushViewController(destinationVC, animated: true)
    }
    
}
