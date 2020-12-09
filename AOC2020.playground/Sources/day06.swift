import Foundation

func groupAnswers(everyone: Bool) -> [Set<Character>] {
    let lines = readLines("day06")
    let all = Set("abcdefghijklmnopqrstuvwxyz")
    let none = Set<Character>()
    var answers = [Set<Character>]()
    var current = everyone ? all : none
    var touched = false
    for line in lines {
        if line.isEmpty {
            answers.append(current)
            current = everyone ? all : none
            touched = false
        }
        else {
            current = everyone ? current.intersection(line) : current.union(line)
            touched = true
        }
    }
    if touched {
        answers.append(current)
    }
    return answers
}

public func day06a() -> Int {
    return groupAnswers(everyone: false).lazy
        .reduce(0) { $0 + $1.count }
}

public func day06b() -> Int {
    return groupAnswers(everyone: true).lazy
        .reduce(0) { $0 + $1.count }
}
