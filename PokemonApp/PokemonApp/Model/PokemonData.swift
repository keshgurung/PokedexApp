//
//  PokemonData.swift
//  PokemonApp
//
//  Created by Kesh Gurung on 17/07/2022.
//

import Foundation

struct PokemonData: Decodable {
    let abilities: [Ability]
    let moves: [Move]
    let name: String
    let sprites : Image
    let types: [PokeType]
  
}

struct Image: Decodable{
    
    let frontShiny: String
    let home: Home?
    
    enum CodingKeys: String, CodingKey{
        case frontShiny = "front_shiny"
        case home
    }
}
struct Home: Decodable{
    let front: String?
    let shiny: String?
    
    
    enum CodingKeys: String, CodingKey{
        case front = "front_default"
        case shiny = "front_shiny"
    }
}

struct Ability: Decodable {
    let ability: abilityName
}

struct abilityName: Decodable{
    let name: String
}

struct Move: Decodable {
    let move: MoveName
}

struct MoveName: Decodable {
    let name: String
}


struct PokeType: Decodable {
    let type: typeName
}

struct typeName: Decodable {
    let name: String
}
