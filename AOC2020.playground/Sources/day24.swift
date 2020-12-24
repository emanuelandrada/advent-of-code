import Foundation

struct HexLocation: Equatable, Hashable {
    let we: Int
    let ns: Int

    init (we: Int = 0, ns: Int = 0) {
        self.we = we
        self.ns = ns
    }

    func moving(to direction: HexDirection) -> HexLocation {
        switch direction {
        case .e: return HexLocation(we: we + 2, ns: ns)
        case .se: return HexLocation(we: we + 1, ns: ns + 1)
        case .sw: return HexLocation(we: we - 1, ns: ns + 1)
        case .w: return HexLocation(we: we - 2, ns: ns)
        case .nw: return HexLocation(we: we - 1, ns: ns - 1)
        case .ne: return HexLocation(we: we + 1, ns: ns - 1)
        }
    }
    var adjacentTiles: [HexLocation] {
        [moving(to: .e), moving(to: .se), moving(to: .sw),
         moving(to: .w), moving(to: .nw), moving(to: .ne)]
    }
}
enum HexDirection: String {
    case e, se, sw, w, nw, ne
}

let directionsRegEx = try! NSRegularExpression(pattern: "[ns]?[we]")
private func parseLines() -> AnySequence<[HexDirection]> {
    AnySequence(readLines("day24").lazy.map {
        directionsRegEx.captureGroups(string: $0).map { HexDirection(rawValue: $0[0])! }
    })
}
func initialTiles() -> Set<HexLocation> {
    parseLines().map { route in
        route.reduce(HexLocation()) { $0.moving(to: $1) }
    }.reduce(into: Set<HexLocation>()) { (flipped, location) in
        if flipped.contains(location) {
            flipped.remove(location)
        }
        else {
            flipped.insert(location)
        }
    }
}

public func day24a() -> Int {
    initialTiles().count
}

public func day24b() -> Int {
    func dayFlip(tiles: Set<HexLocation>) -> Set<HexLocation> {
        tiles.reduce(into: Set<HexLocation>()) { fp, l in
            fp.insert(l)
            fp.formUnion(l.adjacentTiles)
        }.reduce(into: Set<HexLocation>()) { newTiles, l in
            let isBlack = tiles.contains(l)
            let adjacentBlacks = l.adjacentTiles.reduce(0) { $0 + (tiles.contains($1) ? 1 : 0) }
            if (isBlack && (1...2).contains(adjacentBlacks)) ||
                (!isBlack && adjacentBlacks == 2) {
                newTiles.insert(l)
            }
        }
    }
    return (0..<100).reduce(initialTiles()) { tiles, _ in dayFlip(tiles: tiles) }.count
}
