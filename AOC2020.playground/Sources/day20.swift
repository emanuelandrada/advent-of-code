import Foundation

typealias Tile = (number: Int, cell: Matrix2D<Bool>)
let tileNumberRegExp = try! NSRegularExpression(pattern: "Tile (\\d+):")
private func parseLines() -> [Tile] {
    let file = readLines("day20")
    var tiles = [Tile]()
    while let line = file.next() {
        let tileNumber = Int(tileNumberRegExp.captureGroups(string: line)[0][1])!
        let matrix = Matrix2D(file.prefix { !$0.isEmpty }.map { $0.map { $0 == "#" } })
        assert(matrix.cols == 10 && matrix.rows == 10, "\(tileNumber) is a \(matrix.cols)x\(matrix.rows) matrix")
        tiles.append((tileNumber, matrix))
    }
    return tiles
}
extension Matrix2D where Element == Bool {
    var top: Int {
        (0..<cols).reduce (0) { $0 * 2 + (self[$1, 0] ? 1 : 0) }
    }
    var bottom: Int {
        (0..<cols).reduce (0) { $0 * 2 + (self[$1, rows - 1] ? 1 : 0) }
    }
    var left: Int {
        (0..<rows).reduce (0) { $0 * 2 + (self[0, $1] ? 1 : 0) }
    }
    var right: Int {
        (0..<rows).reduce (0) { $0 * 2 + (self[cols - 1, $1] ? 1 : 0) }
    }
}

func alignTiles(tiles: [Tile], help: Int?) -> Matrix2D<Tile> {
    let side = Int(sqrt(Double(tiles.count)))
    func matchAdjacents(cell: Matrix2D<Bool>, image: Matrix2D<Tile?>, x: Int, y: Int) -> Bool {
        let matchTop = (image[safe: x, y - 1]??.cell.bottom).map { $0 == cell.top } ?? true
        let matchLeft = (image[safe: x - 1, y]??.cell.right).map { $0 == cell.left } ?? true
        return matchTop && matchLeft
    }
    func validImage(tileIndex: Int = 0, current: Matrix2D<Tile?>, remaining: [Tile]) -> Matrix2D<Tile?>? {
        guard tileIndex < side * side else {
            return current
        }
        return remaining.lazy.reduce(nil) { r, tile in
            r ?? MatrixTransform.all.reduce(nil) { r, transform -> Matrix2D<Tile?>? in
                guard r == nil else { return r }
                let cell = tile.cell.transforming(transform)
                guard matchAdjacents(cell: cell, image: current, x: tileIndex % side, y: tileIndex / side) else {
                    return nil
                }
                var copy = current
                copy.items[tileIndex] = (tile.number, cell)
                var rest = remaining
                rest.removeAll { $0.number == tile.number }
                return validImage(tileIndex: tileIndex + 1, current: copy, remaining: rest)
            }
        }
    }
    var preparedTiles = tiles
    if let firstId = help, let firstTile = tiles.first(where: { $0.number == firstId }) {
        preparedTiles.removeAll { $0.number == firstId }
        preparedTiles.insert(firstTile, at: 0)
    }
    return validImage(current: .init(cols: side, rows: side, repeating: nil), remaining: preparedTiles)!.map { $0.element! }
}

public func day20a(help: Int?) -> Int {
    let tiles = alignTiles(tiles: parseLines(), help: help)
    print("help: \(tiles[0, 0].number)")
    return tiles[0, 0].number * tiles[0, tiles.rows - 1].number * tiles[tiles.cols - 1, 0].number * tiles[tiles.rows - 1, tiles.cols - 1].number
}

public func day20b(help: Int?) -> Int {
    let tiles = alignTiles(tiles: parseLines(), help: help)
    let firstCell = tiles[0, 0].cell
    var image = Matrix2D(cols: tiles.cols * (firstCell.cols - 2), rows: tiles.rows * (firstCell.rows - 2), repeating: false)
    // Build image
    for x1 in 0..<tiles.cols {
        for y1 in 0..<tiles.rows {
            let cell = tiles[x1, y1].cell
            for x2 in 0..<(cell.cols - 2) {
                for y2 in 0..<(cell.rows - 2) {
                    image[x1 * (cell.cols - 2) + x2, y1 * (cell.rows - 2) + y2] = cell[x2 + 1, y2 + 1]
                }
            }
        }
    }
    // Erase monsters
    func monsterIndices(x: Int, y: Int) -> [(x: Int, y: Int)] { [
                                                                                    (x+18, y),
        (x+0, y+1),  (x+5, y+1),(x+6, y+1),  (x+11, y+1),(x+12, y+1),  (x+17, y+1),(x+18, y+1),(x+19, y+1),
         (x+1, y+2),(x+4, y+2),  (x+7, y+2),(x+10, y+2),  (x+13, y+2),(x+16, y+2),
    ]}
    MatrixTransform.all.forEach { t in
        image = image.transforming(t)
        for x in 0...(image.cols - 20) {
            for y in 0...(image.rows - 3) {
                let indices = monsterIndices(x: x, y: y)
                if indices.reduce(true, { $0 && image[$1.x, $1.y] }) {
                    indices.forEach { image[$0.x, $0.y] = false }
                }
            }
        }
    }
    return image.items.reduce(0) { $0 + ($1 ? 1 : 0) }
}
