//
//  PokemonView.swift
//  pokeApi
//
//  Created by Diogo Melo on 3/24/22.
//

import UIKit

class PokemonView: UIViewController, PokemonViewDelegate {
    var viewModel: PokemonViewModel!
    var pokedex: PokedexViewModel!
    
    var faveBtn: UIButton!
    
    override func loadView() {
        super.loadView()
        
        title = "Loading..."
        
        faveBtn = UIButton()
        faveBtn.setTitle("Favorite", for: .normal)
        faveBtn.setTitle("Unfavorite", for: .selected)
        faveBtn.addTarget(self, action: #selector(favoriteTapped), for: .touchUpInside)
        view.addSubview(faveBtn)
        faveBtn.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            faveBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            faveBtn.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func configureScreen (pokemon: Pokemon) {
        assert(pokemon != nil, "nil pokemon")
        title = "\(pokemon.name), \(pokemon.id)"
        assert(faveBtn != nil, "nil button")
        faveBtn?.isSelected = pokedex.isFavorite(pokemonName: pokemon.name)
    }
    
    @objc func favoriteTapped (_ sender: UIButton) {
        assert(pokedex != nil, "nil pokedex in add/remove favorite")
        if sender.isSelected {
            pokedex?.removeFavorite(pokemon: viewModel.pokemon)
            sender.isSelected = false
        } else {
            pokedex?.addFavorite(pokemon: viewModel.pokemon)
            sender.isSelected = true
        }
    }
    
}
