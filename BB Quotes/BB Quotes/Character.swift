//
//  Character.swift
//  BB Quotes
//
//  Created by iM on 23/12/2023.
//

import Foundation

struct Character: Decodable {
    let name: String
    let birthday: String
    let occupations: [String]
    let images: [URL]
    let aliases: [String]
    let portrayedBy: String
}
