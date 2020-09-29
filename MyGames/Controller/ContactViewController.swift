//
//  ContactViewController.swift
//  MyGames
//
//  Created by DDD on 30/09/20.
//  Copyright © 2020 Dandun Adi. All rights reserved.
//

import UIKit

class ContactViewController: UIViewController {

    @IBOutlet weak var profileImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        profileImage.layer.cornerRadius = profileImage.frame.width / 2
    }

}
