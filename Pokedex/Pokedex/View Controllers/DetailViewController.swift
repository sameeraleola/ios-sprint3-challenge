//
//  DetailViewController.swift
//  Pokedex
//
//  Created by Sameera Roussi on 5/10/19.
//  Copyright © 2019 Sameera Roussi. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UISearchBarDelegate {
    
    // MARK: - Outlets
    
    @IBOutlet weak var pokemonSearchBar: UISearchBar!
    
    @IBOutlet weak var allElementsStack: UIStackView!
    
    @IBOutlet weak var spriteImage: UIImageView!
    @IBOutlet weak var pokemonNameLabel: UILabel!
    @IBOutlet weak var pokemonIDLabel: UILabel!
    @IBOutlet weak var pokemonTypeLabel: UILabel!
    @IBOutlet weak var pokemonAbilitiesLabel: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    
    // MARK: Properties
    
    var pokemon: Pokemon?
    
    let searchController = UISearchController(searchResultsController: nil)
    var isSearching:Bool = false
    
    
    // MARK: - View States

    override func viewDidLoad() {
        super.viewDidLoad()

        // Set up search bar
        pokemonSearchBar.delegate = self

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //Determine if we are searching or reviewing a saved Pokemon
        if((pokemon?.detail ?? false)) {
            pokemonSearchBar.isHidden = true
            saveButton.isHidden = true
            //Display the saved Pokemon
            navigationItem.title = pokemon?.name?.uppercased()
            pokemonNameLabel.text = pokemon?.name?.uppercased()
            pokemonIDLabel.text = pokemon?.id
            pokemonTypeLabel.text = pokemon?.types
            pokemonAbilitiesLabel.text = pokemon?.abilities
            spriteImage.image = pokemon?.sprite
            allElementsStack.isHidden.toggle()
        }
    }
    
    
    // MARK: - Functions
    
    @IBAction func pokemonSave(_ sender: Any) {
        PersistentData.shared.add(pokemon: self.pokemon!)
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController];
        self.navigationController!.popToViewController(viewControllers[viewControllers.count - 2], animated: true);
    }

    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        pokemonSearchBar.autocapitalizationType = .none
        pokemonSearchBar.resignFirstResponder()
        guard let findThisPokemon = pokemonSearchBar.text?.lowercased(), !findThisPokemon.isEmpty else { return }
        
        // Clear the searchbar and set the placeholder text
        searchBar.text = ""
        searchBar.placeholder = findThisPokemon.lowercased()
        
        NetworkData.shared.searchForPokemon(with: findThisPokemon) { (error) in
            if error == nil {
                
                DispatchQueue.main.async {
                    // First, make sure we have a Pokemon
                    guard let pokemon = NetworkData.shared.pokemonAPI else { return }
                    // We have a Pokemon so populate the fields
                    self.pokemonNameLabel.text = pokemon.name
                    self.pokemonIDLabel.text = "\(pokemon.id)"
                    let pokemonTypes = pokemon.types.map({$0.type.name.capitalized}).joined(separator: ", ")
                    self.pokemonTypeLabel.text = pokemonTypes
                    let pokemonAbilities = pokemon.abilities.map({$0.ability.name.capitalized}).joined(separator: ", ")
                    self.pokemonAbilitiesLabel.text = pokemonAbilities
                    //get the sprite
                    guard let url = URL(string: pokemon.sprites.frontDefault), let spriteData = try? Data(contentsOf: url) else { return }
                    self.spriteImage.image = UIImage(data: spriteData)
                    
                    //Show the form if necessary
                    if (self.allElementsStack.isHidden == true) {
                        self.allElementsStack.isHidden.toggle()
                    }
                    // Clear the placeholder text
                    searchBar.placeholder = nil
                    // Set the navigation title to the Pokemon name.
                    self.navigationItem.title = pokemon.name
                    // Update the button title to included the Pokemon name
                    self.saveButton.setTitle("Save \(pokemon.name?.capitalized ?? "Pokemon")", for: .normal)
                    // Grab the Pokemon
                    self.pokemon = Pokemon.init(name: pokemon.name!, id: "\(pokemon.id)", abilities: pokemonAbilities, types: pokemonTypes, sprite: self.spriteImage.image!)
                    
                }
            }
        }
    }
    
} // End of class

