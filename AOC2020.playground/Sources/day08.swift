import Foundation

enum Instruction: Equatable {
    case acc(Int), jmp(Int), nop(Int)

    init(_ line: Substring) {
        let value = Int(line.dropFirst(4))!
        switch line.prefix(3) {
        case "acc":
            self = .acc(value)
        case "jmp":
            self = .jmp(value)
        default:
            self = .nop(value)
        }
    }
    func flip() -> Instruction {
        switch self {
        case .jmp(let value):
            return .nop(value)
        case .nop(let value):
            return .jmp(value)
        case .acc:
            return self
        }
    }
}
private func parseLines() -> [Instruction] {
    readLines("day08").filter { !$0.isEmpty }
        .map { Instruction($0) }
}
func execute(_ instructions: [Instruction]) -> (line: Int, accumulator: Int) {
    let count = instructions.count
    var executed = Set<Int>()
    var line = 0
    var accumulator = 0
    var done = false
    while !done && line < count {
        if executed.contains(line) {
            done = true
        }
        else {
            executed.insert(line)
            switch instructions[line] {
            case .acc(let value):
                accumulator += value
                line += 1
            case .jmp(let lines):
                line += lines
            case .nop:
                line += 1
            }
        }
    }
    return (line: line, accumulator: accumulator)
}

public func day08a() -> Int {
    let instructions = parseLines()
    return execute(instructions).accumulator
}

public func day08b() -> Int? {
    let original = parseLines()
    let finalLine = original.count
    return original.indices.lazy.filter { original[$0] != original[$0].flip() }
        .map { i -> [Instruction] in
            var copy = original
            copy[i] = copy[i].flip()
            return copy
        }
        .map(execute)
        .first { $0.line == finalLine }?
        .accumulator
}
