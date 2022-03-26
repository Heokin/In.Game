//
//  Service.swift
//  In.GameTestTask
//
//  Created by Stas Dashkevich on 26.03.22.
//

import Foundation
import Alamofire

class Service {
    
    fileprivate var baseUrl = "https://www.thecocktaildb.com/api/json/v1/1/filter.php?a=Non_Alcoholic"
    
    func getCoctailName() {
        AF.request(baseUrl).responseJSON { response in
            print (response)
            guard let data = response.data else { return }
            do {
                let drinks = try? JSONDecoder().decode(CoctailName.self, from: data)
                print(drinks?.drinks.first?.strDrink)
                
            } catch {
                print("error decoding == \(error)")
            }
        }
    }
}
