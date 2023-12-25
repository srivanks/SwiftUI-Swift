//
//  PokemonViewModel.swift
//  Dex3
//
//  Created by iM on 24/12/2023.
//

import Foundation


@MainActor
class PokemonViewModel: ObservableObject {
    enum Status {
        case notStarted
        case fetching
        case success
        case failed(error: Error)
    }
    
    private let controller: FetchController
    @Published private(set) var status = Status.notStarted
    init(controller: FetchController){
        self.controller = controller
        
        Task {
            await getPokemon()
        }
    }
    
    func getPokemon() async {
        status = .fetching
        do {
            guard var pokedex = try await controller.fetchAllPokemon() else {
                status = .success
                return
            }
            pokedex.sort {$0.id < $1.id}
            
            for pokemon in pokedex {
                let newPokemon = Pokemon(context: PersistenceController.shared.container.viewContext)
                newPokemon.id = Int16(pokemon.id)
                newPokemon.name = pokemon.name
                newPokemon.types = pokemon.types
                newPokemon.hp = Int16(pokemon.hp)
                newPokemon.attack = Int16(pokemon.attack)
                newPokemon.defensive = Int16(pokemon.defensive)
                newPokemon.specialAttack = Int16(pokemon.specialAttack)
                newPokemon.specialDefensive = Int16(pokemon.specialDefensive)
                newPokemon.speed = Int16(pokemon.speed)
                newPokemon.sprite = pokemon.sprite
                newPokemon.shiny = pokemon.shiny
                newPokemon.favorite = false
                
                try PersistenceController.shared.container.viewContext.save()
                status = .success
            }
        }catch{
            status = .failed(error: error)
        }
    }
}
