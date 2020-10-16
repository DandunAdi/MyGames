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
        tableView.register(UINib(nibName: Constants.Table.gameTableViewCellNibName, bundle: nil), forCellReuseIdentifier: Constants.Table.searchedCellReuseIdentifier)
        activityIndicator.isHidden = true
        
        self.hideKeyboardWhenTappedAround()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: true)
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
            searchBar.placeholder = "Please insert keyword"
            return
        }
        
        GameNetworking.shared.parseData(for: .search) { (games) in
            if let games = games {
                self.searchedGames = games.results
                
                guard self.searchedGames.count != 0 else {
                    DispatchQueue.main.async {
                        self.activityIndicator.stopAnimating()
                        let alert = UIAlertController(title: "Not Found!", message: "Games you're looking for is not found. Please check your spelling keyword.", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(alert, animated: true)
                    }
                    return
                }
                
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.tableView.reloadData()
                }
            } else {
                print("no data received")
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
        if let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Table.searchedCellReuseIdentifier, for: indexPath) as? GameTableViewCell {

            let selectedGame = searchedGames[indexPath.row]
            cell.setDisplay(selectedGame, position: indexPath.row + 1)
            
            return cell
        } else {
            return UITableViewCell()
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let destinationVC = DetailViewController(nibName: Constants.Controller.detailViewControllerNibName, bundle: nil)
        destinationVC.gameId = searchedGames[indexPath.row].id
        destinationVC.hidesBottomBarWhenPushed = true
        
        self.tableView.deselectRow(at: indexPath, animated: true)
        self.navigationController?.pushViewController(destinationVC, animated: true)
    }
    
}
