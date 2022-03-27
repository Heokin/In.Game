//
//  Model.swift
//  In.GameTestTask
//
//  Created by Stas Dashkevich on 26.03.22.
//

import Foundation

struct DrinksList: Codable {
    var drinks: [Drink]
}

struct Drink: Codable {
    var strDrink: String?
}
