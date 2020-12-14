import Foundation

let assignmentRegEx = try! NSRegularExpression(pattern: "^\\w+\\[?(\\d*)\\]? = (.+)$")

enum Assignment {
    case mask([Bool?])
    case mem(Int, Int)

    init?(_ description: String) {
        let captures = assignmentRegEx.captureGroups(string: description)[0]
        if let pos = Int(captures[1]) {
            self = .mem(pos, Int(captures[2])!)
        }
        else {
            self = .mask(captures[2].map { $0 == "1" ? true : $0 == "0" ? false : nil })
        }
    }
}

private func parseLines() -> AnySequence<Assignment> {
    AnySequence(readLines("day14").map { Assignment($0)! })
}

public func day14a() -> Int {
    var theMask: [Bool?] = .init(repeating: nil, count: 36)
    var memory = [Int: Int]()
    for line in parseLines() {
        switch line {
        case .mask(let newMask):
            theMask = newMask
        case .mem(let pos, let value):
            memory[pos] = theMask.reversed().enumerated()
                .reduce(0) { r, e in r + (e.element.map { $0 ? 1 << e.offset : 0 } ?? value & (1 << e.offset)) }
        }
    }
    return memory.values.reduce(0, +)
}

public func day14b() -> Int {
    var theMask: [Bool?] = .init(repeating: nil, count: 36)
    var memory = [Int: Int]()
    for line in parseLines() {
        switch line {
        case .mask(let newMask):
            theMask = newMask
        case .mem(let pos, let value):
            theMask.reversed().enumerated()
                .reduce([0]) { r, e in
                    switch e.element {
                    case .some(let m):
                        return r.map { $0 + (1 << e.offset) & (m ? 0xfffffffff : pos) }
                    case .none:
                        return r.flatMap { [$0 + (1 << e.offset), $0] }
                    }
                }.forEach {
                    memory[$0] = value
                }
        }
    }
    return memory.values.reduce(0, +)
}
