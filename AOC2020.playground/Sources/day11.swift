import Foundation

enum Seat: Equatable {
    case empty, occupied, floor
    init?(_ character: Character) {
        switch character {
        case "L": self = .empty
        case "#": self = .occupied
        case ".": self = .floor
        default: return nil
        }
    }
}
private func parseLines() -> Matrix2D<Seat> {
    Matrix2D(readLines("day11").map { $0.map { Seat($0)! }})
}

func updateSeats(_ seats: Matrix2D<Seat>, extend: Bool, threshold: Int) -> Matrix2D<Seat> {
    func seatAt(_ x: Int, _ y: Int, dx: Int, dy: Int) -> Seat {
        let seat = seats[safe: x + dx, y + dy]
        return extend && seat == .floor ? seatAt(x + dx, y + dy, dx: dx, dy: dy) : seat ?? .floor
    }
    func tooOccupied(x: Int, y: Int, threshold: Int) -> Bool {
        [(-1, -1), (0, -1), (1, -1), (-1, 0), (1, 0), (-1, 1), (0, 1), (1, 1)]
            .reduce(threshold) { $0 - ($0 > 0 && seatAt(x, y, dx: $1.0, dy: $1.1) == .occupied ? 1 : 0) } == 0
    }
    func predict(x: Int, y: Int) -> Seat {
        switch seats[x, y] {
        case .empty:
            return tooOccupied(x: x, y: y, threshold: 1) ? .empty : .occupied
        case .occupied:
            return tooOccupied(x: x, y: y, threshold: threshold) ? .empty : .occupied
        case .floor:
            return .floor
        }
    }
    return seats.map { predict(x: $0.x, y: $0.y) }
}

private func apply(extend: Bool, threshold: Int) -> Int {
    var seats = parseLines()
    var prevSeats = seats
    repeat {
        prevSeats = seats
        seats = updateSeats(seats, extend: extend, threshold: threshold)
    } while prevSeats != seats
    return seats.reduce(0) { $0 + ($1 == .occupied ? 1 : 0) }
}

public func day11a() -> Int {
    apply(extend: false, threshold: 4)
}

public func day11b() -> Int {
    apply(extend: true, threshold: 5)
}
