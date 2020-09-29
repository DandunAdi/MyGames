//
//  TopRatedViewController.swift
//  MyGames
//
//  Created by DDD on 29/09/20.
//  Copyright © 2020 Dandun Adi. All rights reserved.
//

import UIKit

class TopRatedViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        GameNetworking.shared.parseData(for: .topRated)
    }
    
}
