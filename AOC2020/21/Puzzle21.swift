//
//  Puzzle21.swift
//  AOC2020
//
//  Created by jaydeep on 21/12/20.
//

import Foundation

class Puzzle21: Puzzle {
    typealias Food = (ingredients: Set<String>, allergens: Set<String>)

    let input: [String]
    let foods: [Food]

    init() {
        input = InputFileReader.readInput(id: "21")
        foods = input.map(Puzzle21.parseFood)
    }

    func part1() -> String {
        let inert = deriveAllergenMapAndInertIngredients().inert
        var count = 0
        for food in foods {
            for ingredient in food.ingredients {
                if inert.contains(ingredient) {
                    count += 1
                }
            }
        }
        return "\(count)"
    }

    func part2() -> String {
        let allergenMap = deriveAllergenMapAndInertIngredients().map
        let simplifiedMap = simplifyIngredients(allergenMap)
        let answer = simplifiedMap.keys.sorted().compactMap { simplifiedMap[$0] }.joined(separator: ",")
        return answer
    }

    private func deriveAllergenMapAndInertIngredients() -> (map: [String: Set<String>], inert: Set<String>) {
        var allIngredients = Set<String>() // Set of all ingredients across all foods
        var allergenMap = [String: Set<String>]() // Allergen to possible ingredients map
        foods.forEach { (food) in
            allIngredients = allIngredients.union(food.ingredients)
            for allergen in food.allergens {
                if let possibleIngredients = allergenMap[allergen] {
                    allergenMap[allergen] = food.ingredients.intersection(possibleIngredients)
                } else {
                    allergenMap[allergen] = food.ingredients
                }
            }
        }
        let allergicIngredients = allergenMap.values.reduce(into: Set<String>()) { (acc, ingredients) in
            acc = acc.union(ingredients)
        }

        let inertIngredients = allIngredients.subtracting(allergicIngredients)
        return (allergenMap, inertIngredients)
    }

    private func simplifyIngredients(_ allergenMap: [String: Set<String>]) -> [String: String] {
        var simplified = allergenMap
        var knownIngredients = simplified.values.filter { $0.count == 1 }
        while knownIngredients.count < simplified.count {
            var tmp = [String: Set<String>]() // tmp will be assigned to simplified at end of while loop
            for (allergen, ingredients) in simplified {
                var simplifiedIngredients = ingredients
                if ingredients.count > 1 {
                    knownIngredients.forEach { simplifiedIngredients = simplifiedIngredients.subtracting($0) }
                }
                tmp[allergen] = simplifiedIngredients
            }
            simplified = tmp
            knownIngredients = simplified.values.filter { $0.count == 1 }
        }
        return simplified.compactMapValues { $0.first }
    }

    private static func parseFood(_ str: String) -> Food {
        let components = str.components(separatedBy: " (contains ")
        let ingredientsStr = components[0]
        var allergensStr = components[1]
        allergensStr.removeLast()
        var ingredients = Set<String>()
        var allergens = Set<String>()
        ingredientsStr.components(separatedBy: " ").forEach { ingredients.insert($0) }
        allergensStr.components(separatedBy: ", ").forEach { allergens.insert($0) }
        return (ingredients, allergens)
    }
}
