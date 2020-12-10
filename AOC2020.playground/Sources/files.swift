import Foundation

struct TextFile: IteratorProtocol {

    init(_ path: String) {
        freopen(path, "r", stdin)
    }
    mutating func next() -> String? {
        readLine(strippingNewline: true)
    }
}

public func readLines(_ fileName: String) -> AnyIterator<String> {
    AnyIterator(TextFile(Bundle.main.path(forResource: fileName, ofType: "txt")!))
}
