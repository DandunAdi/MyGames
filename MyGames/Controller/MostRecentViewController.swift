//
//  MostRecentViewController.swift
//  MyGames
//
//  Created by DDD on 29/09/20.
//  Copyright © 2020 Dandun Adi. All rights reserved.
//

import UIKit

class MostRecentViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        GameNetworking.shared.parseData(for: .mostRecent) { (games) in
            if let games = games {
                games.results.forEach { (game) in
                    print(game.name)
                }
            } else {
                print("nillllll")
            }
        }
    }

}
