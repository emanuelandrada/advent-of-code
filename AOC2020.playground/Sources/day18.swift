import Foundation

struct OperatorPrecedences {
    let precedences: [String: Int]

    init(_ operators: [[String]]) {
        precedences = operators.enumerated().reduce(into: [String: Int]()) { p, same in
            p.merge(same.element.map { ($0, same.offset) }) { $1 }
        }
    }

    func precedes(_ operator: String, _ current: String?) -> Bool {
        guard let current = current else { return true }
        return precedences[`operator`]! <= precedences[current]!
    }
}

let exprRegExp = try! NSRegularExpression(pattern: "(\\d+|\\+|\\*|\\(|\\))")
indirect enum Expression {
    case sum(Expression, Expression)
    case product(Expression, Expression)
    case number(Int)

    init!(_ description: String, precedences: OperatorPrecedences) {
        self = .init(exprRegExp.captureGroups(string: description).map { $0.first! }, precedences: precedences)
    }

    init!<S: Sequence>(_ tokens: S, precedences: OperatorPrecedences) where S.Element == String {
        var stack = [Expression]()
        var operatorStack = [String]()
        func closePreviousOperations(_ current: String? = nil) {
            guard current != "(" else { return }
            while let op = operatorStack.last, precedences.precedes(op, current) {
                operatorStack.removeLast()
                switch op {
                case "+":
                    stack.append(.sum(stack.removeLast(), stack.removeLast()))
                case "*":
                    stack.append(.product(stack.removeLast(), stack.removeLast()))
                case "(":
                    return
                default:
                    break
                }
            }
        }
        tokens.forEach { token in
            switch token {
            case "+", "*", "(", ")":
                closePreviousOperations(token)
                if token != ")" {
                    operatorStack.append(token)
                }
            default:
                stack.append(.number(Int(token)!))
            }
        }
        closePreviousOperations()
        self = stack.last!
    }
    var result: Int {
        switch self {
        case .sum(let a, let b):
            return a.result + b.result
        case .product(let a, let b):
            return a.result * b.result
        case .number(let n):
            return n
        }
    }
}
extension Expression: CustomDebugStringConvertible {
    var debugDescription: String {
        switch self {
        case .sum(let a, let b):
            return "(\(b))+(\(a))"
        case .product(let a, let b):
            return "(\(b))*(\(a))"
        case .number(let n):
            return "\(n)"
        }
    }
}

private func parseLines(precedences: OperatorPrecedences) -> AnySequence<Expression> {
    AnySequence(readLines("day18").lazy.map { Expression($0, precedences: precedences) })
}

public func day18a() -> Int {
    parseLines(precedences: .init([["+", "*"], ["(", ")"]]))
        .map { $0.result }.reduce(0, +)
}

public func day18b() -> Int {
    parseLines(precedences: .init([["+"], ["*"], ["(", ")"]]))
        .map { $0.result }.reduce(0, +)
}
