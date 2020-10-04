//
//  DetailViewController.swift
//  MyGames
//
//  Created by DDD on 30/09/20.
//  Copyright © 2020 Dandun Adi. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    var gameId: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.isHidden = true
        imageView.layer.cornerRadius = 15
        navigationItem.largeTitleDisplayMode = .never
        
        GameNetworking.shared.getGameDetails(id: gameId) { (gameDetails) in
            guard let gameDetails = gameDetails else {return}
            
            print(gameDetails)
            if let image = gameDetails.backgroundImage {
                let url = URL(string: image)
                
                DispatchQueue.global().async {
                    let data = try? Data(contentsOf: url!)
                    DispatchQueue.main.async {
                        self.imageView.image = UIImage(data: data!)
                        self.imageView.isHidden = false
                    }
                }
            }
            
            DispatchQueue.main.async {
                self.titleLabel.text = gameDetails.name
                self.descriptionLabel.text = gameDetails.descriptionRaw
            }
        }
    }
    
}
