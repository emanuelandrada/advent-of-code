import Foundation

private func parseLines() -> [[Int]] {
    let file = readLines("day22")
    var players = [[Int]]()
    _ = file.next() // Player 1:
    players.append(file.prefix { !$0.isEmpty }.map { Int($0)! })
    _ = file.next() // Player 2:
    players.append(file.prefix { !$0.isEmpty }.map { Int($0)! })
    return players
}
private func points(_ players: [[Int]]) -> Int {
    players.flatMap { $0 }.reversed().enumerated().reduce(0) {
        $0 + $1.element * ($1.offset + 1)
    }
}

public func day22a() -> Int {
    var players = parseLines()
    while !players.reduce(false, { $0 || $1.isEmpty }) {
        let p0 = players[0].removeFirst()
        let p1 = players[1].removeFirst()
        if p0 > p1 {
            players[0].append(contentsOf: [p0, p1])
        }
        else {
            players[1].append(contentsOf: [p1, p0])
        }
    }
    return points(players)
}

public func day22b() -> Int {
    func playGame(_ players: [[Int]]) -> [[Int]] {
        var players = players
        var previousDecks = Set<[[Int]]>()
        var forceWin0 = false
        while !players.reduce(false, { $0 || $1.isEmpty }) {
            forceWin0 = forceWin0 || previousDecks.contains(players)
            previousDecks.insert(players)
            let p0 = players[0].removeFirst()
            let p1 = players[1].removeFirst()
            let win0 = forceWin0 ||
                ((players[0].count >= p0 && players[1].count >= p1) ?
                    playGame(zip(players, [p0, p1]).map { Array($0.0.prefix($0.1)) })[0].count > 0 :
                    p0 > p1)
            if win0 {
                players[0].append(contentsOf: [p0, p1])
            }
            else {
                players[1].append(contentsOf: [p1, p0])
            }
        }
        return players
    }
    return points(playGame(parseLines()))
}
