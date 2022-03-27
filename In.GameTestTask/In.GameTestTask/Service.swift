//
//  Service.swift
//  In.GameTestTask
//
//  Created by Stas Dashkevich on 26.03.22.
//

import Foundation
import Alamofire

protocol Service {
    typealias Closure = ([Drink]) -> ()
    
    func getDrinks(completion: @escaping Closure)
}

final class ServiceImpl {
    private var baseUrl = "https://www.thecocktaildb.com/api/json/v1/1/filter.php?a=Non_Alcoholic"
}

// MARK: - Service
extension ServiceImpl: Service {
    func getDrinks(completion: @escaping Closure) {
        AF.request(baseUrl).responseJSON { response in
            guard let data = response.data else { return }
            do {
                let drinksList = try JSONDecoder().decode(DrinksList.self, from: data)
                completion(drinksList.drinks)
            } catch {
                print("error decoding == \(error)")
                completion([])
            }
        }
    }
}
