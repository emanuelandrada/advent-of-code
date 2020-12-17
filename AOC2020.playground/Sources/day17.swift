import Foundation

struct PocketDimension {
    var activeCubes = Set<Position>()
    subscript(position: Position) -> Bool {
        get {
            activeCubes.contains(position)
        }
        set {
            if newValue {
                activeCubes.insert(position)
            }
            else {
                activeCubes.remove(position)
            }
        }
    }
    var reactivePositions: Set<Position> {
        var retval = Set<Position>()
        for pos in activeCubes {
            retval.insert(pos)
            retval.formUnion(pos.neighbors)
        }
        return retval
    }
    func activeNeighbors(_ position: Position) -> Int {
        position.neighbors.reduce(0) { $0 + (self[$1] ? 1 : 0) }
    }
    func reacting() -> PocketDimension {
        var newSpace = PocketDimension()
        for pos in reactivePositions {
            let n = activeNeighbors(pos)
            newSpace[pos] = self[pos] ? (2...3).contains(n) : n == 3
        }
        return newSpace
    }
    func reacting(times: Int) -> PocketDimension {
        var newSpace = self
        for _ in 0..<times {
            newSpace = newSpace.reacting()
        }
        return newSpace
    }
    var activeCount: Int {
        activeCubes.count
    }
    struct Position: Hashable {
        let x: Int
        let y: Int
        let z: Int
        let w: Int?
        var neighbors: [Position] {
            ((x-1)...(x+1)).flatMap { (xx: Int) -> [Position] in
                ((y-1)...(y+1)).flatMap { (yy: Int) -> [Position] in
                    ((z-1)...(z+1)).flatMap { (zz: Int) -> [Position] in
                        (w != nil ? [w! - 1, w!, w! + 1] : [nil]).compactMap { ww in
                            (xx != x || yy != y || zz != z || ww != w) ? Position(x: xx, y: yy, z: zz, w: ww) : nil
                        }
                    }
                }
            }
        }
    }
}

private func parseLines(fourthD: Bool = false) -> PocketDimension {
    var space = PocketDimension()
    readLines("day17").enumerated().forEach { line in
        line.element.enumerated().forEach { char in
            space[PocketDimension.Position(x: char.offset, y: line.offset, z: 0, w: fourthD ? 0 : nil)] = char.element == "#"
        }
    }
    return space
}

public func day17a() -> Int {
    parseLines().reacting(times: 6).activeCount
}

public func day17b() -> Int {
    parseLines(fourthD: true).reacting(times: 6).activeCount
}
