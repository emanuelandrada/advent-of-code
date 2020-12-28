import Foundation

private func parseLines() -> (card: Int, door: Int) {
    map(readLines("day25").map { Int($0)! }) { ($0[0], $0[1]) }
}

public func loopSize(_ publicKey: Int) -> Int {
    var value = 1
    var i = 0
    repeat {
        value = (value * 7) % 20201227
        i += 1
    } while publicKey != value
    return i
}
public func encryptionKey(publicKey: Int, loopSize: Int) -> Int {
    (0..<loopSize).reduce(1) { value, _ in
        (value * publicKey) % 20201227
    }
}

public func day25a() -> Int {
    let (card, door) = parseLines()
    return encryptionKey(publicKey: door, loopSize: loopSize(card))
}
