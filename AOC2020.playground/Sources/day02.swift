import Foundation

struct PasswordPolicy {
    let char: Character
    let a: Int
    let b: Int
    init<S: StringProtocol>(_ description: S) {
        let parts = description.split(separator: " ")
        let range = parts[0].split(separator: "-")
        char = parts[1].last!
        a = Int(String(range[0]))!
        b = Int(String(range[1]))!
    }
    func isValidA<S: StringProtocol>(_ password: S) -> Bool {
        let count = password.filter { $0 == char }.count
        return count >= a && count <= b
    }
    func isValidB<S: StringProtocol>(_ password: S) -> Bool {
        (password[password.index(password.startIndex, offsetBy: a - 1)] == char) !=
            (password[password.index(password.startIndex, offsetBy: b - 1)] == char)
    }
}

private func parseLines() -> [(PasswordPolicy, Substring)] {
    readLines("day02").lazy
        .map { String($0).split(separator: ":") }
        .filter { $0.count > 1 }
        .map { (PasswordPolicy($0[0]), $0[1].dropFirst()) }
}

public func day02a() -> Int {
    parseLines().reduce(0) { $1.0.isValidA($1.1) ? $0 + 1 : $0 }
}

public func day02b() -> Int {
    parseLines().reduce(0) { $1.0.isValidB($1.1) ? $0 + 1 : $0 }
}
