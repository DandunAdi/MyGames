//
//  String.swift
//  MyGames
//
//  Created by DDD on 16/10/20.
//  Copyright © 2020 Dandun Adi. All rights reserved.
//

import Foundation

extension String {
  func refactorDate(_ format: String = "yyyy-MM-dd") -> String? {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = format
    guard let date = dateFormatter.date(from: self) else {
        print("Take a look to your format")
        return nil
    }
    dateFormatter.dateStyle = .medium
    let dateString = dateFormatter.string(from: date)
    return dateString
  }
}
