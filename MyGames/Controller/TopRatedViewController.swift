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
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var topRatedGames = [Game]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: Constants.Table.gameTableViewCellNibName, bundle: nil), forCellReuseIdentifier: Constants.Table.topRatedCellReuseIdentifier)

        GameNetworking.shared.parseData(for: .topRated) { (games) in
            if let games = games {
                self.topRatedGames = games.results
                
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.tableView.reloadData()
                }
            } else {
                print("no data received")
            }
        }
    }
    
}

extension TopRatedViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return topRatedGames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Table.topRatedCellReuseIdentifier, for: indexPath) as? GameTableViewCell {

            let selectedGame = topRatedGames[indexPath.row]
            cell.setDisplay(selectedGame, position: indexPath.row + 1)
            
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let destinationVC = DetailViewController(nibName: Constants.Controller.detailViewControllerNibName, bundle: nil)
        destinationVC.gameId = topRatedGames[indexPath.row].id
        destinationVC.hidesBottomBarWhenPushed = true
        
        self.tableView.deselectRow(at: indexPath, animated: true)
        self.navigationController?.pushViewController(destinationVC, animated: true)
    }
}
