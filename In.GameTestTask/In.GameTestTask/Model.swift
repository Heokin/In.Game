//
//  Model.swift
//  In.GameTestTask
//
//  Created by Stas Dashkevich on 26.03.22.
//

import Foundation

struct CoctailName: Codable {
    var drinks: [Drinks]
}

struct Drinks: Codable {
    var strDrink: String?
    var idDrink: String?
}

enum CodingKeys: String, CodingKey {
    case strDrink = "strDrink"
    case idDrink = "idDrink"
}


