//
//  PokemonViewModel.swift
//  pokeApi
//
//  Created by Diogo Melo on 3/24/22.
//

import Foundation

protocol PokemonViewDelegate: AnyObject {
    func configureScreen(pokemon: Pokemon)
}

class PokemonViewModel {
    weak var delegate: PokemonViewDelegate!
    var pokemon: Pokemon! {
        didSet {
            delegate.configureScreen(pokemon: pokemon)
        }
    }

    init (pokemon: Pokemon, delegate: PokemonViewDelegate) {
        self.delegate = delegate
        self.pokemon = pokemon
        self.delegate.configureScreen(pokemon: pokemon)
        assert(self.delegate != nil, "delegate nil")
        assert(self.pokemon != nil, "nil pokemon")
    }
    
    init (urlString: String, delegate: PokemonViewDelegate) {
        self.delegate = delegate
        
        guard let url = URL(string: urlString) else {
            return
        }
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {return}
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            if let pokemon = try? decoder.decode(Pokemon.self, from: data) {
                DispatchQueue.main.async {
                    self.pokemon = pokemon
                }
            }
        }.resume()
    }

}
