//
//  FavoritesViewController.swift
//  pokeApi
//
//  Created by Diogo Melo on 3/24/22.
//

import UIKit

class FavoritesViewController: UITableViewController, PokedexFavoriteDelegate {
    
    var viewModel: PokedexViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Favorite")
        
        title = "Favorites"
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.favorites.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: "Favorite")
        
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "Pokemon")
        }
        
            cell.textLabel?.text = viewModel.favorites[indexPath.row].name
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let pokemon = PokemonView()
        pokemon.loadView()
        pokemon.pokedex = self.viewModel
        pokemon.viewModel = PokemonViewModel(pokemon: viewModel.favorites[indexPath.row], delegate: pokemon)
         
        navigationController?.pushViewController(pokemon, animated: true)
    }
    
    func refresh() {
        tableView.reloadData()
    }
    
    }
