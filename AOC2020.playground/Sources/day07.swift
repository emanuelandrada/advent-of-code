import Foundation

let bagRegEx = try! NSRegularExpression(pattern: "^(?<color>\\w+ \\w+) bags contain(.+)$")
let contentRegEx = try! NSRegularExpression(pattern: "(?: (?<contentCant>\\d*) (?<contentColor>\\w+ \\w+) bags?[,\\.])")
struct BagContent {
    let color: String
    let content: [String: Int]

    init(_ description: String) {
        let captures = bagRegEx.captureGroups(string: description)[0]
        self.color = captures[1]
        var content = [String: Int]()
        for c in contentRegEx.captureGroups(string: captures[2]) {
            content[c[2]] = Int(c[1])
        }
        self.content = content
    }
}

private func parseLines() -> AnySequence<BagContent> {
    AnySequence(readLines("day07").filter { !$0.isEmpty }.map { BagContent(String($0)) })
}

let myColor = "shiny gold"

public func day07a() -> Int {
    var containedIn = [String: Set<String>]()
    for bag in parseLines() {
        bag.content.keys.forEach { containedIn[$0] = (containedIn[$0] ?? .init()).union([bag.color]) }
    }
    var prev = Set<String>()
    var bags = Set(arrayLiteral: myColor)
    while let new = bags.subtracting(prev) as Set?, !new.isEmpty {
        prev = bags
        bags.formUnion(new.flatMap { containedIn[$0] ?? .init() })
    }
    return bags.count - 1
}

public func day07b() -> Int {
    var contains = [String: [String: Int]]()
    for bag in parseLines() {
        contains[bag.color] = bag.content
    }
    func countBags(color: String, amount: Int) -> Int {
        return amount + amount * contains[color]!.reduce(0) {
            $0 + countBags(color: $1.key, amount: $1.value)
        }
    }
    return countBags(color: myColor, amount: 1) - 1
}
