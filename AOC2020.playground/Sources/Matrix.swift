import Foundation

struct Matrix2D<Element> {
    let cols: Int
    let rows: Int
    var items: [Element]

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
    init(cols: Int, rows: Int, items: [Element]) {
        self.cols = cols
        self.rows = rows
        self.items = items
    }

    public subscript(x: Int, y: Int) -> Element {
        get {
            items[y * cols + x]
        }
        mutating set {
            items[y * cols + x] = newValue
        }
    }
    public subscript(safe x: Int, y: Int) -> Element? {
        (0..<rows).contains(y) && (0..<cols).contains(x) ? items[y * cols + x] : nil
    }
    func map<T>(_ transform: ((element: Element, x: Int, y: Int)) -> T) -> Matrix2D<T> {
        Matrix2D<T>(cols: cols, rows: rows, items: items.enumerated().map {
            transform((element: $0.element, x: $0.offset % cols, y: $0.offset / cols))
        })
    }
    @inlinable public func reduce<Result>(_ initialResult: Result, _ nextPartialResult: (Result, Element) throws -> Result) rethrows -> Result {
        try items.reduce(initialResult, nextPartialResult)
    }
}

extension Matrix2D: Equatable where Element: Equatable {
    static func ==(lhs: Self, rhs: Self) -> Bool {
        lhs.items == rhs.items
    }
}
