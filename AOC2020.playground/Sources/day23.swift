import Foundation

private func parseLines() -> [Int] {
    readLines("day23").next()!.map { Int(String($0))! }
}

struct CrabCupsGame: IteratorProtocol {
    var cupsNext: [Int]
    var current: Int

    init(cups: [Int]) {
        current = cups[0]
        cupsNext = .init(repeating: 0, count: cups.count + 1)
        cupsNext[cups.last!] = cups.first!
        for i in cups.startIndex..<(cups.endIndex - 1) {
            cupsNext[cups[i]] = cups[i + 1]
        }
    }

    mutating func next() -> [Int]? {
        var removed = [cupsNext[current]]
        removed.append(cupsNext[removed.last!])
        removed.append(cupsNext[removed.last!])
        cupsNext[current] = cupsNext[removed.last!]
        var designated = current
        repeat {
            designated = designated > 1 ? designated - 1 : cupsNext.count - 1
        } while removed.contains(designated)
        let next = cupsNext[designated]
        cupsNext[designated] = removed.first!
        cupsNext[removed.last!] = next
        current = cupsNext[current]
        return cupsNext
    }
    var currentCups: [Int] {
        var cups = [Int]()
        cups.reserveCapacity(cupsNext.count - 1)
        cups.append(1)
        while cups.count < cupsNext.count - 1 {
            cups.append(cupsNext[cups.last!])
        }
        return cups
    }
}
extension IteratorProtocol {
    mutating func advance(_ n: Int) -> Self {
        (0..<n).forEach { _ in _ = self.next() }
        return self
    }
}

public func day23a() -> Int {
    var game = CrabCupsGame(cups: parseLines())
    return game.advance(100).currentCups.dropFirst().reduce(0) { $0 * 10 + $1 }
}

public func day23b() -> Int {
    var initialCups = parseLines()
    initialCups.append(contentsOf: (initialCups.count + 1)...1000000)
    var game = CrabCupsGame(cups: initialCups)
    return game.advance(10000000).currentCups.dropFirst().prefix(2).reduce(1) { $0 * $1 }
}
