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
    @IBOutlet weak var favoriteButton: UIButton!
    var gameId: Int = 0
    var isFavorited: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.layer.cornerRadius = 15
        navigationItem.largeTitleDisplayMode = .never
        
        GameNetworking.shared.getGameDetails(id: gameId) { (gameDetails) in
            guard let gameDetails = gameDetails else {return}
            
            self.isFavorited = GameManager.shared.isFavorited(gameDetails.id)
            
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
                self.resetFavoriteButton()
                self.activityIndicator.stopAnimating()
            }
        }
    }
    
    @IBAction func favoriteButtonDIdTapped(_ sender: UIButton) {
        if isFavorited {
            GameManager.favoriteGameProvider.deleteFavoritedGame(gameId) {
                DispatchQueue.main.async {
                    self.isFavorited = !self.isFavorited
                    self.resetFavoriteButton()
                }
            }
        } else {
            GameManager.favoriteGameProvider.addNewFavoritedGames(gameId) {
                DispatchQueue.main.async {
                    self.isFavorited = !self.isFavorited
                    self.resetFavoriteButton()
                }
            }
        }
    }
    
    func resetFavoriteButton() {
        GameManager.shared.loadFavoritedGames()
        self.favoriteButton.setTitle(self.isFavorited ? "Remove from Favorites" : "Add to Favorites", for: .normal)
        self.favoriteButton.backgroundColor = self.isFavorited ? .systemRed : .systemBlue
    }
    
}
