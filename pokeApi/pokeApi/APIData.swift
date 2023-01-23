//
//  APIData.swift
//  pokeApi
//
//  Created by Diogo Melo on 3/23/22.
//

import Foundation

struct Pokemon: Codable {
    var baseExperience: UInt
    var id: UInt
    var name: String
    var height: UInt
    var weight: UInt
}

struct ListOfPokemon: Codable {
    var count: Int
    var next: String?
    var previous: String?
    var results: [PokemonInList]
}

struct PokemonInList: Codable {
    var name: String
    var url: String
}
