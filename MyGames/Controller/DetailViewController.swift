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
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var gameId: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.layer.cornerRadius = 15
        navigationItem.largeTitleDisplayMode = .never
        
        GameNetworking.shared.getGameDetails(id: gameId) { (gameDetails) in
            guard let gameDetails = gameDetails else {return}
            
            if let image = gameDetails.backgroundImage {
                let url = URL(string: image)
                
                DispatchQueue.global().async {
                    if let data = try? Data(contentsOf: url!){
                        DispatchQueue.main.async {
                            self.imageView.image = UIImage(data: data)
                        }
                    }
                }
            }
            
            var genreString = [String]()
            gameDetails.genres.forEach { (genre) in
                genreString.append(genre.name)
            }
            
            DispatchQueue.main.async {
                self.titleLabel.text = gameDetails.name
                self.descriptionLabel.text = gameDetails.descriptionRaw
                self.releaseDateLabel.text = "Released on \(gameDetails.released?.refactorDate() ?? "N/A")"
                self.genreLabel.text = genreString.joined(separator: ", ")
                self.ratingLabel.text = gameDetails.rating == 0.0 ? "N/A" : String(format: "%.1f", gameDetails.rating)
                self.activityIndicator.stopAnimating()
            }
        }
    }
    
}
