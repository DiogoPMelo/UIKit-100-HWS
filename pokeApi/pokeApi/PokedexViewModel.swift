//
//  PokedexViewModel.swift
//  pokeApi
//
//  Created by Diogo Melo on 3/24/22.
//

import Foundation

protocol PokedexDelegate: AnyObject {
    func onLoadComplete()
}

protocol PokedexFavoriteDelegate: AnyObject {
    func refresh()
}

class PokedexViewModel {
    weak var pokedex: PokedexDelegate!
    weak var favoriteDelegate: PokedexFavoriteDelegate!
    
    private(set) var pokemons = [PokemonInList]()
    private(set) var favorites = [Pokemon]()
    private var nextURL: String? = "https://pokeapi.co/api/v2/pokemon/"
    private(set) var isLoading = false
    
    init (delegate: PokedexDelegate) {
        self.pokedex = delegate
    }
    
    @objc func loadList () {
        guard !isLoading, let urlString = nextURL else {
            return
        }
        
        guard let url = URL(string: urlString) else {return}
        
        let request = URLRequest(url: url)
        isLoading = true
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                return
            }
            
            if let jsonData = try? JSONDecoder().decode(ListOfPokemon.self, from: data) {
                DispatchQueue.main.async {
                    self.pokemons += jsonData.results
                    self.pokedex.onLoadComplete()
                    self.isLoading = false
                    self.nextURL = jsonData.next
                }
                
            }
        }.resume()
    }
    
    func isLoadingCell(for indexPath: IndexPath) -> Bool {
        return indexPath.row >= pokemons.count
    }

    func addFavorite(pokemon: Pokemon) {
        favorites.append(pokemon)
        favoriteDelegate?.refresh()
    }
    
    func removeFavorite(pokemon: Pokemon) {
        if let index = favorites.firstIndex(where: {$0.id == pokemon.id}) {
            favorites.remove(at: index)
            favoriteDelegate?.refresh()
        }
    }
    
    func isFavorite (pokemonName name: String) -> Bool {
        favorites.contains(where: {$0.name == name})
    }
}
