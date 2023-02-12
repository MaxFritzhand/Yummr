//
//  Food.swift
//  PlopIt
//
//  Created by Raivis Olehno on 08/01/2022.
//

import Foundation

struct Food: Identifiable {
    let id: UUID
    var foodName: String
    var description: String
    var price: Float
    var foodCategory: String
    
    
    init(id: UUID = UUID(), foodName: String, description: String, price: Float, foodCategory: String ) {
            self.id = id
            self.foodName = foodName
            self.description = description
            self.price = price
            self.foodCategory = foodCategory
        }
    //best way to sign in is with Google my business profile to get all the biz info
}

extension Food {
    static let sampleData: [Food] =
    [
        Food(foodName: "Bagel", description: "donut without the sugar", price: 4.90, foodCategory: "Entree" ),
        Food(foodName: "Burrito", description: "hodgepodge of mexican spices in a wrap", price: 6.90, foodCategory: "Entree" ),
        Food(foodName: "Energy Drink", description: "Coke and sugar in liquid form", price: 2.00, foodCategory: "Drink" ),
        Food(foodName: "Cake", description: "Icing and fluffy goodness", price: 9.0, foodCategory: "Dessert" ),
        Food(foodName: "Ice Cream", description: "Cold cream from a cow's utters", price: 4.20, foodCategory: "Dessert" ),
    ]
}
