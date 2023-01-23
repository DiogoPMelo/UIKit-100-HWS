//
//  ViewController.swift
//  pokeApi
//
//  Created by Diogo Melo on 3/23/22.
//

import UIKit

class PokedexViewController: UITableViewController, UITableViewDataSourcePrefetching, PokedexDelegate {
    
    var viewModel: PokedexViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Pokemon")
        tableView.prefetchDataSource = self
        title = "PokeApi"
        
        DispatchQueue.global(qos: .userInteractive).async {
            self.viewModel.loadList()
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.pokemons.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: "Pokemon")
        
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "Pokemon")
        }
        
        if viewModel.isLoadingCell(for: indexPath) {
            cell.textLabel?.text = "loading"
        } else {
            let pokemonName = viewModel.pokemons[indexPath.row].name
            cell.textLabel?.text = pokemonName.capitalized
            
            if viewModel.isFavorite(pokemonName: pokemonName) {
                cell.imageView?.image = UIImage(named: "heart")
            }
        }
        
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        DispatchQueue.global(qos: .userInteractive).async {
            self.viewModel.loadList()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let urlString = viewModel.pokemons[indexPath.row].url
        
        let pokemon = PokemonView()
        pokemon.viewModel = PokemonViewModel(urlString: urlString, delegate: pokemon)
        pokemon.pokedex = self.viewModel
        
        
        navigationController?.pushViewController(pokemon, animated: true)
    }
    
    func onLoadComplete () {
        tableView.reloadData()
    }
    
    }
