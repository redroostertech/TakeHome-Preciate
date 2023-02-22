//
//  Movie.swift
//  TakeHomeProject-Preciate
//
//  Created by Michael Westbrooks II on 2/21/23.
//

import Foundation

struct Movie: Decodable {
    let id: Int
    let title: String
    var year: String?
    var runtime: String?
    var genres: [String]?
    var director: String?
    var actors: String?
    var plot: String?
}
