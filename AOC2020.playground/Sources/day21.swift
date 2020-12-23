import Foundation

typealias Food = (ingredients: Set<String>, allergens: Set<String>)
let foodRegEx = try! NSRegularExpression(pattern: "^(.+) \\(contains (.+)\\)$")
let allergensRegEx = try! NSRegularExpression(pattern: "(\\w+)")
private func parseLines() -> [Food] {
    readLines("day21").map { foodRegEx.captureGroups(string: $0)[0] }
        .map {(
            ingredients: Set($0[1].split(separator: " ").map { String($0) }),
            allergens: Set(allergensRegEx.captureGroups(string: $0[2]).map { $0[0] })
        )}
}

func allergensIngredients(foods: [Food]) -> [String: Set<String>] {
    var allergens = [String: Set<String>]()
    foods.forEach { food in
        food.allergens.forEach { allergen in
            if allergens[allergen] == nil {
                allergens[allergen] = food.ingredients
            }
            else {
                allergens[allergen]!.formIntersection(food.ingredients)
            }
        }
    }
    return allergens
}

public func day21a() -> Int {
    let foods = parseLines()
    var allIngredients = foods.flatMap { $0.ingredients }
        .reduce(into: [String: Int]()) { allIngredients, ingredient in
            allIngredients[ingredient] = (allIngredients[ingredient] ?? 0) + 1
        }
    allergensIngredients(foods: foods).values.joined().forEach { ingredient in
        allIngredients[ingredient] = nil
    }
    return allIngredients.values.reduce(0, +)
}

public func day21b() -> String {
    var allergens = allergensIngredients(foods: parseLines())
    var matched = [String: String]()
    repeat {
        allergens.forEach { allergen in
            if allergen.value.count == 1 {
                matched[allergen.key] = allergen.value.first
                allergens[allergen.key] = nil
            }
            else {
                allergens[allergen.key] = allergen.value.subtracting(matched.values)
            }
        }
    } while !allergens.isEmpty
    return matched.sorted { $0.key < $1.key }.map { $0.value }.joined(separator: ",")
}
