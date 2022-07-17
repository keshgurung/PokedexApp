//
//  MoviePage.swift
//  FirstMVCApp
//
//  Created by iAskedYou2nd on 7/14/22.
//

import Foundation

struct MoviePage: Decodable {
    
    let page: Int
    let results: [Movie]
    let totalPages: Int
    let totalResults: Int
    
    enum CodingKeys: String, CodingKey {
        case totalPages = "total_pages"
        case totalResults = "total_results"
        case page, results
    }
}

struct Movie: Decodable {
    let id: Int
    let title: String
    let overview: String
    let posterPath: String
    let viewerRating: Double
    
    enum CodingKeys: String, CodingKey {
        case posterPath = "poster_path"
        case viewerRating = "vote_average"
        case id, title, overview
    }
    
}

