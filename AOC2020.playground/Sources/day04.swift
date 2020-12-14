import Foundation

enum Height {
    case centimeters(Int), inches(Int)
    init?(_ text: String) {
        let length = Int(text.dropLast(2))
        if let length = length, text.hasSuffix("cm") {
            self = .centimeters(length)
        }
        else if let length = length, text.hasSuffix("in") {
            self = .inches(length)
        }
        else {
            return nil
        }
    }
    var isValid: Bool {
        switch self {
        case .centimeters(let l):
            return (150...193).contains(l)
        case .inches(let l):
            return (59...76).contains(l)
        }
    }
}

func passportsData() -> [[String]] {
    let lines = readLines("day04")
    var passports = [[String]]()
    var current = [String]()
    for line in lines {
        if line.isEmpty {
            passports.append(current)
            current = []
        }
        else {
            current.append(contentsOf: line.split(separator: " ").map { String($0) })
        }
    }
    passports.append(current)
    return passports
}

public func day04a() -> Int {
    let validKeys = Set(arrayLiteral: "byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid")
    return passportsData().lazy
        .map { Set($0.map { String($0.split(separator: ":")[0]) }) }
        .reduce(0) { $0 + (validKeys.isSubset(of: $1) ? 1 : 0) }
}


let hairColor = try! NSRegularExpression(pattern: "^#" + Array(repeating: "[0-9a-f]", count: 6).joined() + "$")
let eyeColors = Set(arrayLiteral: "amb", "blu", "brn", "gry", "grn", "hzl", "oth")
let pid = try! NSRegularExpression(pattern: "^" + Array(repeating: "\\d", count: 9).joined() + "$")
func isValid(pass: [String: String]) -> Bool {
    Int(pass["byr"]).map { (1920...2002).contains($0) } == true &&
    Int(pass["iyr"]).map { (2010...2020).contains($0) } == true &&
    Int(pass["eyr"]).map { (2020...2030).contains($0) } == true &&
    pass["hgt"].map { Height($0)?.isValid } == true &&
    hairColor.matches(pass["hcl"] ?? "") &&
    pass["ecl"].map { eyeColors.contains($0) } == true &&
    pid.matches(pass["pid"] ?? "")
}
public func day04b() -> Int {
    passportsData().lazy
        .map { $0.map { $0.split(separator: ":").map { String($0) } } }
        .map { Dictionary(uniqueKeysWithValues: $0.map { ($0[0], $0[1]) }) }
        .filter(isValid)
        .count
}

extension Int {
    init?(_ text: String?) {
        guard let text = text, let value = Int(text) else { return nil }
        self = value
    }
}
