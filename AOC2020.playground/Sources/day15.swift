import Foundation

struct LastSpoken: IteratorProtocol {
    let initialNumbers: [Int]
    var numberLastTurn = [Int: Int]()
    var lastNumber = 0
    var lastTurn = 0

    mutating func next() -> Int? {
        guard lastTurn >= initialNumbers.count else {
            lastNumber = initialNumbers[lastTurn]
            lastTurn += 1
            numberLastTurn[lastNumber] = lastTurn
            return lastNumber
        }
        let nextNumber = numberLastTurn[lastNumber].map { lastTurn - $0 } ?? 0
        numberLastTurn[lastNumber] = lastTurn
        lastNumber = nextNumber
        lastTurn += 1
        return nextNumber
    }
}
private func parseLines() -> [Int] {
    readLines("day15").flatMap { $0.split(separator: ",").map { Int($0)! } }
}
extension IteratorProtocol {
    func nth(_ n: Int) -> Element? {
        Array(AnyIterator(self).dropFirst(n - 1).prefix(1)).first
    }
}

public func day15a() -> Int {
    LastSpoken(initialNumbers: parseLines()).nth(2020)!
}
public func day15b() -> Int {
    LastSpoken(initialNumbers: parseLines()).nth(30000000)!
}
