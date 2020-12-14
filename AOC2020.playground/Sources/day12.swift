import Foundation

enum Movement {
    case north, south, east, west, left, right, forward
    init?(_ char: Character) {
        switch char {
        case "N": self = .north
        case "S": self = .south
        case "E": self = .east
        case "W": self = .west
        case "L": self = .left
        case "R": self = .right
        case "F": self = .forward
        default: return nil
        }
    }
    var direction: Direction? {
        switch self {
        case .north:
            return .north
        case .south:
            return .south
        case .east:
            return .east
        case .west:
            return .west
        default:
            return nil
        }
    }
}
enum Direction {
    case north, south, east, west
}
struct Position {
    let x: Int
    let y: Int
    let dx: Int
    let dy: Int
    init(x: Int = 0, y: Int = 0, dx: Int = 0, dy: Int = 0) {
        self.x = x
        self.y = y
        self.dx = dx
        self.dy = dy
    }
    func moving(x: Int = 0, y: Int = 0, dx: Int = 0, dy: Int = 0) -> Position {
        Position(x: self.x + x, y: self.y + y, dx: self.dx + dx, dy: self.dy + dy)
    }
    func move(_ m: Movement, _ amount: Int, waypoint: Bool = false) -> Position {
        switch m {
        case .north, .south, .east, .west:
            return waypoint ? moveWaypoint(direction: m.direction!, amount) : move(m.direction!, amount)
        case .left:
            return rotate(-amount)
        case .right:
            return rotate(amount)
        case .forward:
            return move(amount)
        }
    }
    func move(_ amount: Int) -> Position {
        moving(x: amount * dx, y: amount * dy)
    }
    func move(_ direction: Direction, _ amount: Int) -> Position {
        switch direction {
        case .north:
            return moving(y: -amount)
        case .south:
            return moving(y: +amount)
        case .east:
            return moving(x: +amount)
        case .west:
            return moving(x: -amount)
        }
    }
    func moveWaypoint(direction: Direction, _ amount: Int) -> Position {
        switch direction {
        case .north:
            return moving(dy: -amount)
        case .south:
            return moving(dy: +amount)
        case .east:
            return moving(dx: +amount)
        case .west:
            return moving(dx: -amount)
        }
    }
    func rotate(_ angle: Int) -> Position {
        switch angle {
        case -90, 270:
            return Position(x: x, y: y, dx: dy, dy: -dx)
        case -180, 180:
            return Position(x: x, y: y, dx: -dx, dy: -dy)
        case -270, 90:
            return Position(x: x, y: y, dx: -dy, dy: dx)
        default:
            return self
        }
    }
}
private func parseLines() -> AnySequence<(movement: Movement, amount: Int)> {
    AnySequence(readLines("day12").map { (Movement($0[$0.startIndex])!, Int($0.dropFirst())!) })
}

public func day12a() -> Int {
    map(parseLines().reduce(Position(dx: 1)) { p, m in
        p.move(m.movement, m.amount)
    }) { abs($0.x) + abs($0.y) }
}

public func day12b() -> Int {
    map(parseLines().reduce(Position(dx: 10, dy: -1)) { p, m in
        p.move(m.movement, m.amount, waypoint: true)
    }) { abs($0.x) + abs($0.y) }
}
