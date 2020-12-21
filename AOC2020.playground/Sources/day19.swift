import Foundation

let rulesOrRegExp = try! NSRegularExpression(pattern: "([^|]+)")
let rulesMatchRegExp = try! NSRegularExpression(pattern: "(?:(?:\"(\\w)\")|(\\d+))")
struct Rules {
    var rules: [Int: Rule]
    init(_ ruleDescriptions: [String]) {
        self.rules = ruleDescriptions
            .map { $0.split(separator: ":") }
            .reduce(into: [Int: String]()) { d, p in d[Int(String(p[0]))!] = String(p[1]) }
            .mapValues { Rule($0) }
    }
    subscript(index: Int) -> Rule {
        get { rules[index]! }
        set { rules[index] = newValue }
    }
    func matches(rule: Int, message: String) -> Bool {
        let tails = matches(rule: rules[rule]!, message: message[message.startIndex..<message.endIndex])
        return tails.first { $0.isEmpty } != nil
    }
    func matches(rule: Rule, message: Substring) -> [Substring] {
        switch rule {
        case .or(let rules):
            return rules.reduce([]) { res, rule in
                res + matches(rule: rule, message: message)
            }
        case .and(let rules):
            return rules.reduce([message]) { res, rule in
                res.flatMap { matches(rule: rule, message: $0) }
            }
        case .matchRule(let ruleIndex):
            return matches(rule: rules[ruleIndex]!, message: message)
        case .matchValue(let value):
            return message.starts(with: value) ? [message.dropFirst(value.count)] : []
        }
    }
    indirect enum Rule {
        case or([Rule])
        case and([Rule])
        case matchRule(Int)
        case matchValue(String)
        init(_ description: String) {
            self = .init(or: rulesOrRegExp.captureGroups(string: description).map { $0[0] })
        }
        init(or: [String]) {
            let ands = or.map { Rule(and: rulesMatchRegExp.captureGroups(string: $0)) }
            self = ands.count == 1 ? ands.first! : .or(ands)
        }
        init(and: [[String]]) {
            let matches = and.map { Rule(match: $0) }
            self = matches.count == 1 ? matches.first! : .and(matches)
        }
        init(match: [String]) {
            if !match[1].isEmpty {
                self = .matchValue(match[1])
            }
            else {
                self = .matchRule(Int(match[2])!)
            }
        }
    }
}

private func parseLines() -> (rules: Rules, messages: AnySequence<String>) {
    let file = readLines("day19")
    let rules = Rules(file.prefix { !$0.isEmpty })
    return (rules, AnySequence(file))
}

public func day19a() -> Int {
    let (rules, messages) = parseLines()
    return messages.filter { rules.matches(rule: 0, message: $0) }.count
}

public func day19b() -> Int {
    var (rules, messages) = parseLines()
    rules[8] = .init("42 | 42 8")
    rules[11] = .init("42 31 | 42 11 31")
    return messages.filter { rules.matches(rule: 0, message: $0) }.count
}
