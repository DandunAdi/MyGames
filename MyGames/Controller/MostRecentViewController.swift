//
//  MostRecentViewController.swift
//  MyGames
//
//  Created by DDD on 29/09/20.
//  Copyright © 2020 Dandun Adi. All rights reserved.
//

import UIKit

class MostRecentViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var mostRecentGames = [Game]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self

        GameNetworking.shared.parseData(for: .mostRecent) { (games) in
            if let games = games {
                games.results.forEach { (game) in
                    print(game)
                }
                self.mostRecentGames = games.results
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } else {
                print("nillllll")
            }
        }
    }

}

extension MostRecentViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mostRecentGames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MostRecentGameCell", for: indexPath)
        let selectedGame = mostRecentGames[indexPath.row]
        cell.textLabel?.text = selectedGame.name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let destinationVC = DetailViewController(nibName: "DetailViewController", bundle: nil)
        destinationVC.gameId = mostRecentGames[indexPath.row].id
        destinationVC.hidesBottomBarWhenPushed = true

        self.navigationController?.pushViewController(destinationVC, animated: true)
    }
}
