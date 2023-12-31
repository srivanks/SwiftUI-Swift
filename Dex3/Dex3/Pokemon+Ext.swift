//
//  Pokemon+Ext.swift
//  Dex3
//
//  Created by iM on 25/12/2023.
//

import Foundation

extension Pokemon {
    var background: String {
        switch self.types![0] {
        case "normal", "grass", "electric", "poison", "fairy":
            return "normalgrasselectricpoisonfairy"
        case "rock", "ground", "steel", "fighting", "ghost", "dark", "psychic":
            return "rockgroundsteelfightingghostdarkpsychic"
        case "fire", "dragon":
            return "firedragon"
        case "flying", "bug":
            return"flyingbug"
        case "ice":
            return "ice"
        case "water":
            return "water"
        default:
            return "hi"
        }
    }
    
    var stats: [Stat] {
        [
            Stat(id :1, label: "HP", value: self.hp),
            Stat(id :2, label: "Attack", value: self.attack),
            Stat(id :3, label: "Defence", value: self.defensive),
            Stat(id :4, label: "Special Attack", value: self.specialAttack),
            Stat(id :5, label: "Special Defence", value: self.specialDefensive),
            Stat(id :6, label: "Speed", value: self.speed),
        ]
    }
    
    var highestStat: Stat {
        stats.max {$0.value < $1.value}!
    }
}

struct Stat: Identifiable {
    let id: Int
    let label: String
    let value: Int16
}
