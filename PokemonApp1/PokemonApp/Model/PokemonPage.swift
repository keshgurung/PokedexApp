//
//  PokemonPage.swift
//  PokemonApp
//
//  Created by Kesh Gurung on 15/07/2022.
//

import Foundation

struct PokemonPage: Decodable {
    let results: [results]
   
}

struct results: Decodable {
    let url: String
}


