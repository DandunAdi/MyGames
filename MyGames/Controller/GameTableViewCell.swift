//
//  GameTableViewCell.swift
//  MyGames
//
//  Created by DDD on 02/10/20.
//  Copyright © 2020 Dandun Adi. All rights reserved.
//

import UIKit

class GameTableViewCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var gameImageView: UIImageView!
    @IBOutlet weak var gameTitleLabel: UILabel!
    @IBOutlet weak var gameRatingLabel: UILabel!
    @IBOutlet weak var gameReleaseDateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        gameImageView.layer.cornerRadius = 10
    }
    
    func setDisplay(_ selectedGame: Game, position: Int) {
        gameImageView.image = Constants.Image.defaultImage
        gameTitleLabel.text = "#\(position)  \(selectedGame.name)"
        gameRatingLabel.text = selectedGame.rating == 0.0 ? "N/A" : String(format:"%.1f", selectedGame.rating)
        gameReleaseDateLabel.text = selectedGame.released?.refactorDate() ?? "N/A"
        
        if let image = selectedGame.backgroundImage {
            guard let url = URL(string: image) else { return }
            
            DispatchQueue.global().async {
                guard let data = try? Data(contentsOf: url) else { return }
                
                DispatchQueue.main.async {
                    self.gameImageView.image = UIImage(data: data)
                }
            }
        }
    }
    
    func setDisplay(_ selectedGame: GameDetails, position: Int) {
        gameImageView.image = Constants.Image.defaultImage
        gameTitleLabel.text = "#\(position)  \(selectedGame.name)"
        gameRatingLabel.text = selectedGame.rating == 0.0 ? "N/A" : String(format:"%.1f", selectedGame.rating)
        gameReleaseDateLabel.text = selectedGame.released?.refactorDate() ?? "N/A"
        
        if let image = selectedGame.backgroundImage {
            guard let url = URL(string: image) else { return }
            
            DispatchQueue.global().async {
                guard let data = try? Data(contentsOf: url) else { return }
                
                DispatchQueue.main.async {
                    self.gameImageView.image = UIImage(data: data)
                }
            }
        }
    }
    
}
