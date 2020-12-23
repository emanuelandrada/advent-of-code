import Foundation

struct Matrix2D<Element> {
    let cols: Int
    let rows: Int
    var items: [Element]
    var transform = MatrixTransform.none

    init<T: Sequence>(_ sequence: T) where T.Element: Sequence, T.Element.Element == Element {
        var items = [Element]()
        var rows = 0
        for row in sequence {
            rows += 1
            items.append(contentsOf: row)
        }
        self.cols = items.count / rows
        self.rows = rows
        self.items = items
    }
    init(cols: Int, rows: Int, repeating element: Element) {
        self.cols = cols
        self.rows = rows
        self.items = Array(repeating: element, count: cols * rows)
    }
    init(cols: Int, rows: Int, items: [Element], transform: MatrixTransform = .none) {
        self.cols = cols
        self.rows = rows
        self.items = items
        self.transform = transform
    }

    public subscript(x: Int, y: Int) -> Element {
        get {
            items[indexFor(x: x, y: y)]
        }
        mutating set {
            items[indexFor(x: x, y: y)] = newValue
        }
    }
    public subscript(safe x: Int, y: Int) -> Element? {
        (0..<rows).contains(transform.isRotation90 ? x : y) && (0..<cols).contains(transform.isRotation90 ? y : x) ? items[indexFor(x: x, y: y)] : nil
    }
    private func indexFor(x: Int, y: Int) -> Int {
        switch transform {
        case .none: return y * cols + x
        case .clockwise90: return (rows - x - 1) * cols + y
        case .turnAround: return (rows - y - 1) * cols + (cols - x - 1)
        case .anticlockwise90: return x * cols + (cols - y - 1)
        case .flipped: return y * cols + (cols - x - 1)
        case .flippedClockwise90: return (rows - x - 1) * cols + (rows - y - 1)
        case .flippedTurnAround: return (rows - y - 1) * cols + x
        case .flippedAnticlockwise90: return x * cols + y
        }
    }
    func map<T>(_ transform: ((element: Element, x: Int, y: Int)) -> T) -> Matrix2D<T> {
        Matrix2D<T>(cols: cols, rows: rows, items: items.enumerated().map {
            transform((element: $0.element, x: $0.offset % cols, y: $0.offset / cols))
        })
    }
    func transforming(_ transform: MatrixTransform) -> Matrix2D {
        return Matrix2D(cols: cols, rows: rows, items: items, transform: transform)
    }
    @inlinable public func reduce<Result>(_ initialResult: Result, _ nextPartialResult: (Result, Element) throws -> Result) rethrows -> Result {
        try items.reduce(initialResult, nextPartialResult)
    }
}

enum MatrixTransform {
    case none, clockwise90, turnAround, anticlockwise90,
         flipped, flippedClockwise90, flippedTurnAround, flippedAnticlockwise90
    var isRotation90: Bool {
        switch self {
        case .clockwise90, .anticlockwise90, .flippedClockwise90, .flippedAnticlockwise90:
            return true
        default:
            return false
        }
    }
    static let all = [MatrixTransform.none, .clockwise90, .turnAround, .anticlockwise90, .flipped, .flippedClockwise90, .flippedTurnAround, .flippedAnticlockwise90]
}

extension Matrix2D: Equatable where Element: Equatable {
    static func ==(lhs: Self, rhs: Self) -> Bool {
        lhs.items == rhs.items
    }
}
