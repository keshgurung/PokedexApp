//
//  PokemonData.swift
//  PokemonApp
//
//  Created by Kesh Gurung on 17/07/2022.
//

import Foundation

struct PokemonData: Decodable {
    let name: String
    let id: Int
    let abilities: [Ability]
    let sprites : Sprites
    let types: [PokeType]
    let moves: [Move]
  
}

struct Sprites: Decodable{
    
    let frontShiny: String
    let other: Other
    
    enum CodingKeys: String, CodingKey{
        case frontShiny = "front_shiny"
        case other
    }
}
struct Other: Decodable{
    
    let home: Home
    
}

struct Home: Decodable {
    
    let frontDefault: String
    let frontShiny: String
    
    
    enum CodingKeys: String, CodingKey{
        case frontDefault = "front_default"
        case frontShiny = "front_shiny"
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
