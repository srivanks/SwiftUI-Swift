//
//  FetchController.swift
//  Dex3
//
//  Created by iM on 24/12/2023.
//

import Foundation
import CoreData

struct FetchController {
    enum NetworkError: Error {
        case badURL, badResponse, badData
    }
    private let baseURL = URL(string: "https://pokeapi.co/api/v2/pokemon/")!
    
    func fetchAllPokemon() async throws -> [TempPokemon]? {
        if havePokemon() {
            return nil
        }
        var allPokemon: [TempPokemon] = []
        var fetchComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        fetchComponents?.queryItems = [URLQueryItem(name: "limit", value: "25")]
        
        guard let fetchURL = fetchComponents?.url else {
            throw NetworkError.badURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: fetchURL)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw NetworkError.badResponse
        }
        
        guard let pokeDictionary = try JSONSerialization.jsonObject(with: data) as? [String: Any], let pokeDex = pokeDictionary["results"] as? [[String:String]] else {
            throw NetworkError.badData
        }
        
        for pokemon in pokeDex {
            if let url = pokemon["url"] {
                allPokemon.append(try await fetchPokemon(from: URL(string: url)!))
            }
        }
        print(allPokemon)
        return allPokemon
    }
    
    private func fetchPokemon(from url: URL) async throws -> TempPokemon {
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw NetworkError.badResponse
        }
        
        let tempPokemon  = try JSONDecoder().decode(TempPokemon.self, from: data)
        
        return tempPokemon
    }
    
    private func havePokemon() -> Bool {
        let ctx = PersistenceController.shared.container.viewContext
        let fetchReq: NSFetchRequest<Pokemon> = Pokemon.fetchRequest()
        fetchReq.predicate = NSPredicate(format: "id IN %@", [1, 10])
        do{
            let checkPokemon = try ctx.fetch(fetchReq)
            
            if checkPokemon.count == 2 {
                return true
            }
        } catch {
            return false
        }
        
        return false
    }
}
