//
//  FavoritedViewController.swift
//  MyGames
//
//  Created by DDD on 17/10/20.
//  Copyright © 2020 Dandun Adi. All rights reserved.
//

import UIKit

class FavoritedViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var favoritedGames = [GameDetails]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: Constants.Table.gameTableViewCellNibName, bundle: nil), forCellReuseIdentifier: Constants.Table.favoritedCellReuseIdentifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.favoritedGames = []
        GameManager.shared.getFavoriteGames { (gameDetails) in
            self.favoritedGames.append(gameDetails)
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                self.favoritedGames.sort {
                    $0.id < $1.id
                }
                self.tableView.reloadData()
            }
        }
    }
    
}

extension FavoritedViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoritedGames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Table.favoritedCellReuseIdentifier, for: indexPath) as? GameTableViewCell {
            
            let selectedGame = favoritedGames[indexPath.row]
            cell.setDisplay(selectedGame, position: indexPath.row + 1)
            
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let destinationVC = DetailViewController(nibName: Constants.Controller.detailViewControllerNibName, bundle: nil)
        destinationVC.gameId = favoritedGames[indexPath.row].id
        destinationVC.hidesBottomBarWhenPushed = true
        
        self.tableView.deselectRow(at: indexPath, animated: true)
        self.navigationController?.pushViewController(destinationVC, animated: true)
    }
}

