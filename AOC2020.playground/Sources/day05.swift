import Foundation

func decodeId(string: String) -> Int {
    string.reduce(0) { $0 * 2 + ($1 == "B" || $1 == "R" ? 1 : 0) }
}

private func parseLines() -> [Int] {
    readLines("day05").filter { !$0.isEmpty }
        .map(decodeId)
}

public func day05a() -> Int {
    parseLines().max()!
}

public func day05b() -> Int {
    let ids = parseLines()
    let first = ids.first!
    return parseLines().reduce((min: first, max: first, missing: Set<Int>())) { (prev, id) in
        if id < prev.min {
            return (min: id, max: prev.max, missing: prev.missing.union((id+1)..<prev.min))
        }
        if id > prev.max {
            return (min: prev.min, max: id, missing: prev.missing.union((prev.max+1)..<id))
        }
        return (min: prev.min, max: prev.max, missing: prev.missing.subtracting([id]))
    }
    .missing.first!
}
