import Foundation

private func parseLines() -> AnySequence<Int> {
    AnySequence(readLines("day09").compactMap { Int($0) })
}

let preambleLength = 25

public func day09a() -> Int? {
    let lines = parseLines()
    var preamble: [Int] = .init(lines.prefix(preambleLength))
    var i = 0
    func comply(_ number: Int, _ i: Int = preambleLength - 1) -> Bool {
        let complement = number - preamble[i]
        return ((complement != preamble[i]
            && preamble.prefix(i).contains(complement)))
            || (i > 1 && comply(number, i - 1))
    }
    for number in parseLines().dropFirst(preambleLength) {
        if !comply(number) {
            return number
        }
        else {
            preamble[i] = number
            i = (i + 1) % preambleLength
        }
    }
    return nil
}

public func day09b(weakness: Int) -> Int? {
    var stack = [Int]()
    var sum = 0
    for number in parseLines() {
        if sum < weakness {
            stack.append(number)
            sum += number
        }
        if sum == weakness {
            return stack.first! + stack.last!
        }
        while sum > weakness {
            sum -= stack.remove(at: 0)
        }
    }
    return nil
}
