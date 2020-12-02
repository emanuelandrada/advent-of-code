import Foundation

public func day01a() -> Int? {
    let lines = readLines("day01")
    var entries = Set<Int>()
    for line in lines {
        let num = Int(line)!
        let complement = 2020 - num
        if entries.contains(complement) {
            print ("\(num) * \(complement)")
            return num * complement
        }
        else {
            entries.insert(num)
        }
    }
    return nil
}

public func day01b() -> Int? {
    let lines = readLines("day01")
    var entries = Set<Int>()
    var pairs = Dictionary<Int, (Int, Int)>()
    for line in lines {
        let num = Int(line)!
        let complement = 2020 - num
        if let pair = pairs[complement] {
            print ("\(num) * \(pair.0) * \(pair.1)")
            return num * pair.0 * pair.1
        }
        else {
            for entry in entries {
                pairs[entry + num] = (entry, num)
            }
            entries.insert(num)
        }
    }
    return nil
}
