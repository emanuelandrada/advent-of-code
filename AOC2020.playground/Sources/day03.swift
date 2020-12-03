import Foundation

public func count(right: Int, down: Int = 1) -> Int {
    let lines = readLines("day03").map { [Character]($0) }
    let width = lines[0].count
    var x = 0
    var y = 0
    var count = 0
    for line in lines.dropFirst() {
        y += 1
        if y % down == 0 {
            x = (x + right) % width
            if line[x] == "#" {
                count += 1
            }
        }
    }
    return count
}
public func day03a() -> Int {
    count(right: 3)
}
public func day03b() -> Int {
    count(right: 1) * count(right: 3) * count(right: 5) * count(right: 7) * count(right: 1, down: 2)
}
