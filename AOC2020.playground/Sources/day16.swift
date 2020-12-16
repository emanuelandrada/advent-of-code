import Foundation

let ruleRegEx = try! NSRegularExpression(pattern: "(\\d+)-(\\d+)")
struct Rule {
    let ranges: [ClosedRange<Int>]

    init(_ description: String) {
        ranges = ruleRegEx.captureGroups(string: description)
            .map { Int($0[1])!...Int($0[2])! }
    }
    func matches(_ value: Int) -> Bool {
        ranges.first { $0.contains(value) } != nil
    }
}

private func parseLines() -> (fields: [String: Rule], myTicket: [Int], otherTickets: AnySequence<[Int]>) {
    let file = readLines("day16")
    var fields = [String: Rule]()
    for line in file {
        if line.isEmpty {
            break
        }
        let components = line.split(separator: ":")
        fields[String(components[0])] = Rule(String(components[1]))
    }
    func parseTicket(_ line: String) -> [Int] {
        line.split(separator: ",").map { Int($0)! }
    }
    _ = file.next() // your ticket:
    let myTicket = parseTicket(file.next()!)
    _ = file.next() //
    _ = file.next() // nearby tickets:
    let otherTickets = AnySequence(file.map(parseTicket))
    return (fields: fields, myTicket: myTicket, otherTickets: otherTickets)
}

public func day16a() -> Int {
    let (fields, _, otherTickets) = parseLines()
    return otherTickets.flatMap { $0 }
        .filter { value in fields.values.first { $0.matches(value) } == nil }
        .reduce(0, +)
}

public func day16b() -> Int {
    let (fields, myTicket, otherTickets) = parseLines()
    var validTickets = Array(otherTickets.filter {
        $0.reduce(true) { r, value in r && fields.values.first { $0.matches(value) } != nil }
    })
    validTickets.append(myTicket)
    let initialCols = Array(0..<myTicket.count)
    var matchingIndexes = fields.mapValues { fieldRule in
        validTickets.reduce(initialCols) { cols, ticket in
            cols.filter { i in
                fieldRule.matches(ticket[i])
            }
        }
    }
    var indexes = [String: Int]()
    while matchingIndexes.count > 0 {
        let resolved = matchingIndexes.map { f in
            (name: f.key, index: f.value.filter { !indexes.values.contains($0) }.first { i in
                matchingIndexes.first {
                    $0.key != f.key && $0.value.contains(i)
                } == nil
            })
        }.first { $0.index != nil }!
        indexes[resolved.name] = resolved.index!
        matchingIndexes[resolved.name] = nil
    }
    return indexes.filter { $0.key.starts(with: "departure") }
        .values.map { myTicket[$0] }.reduce(1, *)
}
