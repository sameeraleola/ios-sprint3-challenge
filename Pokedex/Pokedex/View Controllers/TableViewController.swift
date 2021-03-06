//
//  TableViewController.swift
//  Pokedex
//
//  Created by Sameera Roussi on 5/10/19.
//  Copyright © 2019 Sameera Roussi. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    
    // MARK: Outlets
    
    @IBOutlet weak var selectSortSegmentControl: UISegmentedControl!
    

    // MARK: - Properties
    
    // Collect the Pokemon sent back to be saved
    var pokemon: Pokemon?
    
    // MARK: - View states
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }

    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return PersistentData.shared.numberOfPokemonSaved
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PokemonList", for: indexPath)
        
        // Get the saved Pokemon
        let savedPokemon = PersistentData.shared.getPokemon(at: indexPath.row)
        //And list them
        
        
        cell.imageView?.image = savedPokemon.sprite
        cell.textLabel?.text = savedPokemon.name
        
        return cell
    }

 
    // MARK: - Edit data
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    // This may not look like delete but it is!!!!
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        // Only handle deletions
        guard editingStyle == .delete else { return }
        
        PersistentData.shared.removePokemon(at: indexPath.row)
        // tableView.reloadData()
        tableView.deleteRows(at: [indexPath], with: .fade)
    }
    
    @IBAction func editTable(_ sender: Any) {
        tableView.setEditing(true, animated: true)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(stopEditingTable(_:)))
    }
    
    @objc
    func stopEditingTable(_ sender: Any) {
        tableView.setEditing(false, animated: true)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editTable(_:)))
    }

    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard
            let destination = segue.destination as? DetailViewController,
            let indexPath = tableView.indexPathForSelectedRow
            else { return }
        
        let pokemon = PersistentData.shared.getPokemon(at: indexPath.row)
        pokemon.detail = true
        destination.pokemon = pokemon
    }
    
} // End of class
