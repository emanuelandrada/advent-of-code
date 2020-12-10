import Foundation

private func parseLines() -> [Int] {
    readLines("day10").compactMap { Int($0) }.sorted()
}

public func day10a() -> Int {
    let count = parseLines().reduce((0, 1, 0)) { (result: (Int, Int, Int), value: Int) -> (Int, Int, Int) in
        let diff = value - result.2
        return (result.0 + (diff == 1 ? 1 : 0), result.1 + (diff == 3 ? 1 : 0), value)
    }
    return count.0 * count.1
}

public func day10b() -> Int {
    var stack = [(0, 1)]
    for adapter in parseLines() {
        let combinations = stack.reduce(0) { $0 + (adapter - $1.0 <= 3 ? $1.1 : 0) }
        if stack.count == 3 {
            stack.remove(at: 0)
        }
        stack.append((adapter, combinations))
    }
    return stack.last!.1
}

