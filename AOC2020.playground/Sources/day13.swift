import Foundation

private func parseLines() -> (time: Int, buses: [Int?]) {
    let file = readLines("day13")
    let time = Int(file.next()!)!
    return (time: time, buses: file.next()!.split(separator: ",").map { Int($0) })
}

public func day13a() -> Int {
    let (time, buses) = parseLines()
    return map(buses.compactMap { $0 }
                .map { (wait: $0 - time % $0, bus: $0) }
                .min { $0.wait < $1.wait }!)
        { $0.bus * $0.wait }
}

public func day13b() -> Int {
    parseLines().buses.enumerated()
        .compactMap { $0.element != nil ? (bus: $0.element!, delta: $0.offset) : nil }
        .reduce((timestamp: 0, step: 1)) {
            var t = $0.timestamp
            while (t + $1.delta) % $1.bus != 0 {
                t += $0.step
            }
            return (timestamp: t, step: $0.step * $1.bus)
        }
        .timestamp
}
